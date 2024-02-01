package main

import (
	"github.com/davidchrista/services-test-project/gomqtt/data"
	"github.com/davidchrista/services-test-project/gomqtt/mqtt"
)

func main() {
	mqtt.InitClient()
	ch := data.Generate()
	for {
		mqtt.Publish(<-ch)
	}
}
