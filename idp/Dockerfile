FROM noriyukitakei/dockerized-shibboleth-idp4:latest

# SSHログインのパスワードを定義する。
ENV SSH_PASSWD "root:Docker!"

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

# OpenSSHをインストールする。
RUN apk add openssh && \
    ssh-keygen -A && \
    sed -i -e 's/#Port 22/Port 2222/' /etc/ssh/sshd_config && \
    sed -i -e 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# 起動スクリプトをコンテナにコピーする。
COPY bin/init.sh /usr/local/bin/init.sh

RUN chmod +x /usr/local/bin/init.sh

CMD ["/usr/local/bin/init.sh"]

EXPOSE 2222
