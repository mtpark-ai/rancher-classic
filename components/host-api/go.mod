module github.com/mtpark-ai/rancher-classic/host-api

go 1.25.0

require (
	github.com/dgrijalva/jwt-go v3.2.0+incompatible
	github.com/docker/docker v27.3.1+incompatible
	github.com/fsouza/go-dockerclient v1.12.0
	github.com/golang/glog v1.2.2
	github.com/gorilla/context v1.1.2
	github.com/gorilla/websocket v1.5.3
	github.com/rakyll/globalconf v0.0.0-20180912185831-87f8127c421f
	github.com/rancher/event-subscriber v0.0.0-20170825233901-dddf44b13e15
	github.com/rancher/go-rancher v0.1.0
	github.com/rancher/websocket-proxy v0.0.0-20180131154541-34dabeb38f1e
	github.com/shirou/gopsutil v3.21.11+incompatible
	github.com/sirupsen/logrus v1.9.3
	github.com/vishvananda/netlink v1.3.0
	github.com/vishvananda/netns v0.0.4
	golang.org/x/net v0.52.0
	gopkg.in/check.v1 v1.0.0-20201130134442-10cb98267c6c
)

require (
	github.com/Azure/go-ansiterm v0.0.0-20210617225240-d185dfc1b5a1 // indirect
	github.com/Microsoft/go-winio v0.6.2 // indirect
	github.com/cespare/xxhash/v2 v2.3.0 // indirect
	github.com/containerd/log v0.1.0 // indirect
	github.com/distribution/reference v0.6.0 // indirect
	github.com/docker/go-connections v0.5.0 // indirect
	github.com/docker/go-units v0.5.0 // indirect
	github.com/felixge/httpsnoop v1.0.4 // indirect
	github.com/glacjay/goini v0.0.0-20161120062552-fd3024d87ee2 // indirect
	github.com/go-logr/logr v1.4.3 // indirect
	github.com/go-logr/stdr v1.2.2 // indirect
	github.com/go-ole/go-ole v1.2.6 // indirect
	github.com/gogo/protobuf v1.3.2 // indirect
	github.com/google/uuid v1.6.0 // indirect
	github.com/gorilla/mux v1.8.1 // indirect
	github.com/klauspost/compress v1.15.9 // indirect
	github.com/kr/pretty v0.3.1 // indirect
	github.com/kr/text v0.2.0 // indirect
	github.com/moby/docker-image-spec v1.3.1 // indirect
	github.com/moby/patternmatcher v0.6.0 // indirect
	github.com/moby/sys/sequential v0.5.0 // indirect
	github.com/moby/sys/user v0.1.0 // indirect
	github.com/moby/sys/userns v0.1.0 // indirect
	github.com/moby/term v0.0.0-20210619224110-3f7ff695adc6 // indirect
	github.com/morikuni/aec v1.0.0 // indirect
	github.com/opencontainers/go-digest v1.0.0 // indirect
	github.com/opencontainers/image-spec v1.1.0-rc2.0.20221005185240-3a7f492d3f1b // indirect
	github.com/patrickmn/go-cache v2.1.0+incompatible // indirect
	github.com/pborman/uuid v1.2.1 // indirect
	github.com/pkg/errors v0.9.1 // indirect
	github.com/rancher/go-rancher/v3 v3.0.0-00010101000000-000000000000 // indirect
	github.com/rogpeppe/go-internal v1.14.1 // indirect
	github.com/tklauser/go-sysconf v0.4.0 // indirect
	github.com/tklauser/numcpus v0.12.0 // indirect
	github.com/yusufpapurcu/wmi v1.2.4 // indirect
	go.opentelemetry.io/auto/sdk v1.2.1 // indirect
	go.opentelemetry.io/contrib/instrumentation/net/http/otelhttp v0.68.0 // indirect
	go.opentelemetry.io/otel v1.43.0 // indirect
	go.opentelemetry.io/otel/exporters/otlp/otlptrace/otlptracehttp v1.43.0 // indirect
	go.opentelemetry.io/otel/metric v1.43.0 // indirect
	go.opentelemetry.io/otel/trace v1.43.0 // indirect
	golang.org/x/sys v0.44.0 // indirect
	golang.org/x/time v0.15.0 // indirect
)

replace github.com/rancher/event-subscriber => ../../third_party/event-subscriber

replace github.com/rancher/go-rancher/v2 => ../../third_party/go-rancher-classic/v2

replace github.com/rancher/go-rancher/v3 => ../../third_party/go-rancher-classic/v3

replace github.com/rancher/websocket-proxy => ../../third_party/websocket-proxy
