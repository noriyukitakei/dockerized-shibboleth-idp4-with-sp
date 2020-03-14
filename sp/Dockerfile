FROM centos:centos7

# Shibboleth SPモジュールその他必要なものをインストールする。
RUN yum -y update \
    && yum -y install wget patch \
    && wget http://download.opensuse.org/repositories/security://shibboleth/CentOS_7/security:shibboleth.repo -P /etc/yum.repos.d \
    && yum -y install httpd shibboleth-3.0.4-3.2 mod_ssl php \
    && yum -y clean all

# Shibboleth SPモジュールを起動するためのスクリプトをコンテナにコピーする。
COPY bin/httpd-shibd-foreground /usr/local/bin/    
RUN chmod +x /usr/local/bin/httpd-shibd-foreground

# テストSP用のPHPファイルをコンテナにコピーする。
RUN mkdir /var/www/html/secure

COPY app/testsp.php /var/www/html/secure

# Shibboleth SPモジュールの設定ファイルに当てるパッチをコンテナにコピーする。
COPY patch/* /tmp/

# Shibboleth SPモジュールの設定ファイルにパッチを当てる。
RUN cd /etc/shibboleth && \
    patch -b < /tmp/shibboleth2.xml.patch && \
    patch -b < /tmp/attribute-map.xml.patch

# # Shibboleth SPモジュールを起動する。
CMD ["/usr/local/bin/httpd-shibd-foreground"]
