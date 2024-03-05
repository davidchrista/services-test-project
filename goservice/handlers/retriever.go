package handlers

import (
	"net/http"

	influx "github.com/davidchrista/go-influx-client"
	"github.com/gin-gonic/gin"
)

func GetValues(c *gin.Context) {
	vals := influx.Retrieve([]string{})
	c.IndentedJSON(http.StatusOK, vals)
}

func GetValuesFromSender(c *gin.Context) {
	sender := c.Param("sender")
	vals := influx.Retrieve([]string{sender})
	c.IndentedJSON(http.StatusOK, vals)
}
