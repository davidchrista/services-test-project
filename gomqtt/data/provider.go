package data

import (
	"encoding/json"
	"fmt"
	"math/rand"
	"time"
)

type Message struct {
	ID      int    `json:"id"`
	Sender  string `jsond:"sender"`
	Message string `json:"message"`
}

func Generate() <-chan string {
	ch := make(chan string)
	go func() {
		msgCount := 0
		for ; true; msgCount += 1 {
			delay := rand.Float32() * 5
			time.Sleep(time.Second * time.Duration(delay))
			var m = Message{ID: msgCount, Sender: "gomqtt", Message: fmt.Sprintf("Duration: %f", delay)}
			j, err := json.Marshal(m)
			if err == nil {
				ch <- string(j[:])
			}
		}
	}()
	return ch
}
