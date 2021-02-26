#!/bin/sh

WEBDAV_TLS_SERVERNAME=${WEBDAV_TLS_SERVERNAME:-${WEBDAV_SERVERNAME}}
export XDG_CONFIG_HOME=/tmp
CADDYFILE="/tmp/Caddyfile"
mkdir -p ${XDG_CONFIG_HOME}/caddy

function global_config() {
  echo "{
  auto_https off
  admin unix//tmp/caddy/admin.sock
}"
}

function create_config() {
  global_config
  local routepath=''
  echo "(webdavconf) {
  log {
    output stderr
  }"
  if [ ! -z "${WEBDAV_ALLOWIP}" ]; then
    echo "  @allow {
    remote_ip ${WEBDAV_ALLOWIP}
  }"
    echo "  respond \"403 Forbidden\" 403 {
    close
  }"
  routepath=" @allow"
  fi
  echo "  route${routepath} {
    root * ${WEBDAV_ROOT:-"/www"}"
  if [ ! -z "${WEBDAV_USERNAME}" -a ! -z "${WEBDAV_PASSWORD}" ]; then
    HASH_PASSWORD=`caddy hash-password --plaintext "${WEBDAV_PASSWORD}"`
    echo "    basicauth / {
      \"${WEBDAV_USERNAME}\" \"${HASH_PASSWORD}\"
    }"
  fi
  if [ ! -z "${WEBDAV_PREFIX}" ]; then
    echo "    rewrite ${WEBDAV_PREFIX} ${WEBDAV_PREFIX}/
    rewrite / ${WEBDAV_PREFIX}/
    webdav ${WEBDAV_PREFIX}/* {
      prefix ${WEBDAV_PREFIX}
    }"
  else
    echo "    webdav"
  fi
  echo "  }
}"
}

create_config > ${CADDYFILE}

echo "http://${WEBDAV_SERVERNAME}:${WEBDAV_PORT:-80} {
  import webdavconf
}" >> ${CADDYFILE}
if [ ! -z "${WEBDAV_ENABLETLS}" ]; then
  if [ ! -z "${WEBDAV_TLS_CERT}" -a ! -z "${WEBDAV_TLS_KEY}" -a ! -z "${WEBDAV_TLS_SERVERNAME}" ]; then
    echo "https://${WEBDAV_TLS_SERVERNAME}:${WEBDAV_TLS_PORT:-443} {
  tls ${WEBDAV_TLS_CERT} ${WEBDAV_TLS_KEY}
  import webdavconf
}" >> ${CADDYFILE}
  else
    echo "***************** Notify *****************"
    echo "TLS will not enable. Please check your config"
    echo
    echo "  enable (WEBDAV_ENABLETLS): \"${WEBDAV_ENABLETLS:-Empty!}\""
    echo "  server_name (WEBDAV_TLS_SERVERNAME): \"${WEBDAV_TLS_SERVERNAME:-Empty!}\""
    echo "  certfile (WEBDAV_TLS_CERT): \"${WEBDAV_TLS_CERT:-Empty!}\""
    echo "  keyfile (WEBDAV_TLS_KEY): \"${WEBDAV_TLS_KEY:-Empty!}\""
    echo "*************** End Notify ***************"
  fi
fi

echo "*************** Caddyfile ***************"
cat ${CADDYFILE}
echo "****************************************"

exec /usr/local/sbin/caddy run -config ${CADDYFILE}
