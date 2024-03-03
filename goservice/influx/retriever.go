package influx

import (
	"context"
	"fmt"
	"time"

	"github.com/InfluxCommunity/influxdb3-go/influxdb3"
	"github.com/apache/arrow/go/v14/arrow"
)

const url = "https://eu-central-1-1.aws.cloud2.influxdata.com"
const token = "I28tHKf4SQWeinRwndWkv0TsP_tEXbVS9RR2eYxo4sgFTWGesRSOidKKjBl24gL1ShQLN43z9S665hoGopBbjA=="
const database = "services-test-project"

var cli *influxdb3.Client
var options influxdb3.QueryOptions

func InitRetriever() {
	var err error
	cli, err = influxdb3.New(influxdb3.ClientConfig{
		Host:  url,
		Token: token,
	})

	if err != nil {
		panic(err)
	}

	options = influxdb3.QueryOptions{
		Database: database,
	}
}

func TeardownRetriever() {
	err := cli.Close()
	if err != nil {
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
	iterator, err := cli.QueryWithOptions(context.Background(), &options, query(senders))
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
