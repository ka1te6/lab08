FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    make \
    wget

RUN wget https://github.com/Kitware/CMake/releases/download/v3.22.0/cmake-3.22.0-linux-x86_64.sh && \
    chmod +x cmake-3.22.0-linux-x86_64.sh && \
    ./cmake-3.22.0-linux-x86_64.sh --skip-license --prefix=/usr/local && \
    rm cmake-3.22.0-linux-x86_64.sh

WORKDIR /app

COPY . .

RUN cmake -S. -B_build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=_install
RUN cmake --build _build
RUN cmake --build _build --target install

ENV LOG_PATH=/home/logs/log.txt
VOLUME /home/logs

WORKDIR /app/_install/bin

ENTRYPOINT ["./hello_world"]
