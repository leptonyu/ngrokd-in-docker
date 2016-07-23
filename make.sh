## FROM golang:alpine

set -ex \
&& export DIR="$PWD" \
&& export NGROK_GO_VERSION=1.7.1 \
&& apk add --no-cache make git \
&& pkgroot=github.com/inconshreveable/ngrok \
&& git clone --branch "${NGROK_GO_VERSION}" https://${pkgroot}.git /ngrok \
&& sed -i.bak "s|go install|go install -a -ldflags '-s'|g" /ngrok/Makefile \
&& sed -i.bak "s|code.google.com\/p\/log4go|github.com/alecthomas/log4go|g" /ngrok/src/ngrok/log/logger.go \
&& cd /ngrok \
&& GOOS=linux GOARCH=amd64 CGO_ENABLED=0 make release-server \
&& cd "$DIR" \
&& mv "/ngrok/bin/ngrokd" main \
&& cp /ngrok/assets/server/tls/snakeoil.crt snakeoil.crt \
&& cp /ngrok/assets/server/tls/snakeoil.key snakeoil.key
