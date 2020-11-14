FROM openjdk:11.0.8-jre-slim-buster

ENV minecraftversion 1.16.3
ENV paperversion 244
ENV serverjar paper-$paperversion.jar

RUN apt-get update \
  && apt-get full-upgrade -y \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*

RUN useradd -m minecraft
USER minecraft
WORKDIR /home/minecraft
# server jar

RUN wget https://papermc.io/api/v1/paper/${minecraftversion}/${paperversion}/download -O $serverjar

RUN mkdir -p ~/server
WORKDIR /home/minecraft/server

RUN echo "eula=true" > eula.txt

# plugins

RUN mkdir -p plugins
RUN mkdir -p plugins/dynmap

RUN wget -q https://github.com/PryPurity/WorldBorder/releases/download/v2.1.0/WorldBorder.jar -P plugins
RUN wget -q http://dynmap.us/releases/Dynmap-3.1-beta4-spigot.jar -P plugins

# configs

ADD --chown=minecraft configs/server.properties .
ADD --chown=minecraft configs/spigot.yml .
ADD --chown=minecraft configs/bukkit.yml .
ADD --chown=minecraft configs/dynmap.configuration.txt plugins/dynmap/configuration.txt

CMD java -server -Xms2600M -Xmx2600M -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:+ParallelRefProcEnabled -jar ~/$serverjar nogui 
