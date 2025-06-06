FROM ubuntu:22.04 AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential=12.9ubuntu3 \
    cmake=3.22.1-1ubuntu1 \
    git=1:2.34.1-1ubuntu1.10 \
    g++-11=11.3.0-1ubuntu1~22.04 \
    libstdc++-11-dev=11.3.0-1ubuntu1~22.04 \
    && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 100 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 100

WORKDIR /app
COPY . .

RUN cmake -S . -B build -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_FLAGS="-static-libstdc++ -static-libgcc" && \
    cmake --build build --parallel $(nproc)

FROM ubuntu:22.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    libstdc++6=12.3.0-1ubuntu1~22.04 \
    && rm -rf /var/lib/apt/lists/*

RUN strings /usr/lib/x86_64-linux-gnu/libstdc++.so.6 | grep GLIBCXX

COPY --from=builder /app/hello_world_application/build/hello_world /usr/local/bin/
COPY --from=builder /app/solver_application/build/solver_application /usr/local/bin/

RUN mkdir -p /home/logs && \
    touch /home/logs/log.txt && \
    chmod a+rw /home/logs/log.txt

ENV LOG_PATH=/home/logs/log.txt
VOLUME /home/logs

WORKDIR /usr/local/bin
CMD ["/bin/bash"]
