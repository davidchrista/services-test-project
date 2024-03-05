package main

import (
	"os"

	mqtt "github.com/davidchrista/go-mqtt-client"
	"github.com/davidchrista/services-test-project/gomqttemitter/data"
)

func main() {
	mqtt.InitClient(mqtt.Config{
		Protocol: "ssl",
		Broker:   "v090e996.ala.us-east-1.emqxsl.com",
		Port:     8883,
		Topic:    "testdata/1",
		Username: "david",
		Password: os.Getenv("MQTT_PASSWORD")})
	ch := data.Generate(-1, 5.0)
	for {
		mqtt.Publish(<-ch)
	}
}
