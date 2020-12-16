#!/bin/bash

# Shibboleth IdPが起動するまでに時間がかかって、Shibboleth SP起動時にIdPのメタデータ取得に
# 失敗するときがあるため、Shibboleth IdPのメタデータのURLにアクセスして200が返ってくるまで待つ。
status=0

while [ $status != '200' ]
do
  status=`curl -ks $IDP_METADATA_URL -o /dev/null -w '%{http_code}\n'`
  sleep 1
  echo "retrieving IdP Metada..."
done

# IdPのメタデータを取得する。$IDP_HOSTは環境変数にてIdPのホスト名を設定する。
curl -k $IDP_METADATA_URL > /etc/shibboleth/partner-metadata.xml

chmod +x /etc/shibboleth/shibd-redhat

# Shibboleth SPを起動する。
/etc/shibboleth/shibd-redhat start

# OpenSSHを起動する。
echo "$SSH_PASSWD" | chpasswd
/usr/sbin/sshd &

# Apacheを起動する。
exec httpd -DFOREGROUND
