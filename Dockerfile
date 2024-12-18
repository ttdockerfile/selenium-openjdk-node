FROM linuxserver/chromium

# 安装OpenJDK 11和 node 20
USER root
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk curl ca-certificates && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    # 检测架构并设置 URL 和 JAVA_HOME
    arch="$(dpkg --print-architecture)"; arch="${arch##*-}"; \
    case "$arch" in \
        'amd64') \
            JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"; \
        ;; \
        'arm64') \
            JAVA_HOME="/usr/lib/jvm/java-11-openjdk-arm64"; \
        ;; \
        *) \
            echo "Unsupported architecture: $arch" >&2; exit 1; \
        ;; \
    esac; \
    # 将 JAVA_HOME 写入 shell 的默认环境
    echo "export JAVA_HOME=${JAVA_HOME}" >> /etc/profile.d/java.sh; \
    echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile.d/java.sh; \
    chmod +x /etc/profile.d/java.sh; \
    \
    # 清理
    rm -rf \
        /tmp/* \
        /usr/share/doc/* \
        /var/cache/* \
        /var/lib/apt/lists/* \
        /var/tmp/* \
        /var/log/*

# 在启动时动态加载 JAVA_HOME
ENTRYPOINT ["/bin/bash", "-c", "source /etc/profile && exec \"$@\"", "--"]