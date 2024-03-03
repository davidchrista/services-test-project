package main

import (
	"github.com/davidchrista/services-test-project/goservice/influx"
	"github.com/davidchrista/services-test-project/goservice/handlers"
	"github.com/davidchrista/services-test-project/goservice/middle"

	"github.com/gin-gonic/gin"
)

func main() {
	influx.InitRetriever()

	router := gin.Default()

	router.Use(middle.CorsMiddleware()).Use(middle.AuthMiddleware())

	router.GET("/:sender", handlers.GetValuesFromSender)
	router.GET("/", handlers.GetValues)

	router.Run("0.0.0.0:4200")

	influx.TeardownRetriever()
}
