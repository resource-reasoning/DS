#ifndef LOCK_MANAGER_H
#define LOCK_MANAGER_H

#include "syntax.h"
#include <pthread.h>

typedef enum lock_mode {
  UNLOCKED,
  SHARED,
  EXCLUSIVE
} lock_mode;

typedef struct lock {
  /* Mutex lock guarding access to the mode
   * and to the owners. */
  pthread_mutex_t mutex;

  /* The mode the lock is currently in. */
  lock_mode mode;

  /* The set of transactions currently
   * owning the lock. */
  tid_t owners[20];
  size_t num_owners;
} lock;

typedef lock* lock_manager;

lock_manager* lm_create();
void lm_destroy(lock_manager* lm);

/* Acquire a lock in the given mode for the given key
 * and signed by transaction with the given tid. */
void lm_acquire(lock_manager* lm, tid_t tid,
                size_t key, lock_mode mode);

/* Release the lock held by transaction tid on the
 * given key. */
void lm_release(lock_manager* lm, tid_t tid, size_t key);

#endif
