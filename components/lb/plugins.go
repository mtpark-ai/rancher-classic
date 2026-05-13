package main

// The Kubernetes controller plugin was removed in rancher-classic 1.7.0;
// see docs/ARCHITECTURE-DIFF.md ("Orchestration engines"). Only the Cattle
// controllers and HAProxy providers are registered.

import (
	// controllers
	_ "github.com/mtpark-ai/rancher-classic/lb/controller/rancher"
	_ "github.com/mtpark-ai/rancher-classic/lb/controller/rancherglb"

	// providers
	_ "github.com/mtpark-ai/rancher-classic/lb/provider/haproxy"
	_ "github.com/mtpark-ai/rancher-classic/lb/provider/rancher"
)
