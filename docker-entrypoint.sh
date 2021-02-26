#!/bin/sh

WRoot=${WEBDAV_ROOT:-"/www"}
WPrefix=${WEBDAV_PREFIX:-""}
WUser=${WEBDAV_USERNAME:-""}
WPass=${WEBDAV_PASSWORD:-""}

CADDYFILE="/tmp/Caddyfile"

echo "http://${WEBDAV_SERVERNAME}:${WEBDAV_PORT:-80} {
  log {
    output stderr
  }" > ${CADDYFILE}
if [ ! -z "${WUser}" -a ! -z "${WPass}" ]; then
  HASH_PASSWORD=`caddy hash-password --plaintext "${WPass}"`
  echo "  basicauth / {
    \"${WUser}\" \"${HASH_PASSWORD}\"
  }" >> ${CADDYFILE}
fi
echo "  root * ${WRoot}
  route {" >> ${CADDYFILE}
if [ ! -z "${WPrefix}" ]; then
  echo "    rewrite ${WPrefix} ${WPrefix}/
    rewrite / ${WPrefix}/
    webdav ${WPrefix}/* {
      prefix ${WPrefix}
    }" >> ${CADDYFILE}
else
  echo "    webdav" >> ${CADDYFILE}
fi
echo "  }
}" >> ${CADDYFILE}

echo "*****************"
echo "Run with caddyfile:"
cat ${CADDYFILE}
echo "*****************"

exec /usr/local/sbin/caddy run -config ${CADDYFILE}
