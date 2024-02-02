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

var cli mqtt.Client

func InitClient() {
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

	cli = mqtt.NewClient(opts)
	token := cli.Connect()
	if token.WaitTimeout(time.Second*3) && token.Error() != nil {
		log.Fatal(token.Error())
	}
}

func Receive() <-chan string {
	ch := make(chan string)
	qos := 0
	cli.Subscribe(topic, byte(qos), func(cli mqtt.Client, msg mqtt.Message) {
		ch <- fmt.Sprintf("Received `%s` from `%s` topic", msg.Payload(), msg.Topic())
	})
	return ch
}
