#ifndef SYNTAX_H
#define SYNTAX_H

#include <stdlib.h>

typedef enum command_type {
  READ,
  WRITE,
  SEQ
} command_type;

typedef size_t tid_t;

typedef struct command {
  /* Transaction under which the command
   * reduces. */
  tid_t tid;

  command_type type;

  /* Item key the command refers to and
   * set for the READ and WRITE types. */
  size_t key;

  /* Value written to the item for
   * the WRITE type. */
  int value;

  /* Sub-commands which are set for
   * the SEQ command type. */
  struct command* c_1;
  struct command* c_2;
} command;

typedef struct transaction {
  tid_t id;
  command* body;
} transaction;

typedef enum program_type {
  TRANSACTION,
  SEQUENTIAL,
  PARALLEL
} program_type;

typedef struct program {
  program_type type;

  /* Program body set for the
   * TRANSACTION type. */
  transaction* trans;

  /* Sub-programs which are set for
   * the SEQUENTIAL and PARALLEL types. */
  struct program* p_1;
  struct program* p_2;
} program;

command* cmd_create(command_type type);
transaction* trans_create(size_t id);
program* prog_create(program_type type);

#endif
