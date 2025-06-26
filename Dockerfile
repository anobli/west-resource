FROM zephyrprojectrtos/ci:latest

COPY assets/ /opt/resource/
RUN chmod +x /opt/resource/*