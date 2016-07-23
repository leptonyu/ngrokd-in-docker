#!/bin/sh

set -ex \
&& export DIR="$PWD" \
&& export NGROK_GO_VERSION=1.7.1 \
&& pkgroot=github.com/inconshreveable/ngrok \
&& git clone --branch "${NGROK_GO_VERSION}" https://${pkgroot}.git /ngrok \
&& sed -i.bak "s|go install|go install -a -ldflags '-s'|g" ngrok/Makefile \
&& sed -i.bak "s|code.google.com\/p\/log4go|github.com/alecthomas/log4go|g" ngrok/src/ngrok/log/logger.go \
&& cp "$DIR/root.crt" ngrok/assets/client/tls/ngrokroot.crt \
&& cd ngrok \
&& CGO_ENABLED=0 make release-client
