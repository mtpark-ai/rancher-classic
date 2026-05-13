package events

import (
	"errors"

	"github.com/mtpark-ai/rancher-classic/scheduler/scheduler"
)

// ConnectToEventStream subscribes to Cattle's event bus and dispatches
// scheduling events (prioritize / reserve / release) to the scheduler.
//
// TODO(Phase 4): rewrite against modernized event-subscriber API.
//
// Original 1.6.30 implementation called
//
//	revents.NewEventRouter(name, workerPoolSize, cattleURL, accessKey,
//	    secretKey, nil, eventHandlers, resourceName, eventsToSubscribe,
//	    revents.DefaultPingConfig)
//
// which is a 9-argument signature that was replaced upstream in 2018 by
//
//	revents.NewEventRouter(*v3.RancherClient, workerPoolSize, eventHandlers)
//
// The v2-RancherClient handler signature also became v3. Until Phase 4
// modernizes the Cattle client and re-binds the event handlers, scheduler
// will compile but ConnectToEventStream will error at runtime.
func ConnectToEventStream(cattleURL, accessKey, secretKey string, sch *scheduler.Scheduler) error {
	_ = sch
	return errors.New("scheduler.events.ConnectToEventStream: not yet implemented (Phase 4)")
}
