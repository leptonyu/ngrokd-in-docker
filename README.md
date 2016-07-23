Ngrok in docker
===

Docker compose config
```
  ngrok:
    image: icymint/ngrokd
    volumes:
      - /etc/letsencrypt/live/ngrok.icymint.me/fullchain.pem:/snakeoil.crt
      - /etc/letsencrypt/live/ngrok.icymint.me/privkey.pem:/snakeoil.key
    ports:
      - 4443:4443
      - 80:80
      - 443:443
```

Build your own image
```
  DOMAIN=youdomain.com ./build.sh
```

Use nginx
```
map $scheme $proxy_port {
 "http" "80";
 "https" "443";
 "default" "80";
}


server {
    listen 80;
    include /etc/nginx/ssl.conf;
    server_name .ngrok.icymint.me; // replace with your own domain
    ssl_certificate     /etc/letsencrypt/live/ngrok.icymint.me/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/ngrok.icymint.me/privkey.pem;
    location / {
        proxy_set_header    X-Real-IP $remote_addr;
        proxy_set_header    Host $http_host;
        proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass      $scheme://localhost:$proxy_port; // replace with ngrokd docker inner ip or localhost
    }
}
```

build ngrok client
```
  ./build-client.sh
```


If you use letsencrypt to create ssl certs, here is the relationship
```
  /etc/letsencrypt/ngrok.icymint.me/chain.pem     assets/client/tls/ngrokroot.crt
  /etc/letsencrypt/ngrok.icymint.me/fullchain.pem assets/server/tls/snakeoil.crt
  /etc/letsencrypt/ngrok.icymint.me/privkey.pem   assets/server/tls/snakeoil.key
```
