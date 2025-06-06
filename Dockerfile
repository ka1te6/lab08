FROM ubuntu:22.04 AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

RUN cmake -S . -B build -DCMAKE_BUILD_TYPE=Release && \
    cmake --build build --parallel $(nproc)

FROM ubuntu:22.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    libstdc++6 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/hello_world_application/build/hello_world /usr/local/bin/
COPY --from=builder /app/solver_application/build/solver_application /usr/local/bin/

RUN mkdir -p /home/logs && \
    touch /home/logs/log.txt && \
    chmod a+rw /home/logs/log.txt

ENV LOG_PATH=/home/logs/log.txt
VOLUME /home/logs

WORKDIR /usr/local/bin
CMD ["/bin/bash"]
