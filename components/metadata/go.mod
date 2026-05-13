module github.com/mtpark-ai/rancher-classic/metadata

go 1.22

require (
	github.com/golang/gddo v0.0.0-20210115222349-20d68f94ee1f
	github.com/gorilla/mux v1.8.1
	github.com/juju/ratelimit v1.0.2
	github.com/rancher/event-subscriber v0.0.0-00010101000000-000000000000
	github.com/rancher/log v0.0.0-20180706193042-52031d45f5fd
	github.com/satori/go.uuid v1.2.0
	github.com/ugorji/go/codec v1.2.12
	github.com/urfave/cli v1.22.15
	gopkg.in/yaml.v2 v2.4.0
)

require (
	github.com/cpuguy83/go-md2man/v2 v2.0.4 // indirect
	github.com/gorilla/websocket v1.5.3 // indirect
	github.com/pkg/errors v0.9.1 // indirect
	github.com/rancher/go-rancher/v3 v3.0.0-00010101000000-000000000000 // indirect
	github.com/russross/blackfriday/v2 v2.1.0 // indirect
	github.com/sirupsen/logrus v1.9.4 // indirect
	golang.org/x/sys v0.13.0 // indirect
)

replace github.com/rancher/go-rancher/v2 => ../../third_party/go-rancher-classic/v2

replace github.com/rancher/go-rancher/v3 => ../../third_party/go-rancher-classic/v3

replace github.com/rancher/event-subscriber => ../../third_party/event-subscriber
