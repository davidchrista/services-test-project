package influx

import (
	"context"
	"os"

	"github.com/InfluxCommunity/influxdb3-go/influxdb3"
)

const url = "https://eu-central-1-1.aws.cloud2.influxdata.com"
var token string
const database = "services-test-project"

var cli *influxdb3.Client
var options influxdb3.WriteOptions

func InitPublisher() {
	token = os.Getenv("INFLUXDB_TOKEN")

	var err error
	cli, err = influxdb3.New(influxdb3.ClientConfig{
		Host:  url,
		Token: token,
	})

	if err != nil {
		panic(err)
	}

	options = influxdb3.WriteOptions{
		Database: database,
	}
}

func TeardownPublisher() {
	err := cli.Close()
	if err != nil {
		panic(err)
	}
}

func Publish(sender string, val float32) {
	point := influxdb3.NewPointWithMeasurement("measurement").SetTag("sender", sender).SetField("value", val)
	if err := cli.WritePointsWithOptions(context.Background(), &options, point); err != nil {
		panic(err)
	}
}
