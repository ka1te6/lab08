FROM ubuntu:18.04

RUN apt update && apt install -yy gcc g++ cmake

COPY . /app
WORKDIR /app

RUN cmake -H. -Bbuild -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/app/install
RUN cmake --build build
RUN cmake --build build --target install

ENV LOG_PATH /home/logs/log.txt
VOLUME /home/logs

ENTRYPOINT ["/app/install/bin/hello_world"]
