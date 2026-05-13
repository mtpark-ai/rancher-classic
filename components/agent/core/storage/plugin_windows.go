package storage

import (
	"github.com/mtpark-ai/rancher-classic/agent/model"
)

// callRancherStorageVolumeAttach is not supported on windows
func CallRancherStorageVolumePlugin(volume model.Volume, action string, payload interface{}) (Response, error) {
	return Response{}, nil
}
