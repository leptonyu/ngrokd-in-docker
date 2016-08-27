FROM golang:alpine
### FROM in make.sh

ARG PACK=true

COPY upx /bin/upx
COPY make.sh make.sh

RUN chmod +x make.sh  && ./make.sh  && eval [ -f main ]  && if [ "$PACK" = "true" ]; then          chmod +x /bin/upx       && upx --lzma --best main   ; fi  && echo "FROM scratch"            > Dockerfile  && echo "ADD main snakeoil.* /"       >> Dockerfile  && echo "ENTRYPOINT [\"/main\",\"-log-level=WARNING\",\"-domain=ngrok.icymint.me\",\"-tlsCrt=/snakeoil.crt\",\"-tlsKey=/snakeoil.key\"]" >> Dockerfile

CMD tar -cf - snakeoil.crt snakeoil.key main Dockerfile
