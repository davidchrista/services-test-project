package main

import (
	"os"

	influx "github.com/davidchrista/go-influx-client"
	"github.com/davidchrista/services-test-project/goservice/handlers"
	"github.com/davidchrista/services-test-project/goservice/middle"

	"github.com/gin-gonic/gin"
)

func main() {
	influx.InitClient(influx.Config{
		Url:      "https://eu-central-1-1.aws.cloud2.influxdata.com",
		Token:    os.Getenv("INFLUXDB_TOKEN"),
		Database: "services-test-project"})

	router := gin.Default()

	router.Use(middle.CorsMiddleware()).Use(middle.AuthMiddleware())

	router.GET("/:sender", handlers.GetValuesFromSender)
	router.GET("/", handlers.GetValues)

	router.Run("0.0.0.0:4200")

	influx.TeardownClient()
}
