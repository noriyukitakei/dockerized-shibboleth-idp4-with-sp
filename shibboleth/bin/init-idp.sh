#!/bin/bash

export JAVA_HOME=/usr/lib/jvm/jre-11-openjdk
export PATH=$PATH:$JAVA_HOME/bin

cd /opt/shibboleth-idp/bin

echo "Please complete the following for your IdP environment:"
./ant.sh -Didp.target.dir=/opt/shibboleth-idp-tmp -Didp.src.dir=/opt/shibboleth-idp/ install

rm -rf /ext-mount/customized-shibboleth-idp

cp -rf /opt/shibboleth-idp/ /ext-mount/customized-shibboleth-idp/
cp -rf /opt/shibboleth-idp-tmp/* /ext-mount/customized-shibboleth-idp

# Shibbolethの設定ファイル(attribute-resolverなど)を修正するためのパッチを適用する。
cp /ext-mount/customized-shibboleth-idp/conf/attribute-resolver-ldap.xml /ext-mount/customized-shibboleth-idp/conf/attribute-resolver.xml && \
cd /ext-mount/customized-shibboleth-idp

for file in `\find /tmp/patch -maxdepth 1 -type f`; do
    patch -b -p0 < $file
done

sed -i -e s/validUntil=\"[^\"\]*\"/validUntil=\"2030-01-01T00:00:00\.999Z\"/ /ext-mount/customized-shibboleth-idp/metadata/idp-metadata.xml
