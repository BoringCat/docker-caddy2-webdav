# 基于 caddy2 的 webdav 镜像

[\# English](README_en_US.md)

## 标签
- latest (跟 alpine 一样)
- alpine (基于 alpine:latest 构建的镜像)

## 用法
**警告!** 必须确保容器的用户和用户组跟当前用户一致！  
### 简单示例
```sh
docker run --name webdav -v $HOME:/www -e WEBDAV_PORT=5005 -p 5005:5005 --user `id -u`:`id -g` -d boringcat/caddy2-webdav
```
啪！很快啊！你就在文件管理器中可以访问 `http://你的IP地址:5005` 了

### docker-compose 示例
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

## 环境变量列表
|变量名|默认值|注释|
|:--|:--|:--|
|WEBDAV_ROOT| `/www` | webdav的根目录 [#参见][1] |
|WEBDAV_PREFIX| | webdav的路径前缀 [#参见][1] |
|WEBDAV_USERNAME| | 访问所需的用户名 |
|WEBDAV_PASSWORD| | 访问所需的密码 |
|WEBDAV_SERVERNAME| | Caddy 监听的 HTTP 主机名 |
|WEBDAV_PORT| `80` | Caddy 监听的 HTTP 端口 |
|WEBDAV_ALLOWIP| | 允许访问webdav的IP地址 |
|WEBDAV_ENABLETLS| | 启用HTTPS配置 |
|WEBDAV_TLS_CERT| | TLS证书 CERT文件 |
|WEBDAV_TLS_KEY| | TLS证书 KEY文件 |
|WEBDAV_TLS_SERVERNAME| | Caddy 监听的 HTTPS 主机名 |
|WEBDAV_TLS_PORT| | Caddy 监听的 HTTPS 端口 |


[1]: https://github.com/mholt/caddy-webdav