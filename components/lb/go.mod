module github.com/mtpark-ai/rancher-classic/lb

go 1.22

require (
	github.com/gorilla/mux v1.8.1
	github.com/patrickmn/go-cache v2.1.0+incompatible
	github.com/rancher/event-subscriber v0.0.0-20170825233901-dddf44b13e15
	github.com/rancher/go-rancher-metadata v0.0.0-20200311180630-7f4c936a06ac
	github.com/rancher/go-rancher/v2 v2.0.0-00010101000000-000000000000
	github.com/sirupsen/logrus v1.9.3
	github.com/urfave/cli v1.22.15
)

require (
	github.com/cpuguy83/go-md2man/v2 v2.0.4 // indirect
	github.com/gorilla/websocket v1.5.3 // indirect
	github.com/pkg/errors v0.9.1 // indirect
	github.com/russross/blackfriday/v2 v2.1.0 // indirect
	golang.org/x/sys v0.0.0-20220715151400-c0bba94af5f8 // indirect
)

replace github.com/rancher/go-rancher/v2 => ../../third_party/go-rancher-classic/v2

replace github.com/rancher/go-rancher/v3 => ../../third_party/go-rancher-classic/v3

replace github.com/rancher/event-subscriber => ../../third_party/event-subscriber
