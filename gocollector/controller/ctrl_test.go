package controller

import "testing"

func TestGenerateData(t *testing.T) {
	json := `{"id":29,"Sender":"gomqttemitter","message":"Value: 10.628457"}`
	s, d, err := generateData(json)
	if err != nil {
		t.Fatal("data generation failed")
	}
	if s != "gomqttemitter" {
		t.Error("wrong sender generated")
	}
	if d != 10.628457 {
		t.Error("wrong value generated")
	}
}