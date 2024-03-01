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
		val := rand.Float32() * 30
		for ; true; msgCount += 1 {
			delay := rand.Float32() * 5
			change := (rand.Float32()*0.5 - 0.25) * delay / 5
			val += change
			time.Sleep(time.Second * time.Duration(delay))
			var m = Message{ID: msgCount, Sender: "gomqtt", Message: fmt.Sprintf("Value: %f", val)}
			j, err := json.Marshal(m)
			if err == nil {
				ch <- string(j[:])
			}
		}
	}()
	return ch
}
