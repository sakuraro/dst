FROM ubuntu:24.04
ADD dst_servers.sh /root/

WORKDIR /root

RUN apt update && apt install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG=en_US.utf8

RUN chmod u+x ./dst_servers.sh \
    && ./dst_servers.sh install_deps
RUN ./dst_servers.sh install

CMD ["./dst_servers.sh", "run", "Master"]
