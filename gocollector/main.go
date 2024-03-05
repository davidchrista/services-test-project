package main

// "replace" used in go.mod to point to local module
import (
	"os"
	"os/signal"
	"syscall"

	mqtt "github.com/davidchrista/go-mqtt-client"
	"github.com/davidchrista/services-test-project/gocollector/controller"
	"github.com/davidchrista/services-test-project/gocollector/influx"
)

func main() {
	onExit(func() {
		influx.TeardownClient()
		os.Exit(1)
	})

	mqtt.InitClient(mqtt.Config{
		Protocol: "ssl",
		Broker:   "v090e996.ala.us-east-1.emqxsl.com",
		Port:     8883,
		Topic:    "testdata/1",
		Username: "david",
		Password: os.Getenv("MQTT_PASSWORD")})
	influx.InitClient(influx.Config{
		Url:      "https://eu-central-1-1.aws.cloud2.influxdata.com",
		Token:    os.Getenv("INFLUXDB_TOKEN"),
		Database: "services-test-project"})

	controller.Collect()
}

func onExit(f func()) {
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt, syscall.SIGTERM)
	go func() {
		<-c
		f()
	}()
}
