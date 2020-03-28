FROM tomcat:9.0.31-jdk11-openjdk

# 必要なパッケージをインストールする
RUN apt-get update && \
    apt-get -y install expect patch

# Tomcatの設定ファイルに当てる各種パッチをコンテナにコピーする。
COPY patch/* /tmp/

# AJP(8009ポート)で待ち受けするようserver.xmlにパッチを当てる
RUN cd /usr/local/tomcat/conf && \
    patch -b < /tmp/server.xml.patch

# Shibbolethのビルド用ファイルをコンテナにコピーする。
COPY bin/build.sh /usr/local/bin/

# shibbolethの設定ファイル生成用Dockerコンテナで生成されたファイルをコンテナにコピーする
ADD customized-shibboleth-idp /opt/shibboleth-idp

# ビルドの結果作成されたidp.warをTomcatのwebappsディレクトリにコピーする。
RUN chmod 755 /usr/local/bin/build.sh && \
    /usr/local/bin/build.sh && \
    cp /opt/shibboleth-idp/war/idp.war /usr/local/tomcat/webapps
