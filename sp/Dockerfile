FROM centos:centos7

# Shibboleth IdPのメタデータ取得先のURLを定義する。
ENV IDP_METADATA_URL=http://idp:8080/idp/shibboleth

# SSHログインのパスワードを定義する。
ENV SSH_PASSWD "root:Docker!"

# Shibbolethをインストールするためのyumリポジトリファイルをコピーする
COPY repo/shibboleth.repo /etc/yum.repos.d/

# Shibboleth SPモジュールその他必要なものをインストールする。
RUN yum -y update \
    && yum -y install wget patch \
    && yum -y install httpd shibboleth mod_ssl php \
    && yum -y clean all

# Shibboleth SPモジュールを起動するためのスクリプトをコンテナにコピーする。
COPY bin/init.sh /usr/local/bin/    
RUN chmod +x /usr/local/bin/init.sh

# テストSP用のPHPファイルをコンテナにコピーする。
RUN mkdir /var/www/html/secure

COPY app/testsp.php /var/www/html/secure

# Shibboleth SPモジュールの設定ファイルに当てるパッチをコンテナにコピーする。
RUN mkdir /tmp/patch
COPY patch/* /tmp/patch/

# certsディレクトリに置いてある証明書をコンテナにコピーする。
# コンテナ側ではこの証明書を優先して使うようにスクリプトで制御する。
RUN mkdir /tmp/certs
COPY certs/* /tmp/certs/

# Shibboleth SPモジュールの設定ファイルにパッチを当てる。
COPY bin/apply-patch.sh /usr/local/bin/
RUN chmod 750 /usr/local/bin/apply-patch.sh && \
    /usr/local/bin/apply-patch.sh

# OpenSSHをインストールする。
RUN yum -y install openssh-server && \
    ssh-keygen -A && \
    sed -i -e 's/#Port 22/Port 2222/' /etc/ssh/sshd_config && \
    sed -i -e 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config

# Shibboleth SPモジュールを起動する。
CMD ["/usr/local/bin/init.sh"]

EXPOSE 10443 80 2222
