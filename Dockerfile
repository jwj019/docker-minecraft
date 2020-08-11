FROM openjdk:11.0.8-slim-buster

ENV paperversion 135
ENV serverjar paper-$paperversion.jar


RUN apt-get update \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*

RUN wget https://papermc.io/api/v1/paper/1.16.1/${paperversion}/download -O $serverjar
RUN echo "eula=true" > eula.txt

CMD java -server -Xms2600M -Xmx2600M -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:+ParallelRefProcEnabled -jar $serverjar nogui