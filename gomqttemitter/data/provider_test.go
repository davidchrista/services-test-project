package data

import (
	"encoding/json"
	"strings"
	"testing"
)

func TestGenerate(t *testing.T) {
	ch := Generate()
	s := <-ch
	var m Message
	if err := json.Unmarshal([]byte(s), &m); err != nil ||
		m.Sender != "gomqttemitter" || m.ID != 0 ||
		!strings.Contains(m.Message, "Value:") {
		t.Error("Invalid data from Generate!")
	}
}
