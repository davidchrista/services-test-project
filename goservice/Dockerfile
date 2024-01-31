FROM golang:alpine3.19 AS builder
ENV WORK /app
WORKDIR "$WORK"
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go mod verify
RUN CGO_ENABLED=0 go build -o dist/goservice

FROM alpine:3.19.1
ENV WORK /app
RUN mkdir -p "$WORK"
WORKDIR "$WORK"
COPY --from=builder "$WORK"/dist/goservice "$WORK"
EXPOSE 4200
CMD ["sh", "-c", "${WORK}/goservice"]