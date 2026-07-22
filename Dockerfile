# ---------- build stage ----------
FROM alpine:3.21 AS build

RUN apk add --no-cache build-base

WORKDIR /app

# asio is a git submodule; its headers must be present in the build context.
# Run `git submodule update --init --recursive` before building the image.
COPY asio/include/ asio/include/
COPY src/ src/

RUN g++ src/*.cpp -DNDEBUG -O2 -I asio/include -pthread -o /cossacks3-server

# ---------- runtime stage ----------
FROM alpine:3.21 AS runtime

# musl is in the base image; the dynamically-linked binary only needs libstdc++
# (which pulls in libgcc). Keep the runtime image minimal.
RUN apk add --no-cache libstdc++

COPY --from=build /cossacks3-server /usr/local/bin/cossacks3-server

EXPOSE 31523
USER nobody

ENTRYPOINT ["cossacks3-server"]
