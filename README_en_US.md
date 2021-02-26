# Docker webdav base on caddy2

[\# 简体中文（Simplified Chinese）](README.md)

## Tags
- latest (Same as alpine)
- alpine (Build with alpine:latest)

## Usage
**WARNING!** Make sure container is running with same user:group as yourself. 
### Simple example
```sh
docker run --name webdav -v $HOME:/www -e WEBDAV_PORT=5005 -p 5005:5005 --user `id -u`:`id -g` -d boringcat/caddy2-webdav
``` 
Done! Now you can access `http://Your IP Addr:5005` in file manager to browser you files
### Docker-compose
```yml
version: "2"
service:
  webdav:
    image: boringcat/caddy2-webdav
    restart: unless-stopped
    container_name: webdav
    network_mode: bridge
    user: "1000:1000"
    environment:
      WEBDAV_PORT: 5005
      WEBDAV_USERNAME: boringcat
      WEBDAV_PASSWORD: "!n*&3#V5^&!w#^"
      WEBDAV_ALLOWIP: "192.168.0.0/16 fe80::/64"
    volumes:
      - /home/boringcat/sharefiles:/www
    ports:
      - 5005:5005
```

## Environments
|Name|Default Value|Comment|
|:-|:--|:--|
|WEBDAV_ROOT| `/www` | Root path for webdav [#See Also][1] |
|WEBDAV_PREFIX| | [#See Also][1] |
|WEBDAV_USERNAME| | HTTP BasicAuth username |
|WEBDAV_PASSWORD| | HTTP BasicAuth password |
|WEBDAV_SERVERNAME| | [**Site Address**][2] for caddy [#See Also][3] |
|WEBDAV_PORT| `80` | [**Listen port**][2] for caddy [#See Also][3] |
|WEBDAV_ALLOWIP| | Allow access ip cldrs |
|WEBDAV_ENABLETLS| | Enable tls config |
|WEBDAV_TLS_CERT| | path to cert.pem file |
|WEBDAV_TLS_KEY| | path to key.pem file |
|WEBDAV_TLS_SERVERNAME| ${WEBDAV_SERVERNAME} | Site TLS Address for caddy |
|WEBDAV_TLS_PORT| | TLS Listen port for caddy |


[1]: https://github.com/mholt/caddy-webdav
[2]: https://caddyserver.com/docs/caddyfile/concepts#addresses
[3]: https://caddyserver.com/docs/caddyfile/concepts#structure