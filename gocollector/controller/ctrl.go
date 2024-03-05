package controller

import (
	"encoding/json"
	"errors"
	"fmt"
	"strconv"
	"strings"

	"github.com/davidchrista/services-test-project/gocollector/influx"
	"github.com/davidchrista/services-test-project/gocollector/mqtt"
)

type Data struct {
	Id      int    `json:"id"`
	Sender  string `json:"sender"`
	Message string `json:"message"`
}

func generateData(m string) (sender string, value float32, err error) {
	var data Data
	err = json.Unmarshal([]byte(m), &data)
	if err != nil {
		return
	}
	sender = data.Sender
	msg := data.Message
	n := strings.Fields(msg)
	if len(n) == 0 {
		err = errors.New("invalid data")
		return
	}
	d, err := strconv.ParseFloat(n[1], 32)
	value = float32(d)
	return
}

func Collect() {
	ch := mqtt.Receive()
	for {
		m := <-ch
		fmt.Println(m)
		if s, d, err := generateData(m); err == nil {
			influx.Publish(s, d)
		}
	}
}