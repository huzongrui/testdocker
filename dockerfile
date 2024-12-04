# FROM golang:1.17

# # 设置工作目录
# WORKDIR /app

# # 复制当前目录下的所有文件到工作目录
# COPY . .

# RUN go build -o /my-go-action

# # 设置ENTRYPOINT
# ENTRYPOINT ["/my-go-action"]
# 使用 Golang 官方的 Alpine 镜像进行构建
FROM golang:1.17-alpine AS builder

# 设置工作目录
WORKDIR /app

# 复制当前目录下的所有文件到工作目录
COPY . .

# 安装依赖并构建可执行文件
RUN go mod tidy && go build -o my-go-action

# 使用更小的基础镜像
FROM alpine:latest

# 设置工作目录
WORKDIR /app

# 复制从第一阶段构建的可执行文件到第二阶段
COPY --from=builder /app/my-go-action /app/my-go-action

# 设置ENTRYPOINT
ENTRYPOINT ["/app/my-go-action"]

EXPOSE 8080