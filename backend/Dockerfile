FROM golang:alpine AS builder
WORKDIR /build
COPY ["go.mod", "go.sum", "./"]
RUN go mod download
COPY . .
RUN go build -o diplom-backend ./cmd/api

FROM alpine
WORKDIR /build
COPY --from=builder /build/diplom-backend .
EXPOSE 8081
ENTRYPOINT ["./diplom-backend"]