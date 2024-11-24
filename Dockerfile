FROM golang:1.23.1
# 创建并替换 sources.list 文件为国内镜像源
RUN echo "deb http://mirrors.aliyun.com/debian buster main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian buster-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian-security buster/updates main contrib non-free" >> /etc/apt/sources.list
# 安装 gcc 和 SQLite 依赖
RUN apt-get update && apt-get install -y \
    make \
    cmake \
    # gcc \
    # sqlite3 \
    && rm -rf /var/lib/apt/lists/*
# 设置环境变量，启用 CGO_ENABLED=1
# 不需要gcc则不启动
ENV CGO_ENABLED=0
# 设置工作目录
WORKDIR /app
CMD ["sh", "-c", "while true; do sleep 1; done"]

# docker build -t xubiao05/golang-sqllite:1.23.1 -f Dockerfile .