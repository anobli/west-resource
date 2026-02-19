FROM zephyrprojectrtos/ci:latest

RUN apt-get update && apt-get install -y jq && rm -rf /var/lib/apt/lists/*

COPY assets/ /opt/resource/
RUN chmod +x /opt/resource/*