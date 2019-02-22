# BUILD
FROM golang:1.11-alpine as builder

RUN apk add --no-cache git mercurial 

ENV p $GOPATH/src/github.com/werberson/dejavu

RUN mkdir -p ${p}

ADD ./ ${p}
WORKDIR ${p}
RUN go get -v ./...

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /metrics-sample main.go

## PKG
FROM alpine

COPY --from=builder /metrics-sample /go/bin/
ADD web/ui/static/index.html /

ENTRYPOINT [ "/go/bin/metrics-sample" ]

CMD [ "serve" ]
