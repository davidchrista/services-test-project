package main

import (
	"github.com/davidchrista/services-test-project/gomqttemitter/data"
	"github.com/davidchrista/services-test-project/gomqttemitter/mqtt"
)

func main() {
	mqtt.InitClient()
	ch := data.Generate(-1, 5.0)
	for {
		mqtt.Publish(<-ch)
	}
}
