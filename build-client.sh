#!/bin/sh

export DIR="$PWD"
export NGROK_GO_VERSION=1.7.1

pkgroot=github.com/inconshreveable/ngrok 

cd "$DIR"

if [ ! -d "ngrok" ]; then
  git clone --branch "${NGROK_GO_VERSION}" https://${pkgroot}.git ngrok
  sed -i.bak "s|go install|go install -a -ldflags '-s'|g" ngrok/Makefile
  sed -i.bak "s|code.google.com\/p\/log4go|github.com/alecthomas/log4go|g" ngrok/src/ngrok/log/logger.go
fi

ls root.crt.* | while read line; do
   name=${line##*.}
   cp "$DIR/$line" ngrok/assets/client/tls/ngrokroot.crt
   rm -rf "$DIR/bin/$name"
   mkdir -p "$DIR/bin/$name"
   cd "$DIR/ngrok" && CGO_ENABLED=0 make release-client && mv bin/ngrok "$DIR/bin/$name/ngrok"
   cd "$DIR/ngrok" && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 make release-client && mv bin/linux_amd64 "$DIR/bin/$name/"
   cd "$DIR/ngrok" && CGO_ENABLED=0 GOOS=windows GOARCH=amd64 make release-client && mv bin/windows_amd64 "$DIR/bin/$name/"
   cd "$DIR/ngrok" && CGO_ENABLED=0 GOOS=linux GOARCH=arm make release-client && mv bin/linux_arm "$DIR/bin/$name/"
   cd "$DIR"
done