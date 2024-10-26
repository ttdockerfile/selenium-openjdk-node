FROM selenium/standalone-chrome:123

# 设置环境变量
ENV NODE_VERSION=20.x
# 安装OpenJDK 11
USER root
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk curl ca-certificates && \
    curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION} | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 设置JAVA_HOME环境变量
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64

# 添加JAVA_HOME到PATH
ENV PATH $JAVA_HOME/bin:$PATH