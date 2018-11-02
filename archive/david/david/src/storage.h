#ifndef STORAGE_H
#define STORAGE_H

#include <stdlib.h>

typedef struct storage {
  size_t capacity;
  int* storage;
} storage;

storage* db_create(size_t capacity);
void db_destroy(storage* db);

int db_read(storage* db, size_t key);
void db_write(storage* db, size_t key, int value);

#endif
