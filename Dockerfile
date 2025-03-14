FROM ubuntu:24.04

# 替换为阿里云 Ubuntu 镜像源
RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list \
    && sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list

# 安装构建工具和依赖
RUN apt-get update && apt-get install -y \
    wget \
    make \
    build-essential \
    libgflags-dev \
    libsnappy-dev \
    zlib1g-dev \
    libbz2-dev \
    liblz4-dev \
    libzstd-dev \
    cmake \
    gcc \
    libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/*

# 下载并安装 Go 1.23.1
RUN wget https://mirrors.aliyun.com/golang/go1.23.1.linux-amd64.tar.gz -O /tmp/go.tar.gz \
    && tar -C /usr/local -xzf /tmp/go.tar.gz \
    && rm /tmp/go.tar.gz

# 设置 Go 环境变量
ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPROXY=https://goproxy.cn,direct

# 启用 CGO
ENV CGO_ENABLED=1

# 设置工作目录
WORKDIR /go/src/github.com/cubefs

CMD ["sh", "-c", "while true; do sleep 1; done"]

# docker build -t xubiao05/cubefs:1.0 -f Dockerfile .