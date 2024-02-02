package main

// "replace" used in go.mod to point to local module
import (
	"fmt"

	"github.com/davidchrista/services-test-project/gocollector/mqtt"
)

func main() {
	mqtt.InitClient()
	ch := mqtt.Receive()
	for {
		m := <-ch
		fmt.Println(m)
	}
}
