module github.com/rancher/websocket-proxy

go 1.22

require (
	github.com/dgrijalva/jwt-go v3.2.0+incompatible
	github.com/docker/go-connections v0.5.0
	github.com/gorilla/mux v1.8.1
	github.com/gorilla/websocket v1.5.3
	github.com/patrickmn/go-cache v2.1.0+incompatible
	github.com/pborman/uuid v1.2.1
	github.com/pkg/errors v0.9.1
	github.com/rakyll/globalconf v0.0.0-20180912185831-87f8127c421f
	github.com/rancher/go-rancher/v3 v3.0.0-00010101000000-000000000000
	github.com/sirupsen/logrus v1.9.3
	gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405
)

require (
	github.com/glacjay/goini v0.0.0-20161120062552-fd3024d87ee2 // indirect
	github.com/google/uuid v1.0.0 // indirect
	golang.org/x/sys v0.1.0 // indirect
)

replace github.com/rancher/go-rancher/v3 => ../go-rancher-classic/v3
