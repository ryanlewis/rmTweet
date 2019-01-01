FROM golang:alpine as builder
RUN apk update && apk add --no-cache git ca-certificates && update-ca-certificates && adduser -D -g '' appuser
COPY . $GOPATH/src/rmTweet
WORKDIR $GOPATH/src/rmTweet/
RUN go get -d -v
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -ldflags="-w -s" -o /go/bin/rmTweet

FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /go/bin/rmTweet /go/bin/rmTweet
USER appuser
ENTRYPOINT ["/go/bin/rmTweet"]
