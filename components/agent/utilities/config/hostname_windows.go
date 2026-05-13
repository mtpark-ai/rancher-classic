package config

import (
	"github.com/pkg/errors"
	"github.com/mtpark-ai/rancher-classic/agent/utilities/constants"
	"os"
)

func Hostname() (string, error) {
	hostname, err := os.Hostname()
	if err != nil {
		return "", errors.Wrap(err, constants.HostNameError)
	}
	return DefaultValue("HOSTNAME", hostname), nil
}
