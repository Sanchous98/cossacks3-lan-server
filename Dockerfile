FROM ubuntu:latest

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y git g++

COPY . /app
WORKDIR /app

RUN git submodule update --init --recursive
RUN mkdir bin
RUN g++ src/*.cpp -DNDEBUG -I asio/include -lpthread -o bin/cossacks3-server

WORKDIR ./bin

EXPOSE 31523

CMD ["./cossacks3-server"]
