package mqtt

import (
	"fmt"
	"log"
	"math/rand"
	"time"

	mqtt "github.com/eclipse/paho.mqtt.golang"
)

const protocol = "ssl"
const broker = "v090e996.ala.us-east-1.emqxsl.com"
const port = 8883
const topic = "testdata/1"
const username = "david"
const password = "Passw0rd"

type MqttClient struct {
	cli mqtt.Client
}

func (mqttCli *MqttClient) CreateMqttClient() {
	connectAddress := fmt.Sprintf("%s://%s:%d", protocol, broker, port)
	rand.New(rand.NewSource(time.Now().UnixNano()))
	clientID := fmt.Sprintf("go-client-%d", rand.Int())

	fmt.Println("connect address: ", connectAddress)
	opts := mqtt.NewClientOptions()
	opts.AddBroker(connectAddress)
	opts.SetUsername(username)
	opts.SetPassword(password)
	opts.SetClientID(clientID)
	opts.SetKeepAlive(time.Second * 60)

	mqttCli.cli = mqtt.NewClient(opts)
	token := mqttCli.cli.Connect()
	if token.WaitTimeout(3*time.Second) && token.Error() != nil {
		log.Fatal(token.Error())
	}
}

func (mqttCli MqttClient) Publish(payload string) {
	qos := 0
	if token := mqttCli.cli.Publish(topic, byte(qos), false, payload); token.Wait() && token.Error() != nil {
		fmt.Printf("publish failed, topic: %s, payload: %s\n", topic, payload)
	} else {
		fmt.Printf("publish success, topic: %s, payload: %s\n", topic, payload)
	}
}
