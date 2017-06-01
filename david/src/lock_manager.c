#include "lock_manager.h"
#include <stdbool.h>
#include <stdio.h>

bool is_owner(lock* l, tid_t tid);
void set_owner(lock* l, tid_t search, tid_t tid);
bool compatible(lock* l, tid_t tid, lock_mode mode);

lock_manager* lm_create() {
  lock_manager* lm = malloc(sizeof(lock_manager) * 10);

  for (size_t i = 0; i < 10; i++) {
    lock* l = malloc(sizeof(lock));

    l->mode = UNLOCKED;
    for (size_t t = 0; t < 20; t++) {
      l->owners[t] = 0;
    }

    lm[i] = l;
  }

  return lm;
}

void lm_destroy(lock_manager* lm) {
  for (int i = 0; i < 10; i++) {
    free(lm[i]);
  }

  free(lm);
}

void lm_acquire(lock_manager* lm, tid_t tid,
                size_t key, lock_mode mode) {

  /* Retrieve the lock for the requested key. */
  lock* l = lm[key];

  /* If the transaction already holds a lock which
   * is strict enough, let it access the key. */
  if (is_owner(l, tid) && mode <= l->mode) {
    return;
  }

  /* Keep iterating until the needed lock is
   * acquired. */
  bool granted = false;
  while (!granted) {
    /* Gain access to the protected parts of the
     * lock structure. */
    pthread_mutex_lock(&l->mutex);

    if (compatible(l, tid, mode)) {
      granted = true;
      l->mode = mode;

      /* If the transaction is not an owner already,
       * update the set of owners to include it. */
      if (!is_owner(l, tid)) {
        set_owner(l, 0, tid);
        l->num_owners++;
      }
    }

    pthread_mutex_unlock(&l->mutex);
  }
}

void lm_release(lock_manager* lm, tid_t tid, size_t key) {
  lock* l = lm[key];

  /* If the transaction never acquired the lock, skip. */
  if (!is_owner(l, tid)) {
    return;
  }

  pthread_mutex_lock(&l->mutex);

  /* Remove the transaction from the set of owners. */
  set_owner(l, tid, 0);

  if (!(l->mode == SHARED && l->num_owners > 1)) {
    /* Reset the lock mode only when no other transactions
     * are holding the lock in shared mode. */
    l->mode = UNLOCKED;
  }

  /* Reduce the number of active owners. */
  l->num_owners--;

  pthread_mutex_unlock(&l->mutex);
}

bool compatible(lock* l, tid_t tid, lock_mode mode) {
  lock_mode m = l->mode;
  size_t owners = l->num_owners;

  return m == UNLOCKED ||
         (m == SHARED &&
           (mode == SHARED ||
           (mode == EXCLUSIVE && is_owner(l, tid) && owners == 1))
         );
}

bool is_owner(lock* l, tid_t tid) {
  for (int i = 0; i < 20; i++) {
    if (l->owners[i] == tid) {
      return true;
    }
  }

  return false;
}

void set_owner(lock* l, tid_t search, tid_t tid) {
  for (int i = 0; i < 20; i++) {
    if (l->owners[i] == search)
      l->owners[i] = tid;
  }
}
