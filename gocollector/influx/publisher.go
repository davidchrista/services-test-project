package influx

import (
	"context"
	"fmt"
	"time"

	"github.com/InfluxCommunity/influxdb3-go/influxdb3"
	"github.com/apache/arrow/go/v14/arrow"
)

type Config struct {
	Url string
	Token string
	Database string
}

var cli *influxdb3.Client
var qo influxdb3.QueryOptions
var wo influxdb3.WriteOptions

func InitClient(c Config) {
	var err error
	cli, err = influxdb3.New(influxdb3.ClientConfig{
		Host:  c.Url,
		Token: c.Token,
	})

	if err != nil {
		panic(err)
	}

	qo = influxdb3.QueryOptions{
		Database: c.Database,
	}
	wo = influxdb3.WriteOptions{
		Database: c.Database,
	}
}

func TeardownClient() {
	err := cli.Close()
	if err != nil {
		panic(err)
	}
}

func Publish(sender string, val float32) {
	point := influxdb3.NewPointWithMeasurement("measurement").SetTag("sender", sender).SetField("value", val)
	if err := cli.WritePointsWithOptions(context.Background(), &wo, point); err != nil {
		panic(err)
	}
}

func query(senders []string) string {
	q := `SELECT *
FROM "measurement"
WHERE
time >= now() - interval '3 minutes'`
	if len(senders) == 0 {
		return q
	}
	s := fmt.Sprintf("'%s'", senders[0])
	for _, v := range senders[1:] {
		s += fmt.Sprintf(", '%s'", v)
	}
	return q + fmt.Sprintf("\nAND\n\"sender\" IN (%s)", s)
}

type Entry struct {
	Sender string    `json:"sender"`
	Time   time.Time `json:"time"`
	Value  float64   `json:"value"`
}

func Retrieve(senders []string) []Entry {
	iterator, err := cli.QueryWithOptions(context.Background(), &qo, query(senders))
	if err != nil {
		panic(err)
	}
	var r []Entry
	for iterator.Next() {
		v := iterator.Value()
		val := Entry{
			Sender: v["sender"].(string),
			Time:  v["time"].(arrow.Timestamp).ToTime(arrow.Nanosecond),
			Value: v["value"].(float64),
		}
		r = append(r, val)
	}
	return r
}
