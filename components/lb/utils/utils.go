package controller

import (
	"sync"
	"time"

	"github.com/sirupsen/logrus"
)

// This file used to wrap Kubernetes' workqueue / cache / wait helpers.
// Per rancher-classic 1.7.0's "no Kubernetes" scope (docs/ARCHITECTURE-DIFF.md),
// the k8s.io/kubernetes dependency was removed and a minimal in-package
// TaskQueue was reimplemented with stdlib channels.

// TaskQueue is a single-worker FIFO that invokes sync(key) for each
// enqueued string. It supports clean shutdown via Shutdown().
type TaskQueue struct {
	sync       func(string)
	mu         sync.Mutex
	items      []string
	cond       *sync.Cond
	closed     bool
	workerDone chan struct{}
}

// NewTaskQueue creates a new task queue. The worker goroutine must be
// started by calling Run.
func NewTaskQueue(syncFn func(string)) *TaskQueue {
	q := &TaskQueue{
		sync:       syncFn,
		workerDone: make(chan struct{}),
	}
	q.cond = sync.NewCond(&q.mu)
	return q
}

// Enqueue adds a key (must be a string) to the queue. Objects that are
// not strings are skipped with a log message.
func (t *TaskQueue) Enqueue(obj interface{}) {
	key, ok := obj.(string)
	if !ok {
		logrus.Infof("TaskQueue.Enqueue: dropped non-string %+v", obj)
		return
	}
	t.mu.Lock()
	t.items = append(t.items, key)
	t.cond.Signal()
	t.mu.Unlock()
}

// Requeue puts a key back at the tail with a debug log of the prior error.
func (t *TaskQueue) Requeue(key string, err error) {
	logrus.Debugf("requeuing %v, err %v", key, err)
	t.Enqueue(key)
}

// Run starts the worker goroutine and blocks until stopCh is closed.
// The period argument is accepted for API compatibility with the
// original k8s-backed implementation but is ignored — the worker reacts
// to enqueues immediately via condvar.
func (t *TaskQueue) Run(_ time.Duration, stopCh <-chan struct{}) {
	go func() {
		<-stopCh
		t.Shutdown()
	}()
	t.worker()
}

// Shutdown unblocks the worker and waits for it to exit.
func (t *TaskQueue) Shutdown() {
	t.mu.Lock()
	t.closed = true
	t.cond.Broadcast()
	t.mu.Unlock()
	<-t.workerDone
}

func (t *TaskQueue) worker() {
	defer close(t.workerDone)
	for {
		t.mu.Lock()
		for len(t.items) == 0 && !t.closed {
			t.cond.Wait()
		}
		if t.closed && len(t.items) == 0 {
			t.mu.Unlock()
			return
		}
		key := t.items[0]
		t.items = t.items[1:]
		t.mu.Unlock()

		logrus.Debugf("syncing %v", key)
		t.sync(key)
	}
}
