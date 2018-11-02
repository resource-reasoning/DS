#ifndef ENGINE_H
#define ENGINE_H

#include "storage.h"
#include "syntax.h"
#include "lock_manager.h"

typedef struct prog_state {
  storage* h;
  lock_manager* phi;

  pthread_mutex_t id_mutex;
} prog_state;

prog_state* state_create(storage* db, lock_manager* lm);

/* Reduce the given program starting from the given
 * initial state. */
void reduce(prog_state* state, program* p);

#endif
