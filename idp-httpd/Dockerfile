FROM httpd:2.4.41

# TomcatとAJP連携するための設定ファイルを入れる
ADD conf/httpd-shib.conf /usr/local/apache2/conf/extra/


# 各種モジュールを有効化する
RUN sed -i -e 's/#LoadModule proxy_module modules\/mod_proxy.so/LoadModule proxy_module modules\/mod_proxy.so/g' /usr/local/apache2/conf/httpd.conf && \
    sed -i -e 's/#LoadModule proxy_ajp_module modules\/mod_proxy_ajp.so/LoadModule proxy_ajp_module modules\/mod_proxy_ajp.so/g' /usr/local/apache2/conf/httpd.conf && \
    sed -i -e 's/#LoadModule ssl_module modules\/mod_ssl.so/LoadModule ssl_module modules\/mod_ssl.so/g' /usr/local/apache2/conf/httpd.conf && \
    sed -i -e 's/#LoadModule socache_shmcb_module modules\/mod_socache_shmcb.so/LoadModule socache_shmcb_module modules\/mod_socache_shmcb.so/g' /usr/local/apache2/conf/httpd.conf && \
    sed -i -e 's/#Include conf\/extra\/httpd-ssl.conf/Include conf\/extra\/httpd-ssl.conf/g' /usr/local/apache2/conf/httpd.conf && \
    echo "Include conf/extra/httpd-shib.conf" >> /usr/local/apache2/conf/httpd.conf

# ApacheのSSL証明書をコンテナにコピーする。
ADD certs/server.crt /usr/local/apache2/conf/server.crt
ADD certs/server.key /usr/local/apache2/conf/server.key
