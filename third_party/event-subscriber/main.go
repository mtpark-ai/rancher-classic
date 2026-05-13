package main

import (
	"github.com/sirupsen/logrus"

	// Import just so that doing a build from root will compile the important parts
	_ "github.com/rancher/event-subscriber/events"
)

func main() {
	logrus.Info("Executing main.")
}
