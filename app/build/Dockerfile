FROM golang:1.15.3-alpine3.12

WORKDIR /go/src/app
COPY ./cmd ./cmd

RUN apk update && apk add git
RUN go get -d -v github.com/lib/pq
RUN go get -v github.com/cespare/reflex
CMD reflex -r '(\.go$|go\.mod)' -s go run cmd/sampleapp/main.go
