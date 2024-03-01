package main

// "replace" used in go.mod to point to local module
import (
	"encoding/json"
	"fmt"
	"os"
	"os/signal"
	"strconv"
	"strings"
	"syscall"

	"github.com/davidchrista/services-test-project/gocollector/influx"
	"github.com/davidchrista/services-test-project/gocollector/mqtt"
)

type Data struct {
	Id      int    `json:"id"`
	Sender  string `json:"sender"`
	Message string `json:"message"`
}

func publish(m string) {
	var data Data
	error := json.Unmarshal([]byte(m), &data)
	if error == nil {
		m := data.Message
		n := strings.Fields(m)
		if len(n) > 1 {
			if d, err := strconv.ParseFloat(n[1], 32); err == nil {
				influx.Publish(data.Sender, float32(d))
			}
		}
	}
}

func onExit(f func()) {
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt, syscall.SIGTERM)
	go func() {
		<-c
		f()
	}()
}

func main() {
	onExit(func() {
		influx.TeardownPublisher()
		fmt.Println("Signal!")
		os.Exit(1)
	})

	mqtt.InitClient()
	influx.InitPublisher()
	ch := mqtt.Receive()
	for {
		m := <-ch
		fmt.Println(m)
		publish(m)
	}
}
