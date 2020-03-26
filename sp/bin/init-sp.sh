#!/bin/bash

# Shibboleth SPの設定を修正するためのパッチを適用する。
cd /etc/shibboleth
for file in `\find /tmp/patch -maxdepth 1 -type f`; do
    patch -b -p0 < $file
done
