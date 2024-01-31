package main

import (
	"fmt"
	"time"

	"github.com/davidchrista/services-test-project/gomqtt/mqtt"
)

func main() {
	client := mqtt.MqttClient{}
	client.CreateMqttClient()
	msgCount := 0
	for ; true; msgCount += 1 {
		client.Publish(fmt.Sprintf("message: %d!", msgCount))
		time.Sleep(time.Second * 1)
	}
}
