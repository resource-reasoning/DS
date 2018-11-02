#include "storage.h"
#include <assert.h>

storage* db_create(size_t capacity) {
  storage* db = malloc(sizeof(storage));
  if (db == NULL) {
    return NULL;
  }

  db->capacity = capacity;

  db->storage = calloc(capacity, sizeof(int));
  if (db->storage == NULL) {
    free(db);
    return NULL;
  }

  return db;
}

void db_destroy(storage* db) {
  free(db->storage);
  free(db);
}

int db_read(storage* db, size_t key) {
  assert(key < db->capacity);

  return db->storage[key];
}

void db_write(storage* db, size_t key, int value) {
  assert(key < db->capacity);

  db->storage[key] = value;
}
