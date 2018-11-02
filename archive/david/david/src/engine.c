#include "engine.h"
#include <pthread.h>
#include <stdio.h>

typedef struct prog_arg {
  prog_state* state;
  program* p;
} prog_arg;

void trans_reduce(prog_state* state, transaction* t);
void cmd_reduce(prog_state* state, command* c);
void* par_reduce(void* arg);

prog_state* state_create(storage* db, lock_manager* lm) {
  prog_state* state = malloc(sizeof(prog_state));

  state->h = db;
  state->phi = lm;

  return state;
}

void reduce(prog_state *state, program* p) {
  program_type type = p->type;

  switch (type) {
    case TRANSACTION: {
      trans_reduce(state, p->trans);
      break;
    }

    case SEQUENTIAL: {
      reduce(state, p->p_1);
      reduce(state, p->p_2);

      break;
    }

    case PARALLEL: {
      /* Initialize two real threads to execute both
       * programs composed in parallel. */
      pthread_t left;
      pthread_t right;

      /* Create the thread arguments for the two children. */
      prog_arg l_arg = { state, p->p_1 };
      prog_arg r_arg = { state, p->p_2 };

      /* Spawn threads to reduce the state. */
      pthread_create(&left, NULL, &par_reduce, &l_arg);
      pthread_create(&right, NULL, &par_reduce, &r_arg);

      /* Wait until both programs have finished reducing. */
      pthread_join(left, NULL);
      pthread_join(right, NULL);

      break;
    }

    default:
      /* The program has no type and is therefore
       * invalid. Exit the reduction. */
      return;
  }
}

void trans_reduce(prog_state* state, transaction* t) {
  t->body->tid = t->id;
  cmd_reduce(state, t->body);

  /* Release all locks previously acquired by the transaction. */
  for (size_t key = 0; key < state->h->capacity; key++) {
    lm_release(state->phi, t->id, key);
  }
}

void cmd_reduce(prog_state* state, command* c) {
  command_type type = c->type;

  switch (type) {
    case READ: {
      size_t key = c->key;

      /* Acquire a shared lock for key. */
      lm_acquire(state->phi, c->tid, key, SHARED);
      int val = db_read(state->h, key);
      // Do something with the read value!

      break;
    }

    case WRITE: {
      size_t key = c->key;

      /* Acquire an exclusive lock for key. */
      lm_acquire(state->phi, c->tid, key, EXCLUSIVE);
      db_write(state->h, key, c->value);

      break;
    }

    case SEQ: {
      cmd_reduce(state, c->c_1);
      cmd_reduce(state, c->c_2);
      break;
    }

    default:
      return;
  }
}

void* par_reduce(void* arg) {
  prog_arg* argument = (prog_arg*) arg;
  reduce(argument->state, argument->p);

  return NULL;
}
