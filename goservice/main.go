package main

import (
	"github.com/davidchrista/services-test-project/goservice/handlers"
	"github.com/davidchrista/services-test-project/goservice/middle"

	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()

	router.Use(middle.CorsMiddleware()).Use(middle.AuthMiddleware())

	router.GET("/albums/:id", handlers.GetAlbum)
	router.GET("/albums", handlers.GetAlbums)
	router.GET("/reduce/:id", handlers.PriceReduction)

	router.GET("/", handlers.GetHello)

	router.Run("0.0.0.0:4200")
}
