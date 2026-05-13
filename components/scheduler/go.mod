module github.com/mtpark-ai/rancher-classic/scheduler

go 1.22

require (
	github.com/pkg/errors v0.9.1
	github.com/rancher/go-rancher-metadata v0.0.0-20200311180630-7f4c936a06ac
	github.com/rancher/go-rancher/v2 v2.0.0-00010101000000-000000000000
	github.com/rancher/log v0.0.0-20180706193042-52031d45f5fd
	github.com/urfave/cli v1.22.15
	gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405
)

require (
	github.com/cpuguy83/go-md2man/v2 v2.0.4 // indirect
	github.com/gorilla/websocket v1.5.3 // indirect
	github.com/russross/blackfriday/v2 v2.1.0 // indirect
	github.com/sirupsen/logrus v1.9.3 // indirect
	golang.org/x/sys v0.0.0-20220715151400-c0bba94af5f8 // indirect
)

// go-rancher's v2 and v3 subpackages were never published as proper modules.
// Mirror them inside this monorepo under third_party/go-rancher-classic.
replace github.com/rancher/go-rancher/v2 => ../../third_party/go-rancher-classic/v2

replace github.com/rancher/go-rancher/v3 => ../../third_party/go-rancher-classic/v3

// event-subscriber's last published version still imports the old
// capital-S Sirupsen/logrus path. Mirror & patch it locally so the
// case-sensitive collision with sirupsen/logrus disappears.
replace github.com/rancher/event-subscriber => ../../third_party/event-subscriber
