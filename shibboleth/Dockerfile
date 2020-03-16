FROM centos:centos7

# Shibbolethのバージョンを指定する。
ENV idp_version=4.0.0

# JDKをインストールする。
RUN yum -y update && \
    yum -y install wget java-11-openjdk patch

# Shibboleth をダウンロードして解凍する。
RUN wget -q https://shibboleth.net/downloads/identity-provider/$idp_version/shibboleth-identity-provider-$idp_version.tar.gz && \
    tar -zxvf  shibboleth-identity-provider-$idp_version.tar.gz -C /opt && \
    ln -s /opt/shibboleth-identity-provider-$idp_version/ /opt/shibboleth-idp

# 起動スクリプトをコンテナにコピーする。
COPY bin/ /usr/local/bin/

# Shibbolethの設定ファイル(attribute-resolverなど)に当てるパッチをコンテナにコピーする。
RUN mkdir /tmp/patch
COPY patch/* /tmp/patch/

# コンテナ起動時にShibbolethの設定ファイルを作成するためのスクリプトを実行する。
RUN chmod 750 /usr/local/bin/init-idp.sh
