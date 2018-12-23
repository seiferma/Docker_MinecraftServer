FROM openjdk:8-slim

WORKDIR /minecraft

ENV DATA_VOLUME=/data

RUN apt-get update && \
    apt-get install -y wget && \
    useradd -d /minecraft -M -r -s /bin/false -U minecraft && \
    chown -R minecraft:minecraft ./ && \
    mkdir -p ${DATA_VOLUME} && \
    chown minecraft:minecraft ${DATA_VOLUME} && \
    wget https://github.com/Tiiffi/mcrcon/releases/download/v0.0.5/mcrcon-0.0.5-linux-x86-64.tar.gz -O /tmp/mcrcon.tar.gz && \
    tar -xvzf /tmp/mcrcon.tar.gz && \
    rm /tmp/mcrcon.tar.gz && \
    rm LICENSE && \
    chown root:root /minecraft/mcrcon

COPY server.properties.template eula.txt init.sh start.sh ./

USER minecraft

RUN wget https://files.minecraftforge.net/maven/net/minecraftforge/forge/1.12.2-14.23.5.2796/forge-1.12.2-14.23.5.2796-installer.jar -O /tmp/forge-installer.jar && \
    java -jar /tmp/forge-installer.jar --installServer nogui && \
    rm /tmp/forge-installer.jar

COPY --chown=minecraft rcon ./

EXPOSE 25565
VOLUME ["${DATA_VOLUME}"]

ENTRYPOINT ["/bin/bash"]
CMD ["./start.sh"]
