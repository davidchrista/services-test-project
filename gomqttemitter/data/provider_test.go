package data

import (
	"encoding/json"
	"fmt"
	"strings"
	"testing"
)

func TestGenerateJSON(t *testing.T) {
	ch := Generate(1, 0.1)
	s := <-ch
	var m Message
	if err := json.Unmarshal([]byte(s), &m); err != nil ||
		m.Sender != "gomqttemitter" || m.ID != 0 ||
		!strings.Contains(m.Message, "Value:") {
		t.Error("invalid data from Generate")
	}
}

func TestGenerateCount(t *testing.T) {
	// written table style just to try it ...
	var tests = []struct {
		x, y int
	}{
		{3, 3},
		{6, 6},
		{40, 40},
	}
	for _, tt := range tests {
		testname := fmt.Sprintf("%d,%d", tt.x, tt.y)
		t.Run(testname, func(t *testing.T) {
			ch := Generate(tt.x, 0.1)
			s := []string{}
			for x := range ch {
				s = append(s, x)
			}
			if len(s) != tt.y {
				t.Errorf("wrong count: %d vs %d", tt.x, tt.y)
			}
		})
	}
}

func TestGenerateDelayZero(t *testing.T) {
	ch := Generate(1, 0.0)
	<-ch
}
