FROM noriyukitakei/dockerized-shibboleth-idp4:latest

ADD shibboleth-idp/ /opt/shibboleth-idp/

RUN apk --no-cache add patch

# Shibbolethの設定ファイル(attribute-resolverなど)にパッチを当てるスクリプトをコンテナにコピーする。
COPY bin/mod-idp-conf.sh /usr/local/bin/

# Shibbolethの設定ファイル(attribute-resolverなど)に当てるパッチをコンテナにコピーする。
RUN mkdir /tmp/patch
COPY patch/* /tmp/patch/

# Shibbolethの設定ファイル(attribute-resolverなど)にパッチを当てるスクリプトを実行する。
RUN chmod 750 /usr/local/bin/mod-idp-conf.sh \
    && /usr/local/bin/mod-idp-conf.sh
