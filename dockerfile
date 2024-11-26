FROM golang:1.17

# 设置工作目录
WORKDIR /app

# 复制当前目录下的所有文件到工作目录
COPY . .

RUN go build -o /my-go-action

# 设置ENTRYPOINT
ENTRYPOINT ["/my-go-action"]
