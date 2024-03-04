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

func Generate(maxNb int, delayBase float32) <-chan string {
	if delayBase <= 0.0 {
		delayBase = 0.001
	}
	ch := make(chan string)
	go func() {
		msgCount := 0
		val := rand.Float32() * 30
		for ; maxNb < 0 || msgCount < maxNb; msgCount += 1 {
			delay := rand.Float32() * delayBase
			change := (rand.Float32()*0.5 - 0.25) * delay / delayBase
			val += change
			time.Sleep(time.Second * time.Duration(delay))
			var m = Message{ID: msgCount, Sender: "gomqttemitter", Message: fmt.Sprintf("Value: %f", val)}
			j, err := json.Marshal(m)
			if err == nil {
				ch <- string(j[:])
			}
		}
		close(ch)
	}()
	return ch
}
