#!/bin/bash

# Shibboleth SPの設定を修正するためのパッチを適用する。
cd /etc/shibboleth
for file in `\find /tmp/patch -maxdepth 1 -type f`; do
    patch -b -p0 < $file
done

if [ -e /tmp/certs/server.crt -a -e /tmp/certs/server.key ]; then
  # certsディレクトリに証明書が置いてあったらそちらを優先して配置する。
  mv -f /tmp/certs/server.crt /etc/pki/tls/certs/localhost.crt
  mv -f /tmp/certs/server.key /etc/pki/tls/private/localhost.key
fi
