package main

import (
	"github.com/davidchrista/services-test-project/gomqtt/data"
	"github.com/davidchrista/services-test-project/gomqtt/mqtt"
)

func main() {
	client := mqtt.MqttClient{}
	client.CreateMqttClient()
	ch := data.Generate()
	for {
		client.Publish(<-ch)
	}
}
