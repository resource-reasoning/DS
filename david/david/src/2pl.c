#include "storage.h"
#include "syntax.h"
#include "engine.h"
#include <stdio.h>

int main(int argc, const char* argv[]) {
  storage* db = db_create(10);
  lock_manager* lm = lm_create();
  prog_state* state = state_create(db, lm);

  program *p = prog_create(TRANSACTION);
  transaction* t = trans_create(1);
  program* p2 = prog_create(TRANSACTION);
  transaction* t2 = trans_create(2);
  program* pm = prog_create(SEQUENTIAL);

  command* w = cmd_create(WRITE);
  w->tid = 1;
  w->key = 1;
  w->value = 1;

  command* r = cmd_create(WRITE);
  r->tid = 2;
  r->key = 1;
  r->value = 2;

  command* seq = cmd_create(SEQ);
  seq->c_1 = w;
  seq->c_2 = r;

  t->body = w;
  t2->body = r;
  p->trans = t;
  p2->trans = t2;
  pm->p_1 = p;
  pm->p_2 = p2;

  reduce(state, pm);

  for (int k = 0; k < db->capacity; k++) {
    printf("cell[%d] = %d\n", k, db_read(db, k));
  }

  free(w);
  free(r);
  free(seq);
  free(t);
  free(p);
  lm_destroy(lm);
  db_destroy(db);

  return 0;
}
