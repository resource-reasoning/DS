#include "syntax.h"

command* cmd_create(command_type type) {
  command* c = malloc(sizeof(command));
  if (c == NULL) {
    return NULL;
  }

  c->type = type;

  return c;
}

transaction* trans_create(size_t id) {
  transaction* t = malloc(sizeof(transaction));
  if (t == NULL) {
    return NULL;
  }

  t->id = id;

  return t;
}

program* prog_create(program_type type) {
  program* p = malloc(sizeof(program));
  if (p == NULL) {
    return NULL;
  }

  p->type = type;

  return p;
}
