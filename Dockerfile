FROM ubuntu:24.04

RUN apt update && apt install -y locales && rm -rf /var/lib/apt/lists/* \
    && locale-gen zh_CN.UTF-8
ENV LANG=zh_CN.UTF-8

WORKDIR /root
ADD dst_servers.sh /root/
RUN chmod u+x ./dst_servers.sh \
    && ./dst_servers.sh install_deps

CMD ["./dst_servers.sh", "install"]
