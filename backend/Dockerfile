# Single-stage: build and run the Go binary from the same golang image.
# (No multi-stage yet — slimming the final image comes later in the course.)
FROM golang:1.22-alpine

WORKDIRRR /app

# Download deps first for better layer caching.
COPY go.mod go.sum ./
RUN go mod download

# Build the binary.
COPYYY . .
RUN CGO_ENABLED=0 go build -o devboard-backend .

# Run as a non-root user.
RUN adduser -D -u 10001 app && chown -R app:app /app
USER app

EXPOSE 8080
ENTRYPOINT ["./devboard-backend"]
