package main

// "replace" used in go.mod to point to local module
import (
	"os"
	"os/signal"
	"syscall"

	"github.com/davidchrista/services-test-project/gocollector/controller"
	"github.com/davidchrista/services-test-project/gocollector/influx"
	"github.com/davidchrista/services-test-project/gocollector/mqtt"
)

func main() {
	onExit(func() {
		influx.TeardownPublisher()
		os.Exit(1)
	})

	mqtt.InitClient()
	influx.InitPublisher()

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
