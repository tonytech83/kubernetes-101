# Step 1 - Builds the artifact
FROM golang:1-alpine as build

WORKDIR /app
COPY cmd cmd
RUN go build cmd/hello/hello.go

# Production container
FROM alpine:latest

WORKDIR /app
COPY --from=build /app/hello /app/hello

EXPOSE 8180
ENTRYPOINT [ "./hello" ]