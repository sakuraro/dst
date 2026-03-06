FROM ubuntu:24.04
ADD dst_servers.sh /root/

WORKDIR /root
RUN chmod u+x ./dst_servers.sh \
    && ./dst_servers.sh install

CMD ["./dst_servers.sh", "run", "Master"]
