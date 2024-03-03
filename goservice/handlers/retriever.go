package handlers

import (
	"net/http"

	"github.com/davidchrista/services-test-project/goservice/influx"
	"github.com/gin-gonic/gin"
)

func GetValues(c *gin.Context) {
	vals := influx.Retrieve([]string{})
	c.IndentedJSON(http.StatusOK, vals)
}