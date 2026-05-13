module github.com/rancher/event-subscriber

go 1.22

require (
	github.com/gorilla/websocket v1.5.3
	github.com/pkg/errors v0.9.1
	github.com/rancher/go-rancher/v3 v3.0.0-00010101000000-000000000000
	github.com/sirupsen/logrus v1.9.3
)

require golang.org/x/sys v0.0.0-20220715151400-c0bba94af5f8 // indirect

replace github.com/rancher/go-rancher/v2 => ../go-rancher-classic/v2

replace github.com/rancher/go-rancher/v3 => ../go-rancher-classic/v3
