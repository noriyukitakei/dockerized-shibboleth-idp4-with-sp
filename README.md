# ShibbolethをDockerで動かす
## 本ドキュメントは、ShibbolethをDocker環境で動かすための手順書です。Production環境での稼働は想定しておりませんので、ご承知おきのほどお願い致します。

### ファイル構成
ファイル構成は以下のとおりです。
```
.
├── README.md
├── docker-compose.yml
├── httpd
│   ├── Dockerfile
│   ├── httpd-shib.conf
│   ├── server.crt
│   └── server.key
├── openldap
│   ├── Dockerfile
│   └── init.ldif
├── shibboleth
│   ├── Dockerfile
│   └── bin
│       └── init-idp.sh
└── tomcat
    ├── Dockerfile
    └── bin
        └── build.sh
```

### コンテナ化するための手順
Dockerコンテナ化する手順は以下のとおりです。

1. まずshibbolethディレクトリにて、指定したバージョンのShibbolethの設定ファイル(/opt/shibboleth-idp配下のファイル)を作成します。このコンテナはShibbolethの設定ファイルを生成するための一時的なものです。以下のコマンドを実行します。 実行が終わると、tomcatディレクトリにcustomized-shibboleth-idpというディレクトリが作成されます。これがShibbolethの設定ファイル群です。Docketfile内のidp_versionという環境変数を変更することでShibbolethのバージョンを変更出来ます。

```
$ docker run -it -v $(pwd)/../tomcat:/ext-mount --rm shibboleth init-idp.sh
```

2. tomcatディレクトリに移動します。そこにあるDockerfileのFROMで取得してくるイメージを適宜変えることで、Shibbolethを稼働するTomcatやJavaのバージョンを変えることが出来ます。また1で作成したcustomized-shibboleth-idpの中の設定ファイルを環境に合わせて適宜編集して下さい。この設定ファイルがtomcatのコンテナにコピーされShibbolethが起動します。

3. openldapディレクリに移動します。ここにあるinit.ldifはOpenLDAPに投入する初期データをldif形式で書きます。

4. httpdディレクトリに移動します。ここにあるserver.crtとserver.keyはHTTP通信を暗号化するためのSSL証明書です。適宜環境に合わせて変更して下さい。ファイル名は必ずserver.crt(証明書)とserver.key(秘密鍵)として下さい。

5. リポジトリトップのディレクトリに移動して以下のコマンドを実行して下さい。コンテナの生成、起動が開始します。
```
$ docker-compose build
$ docker-compose up -d
```

6. Shibbolethの設定ファイルを変更したい場合は、tomcat/customized-shibboleth-idp内のファイルを変更して、以下のコマンドを実行して下さい。
```
$ docker-compose build --no-cache tomcat;docker-compose stop;docker-compose up -d
```

### Tomcat、LDAPへの接続先変更
httpdからのajpプロトコルによるTomcatへの接続先、及びShibbolethからLDAPへの接続先は、それぞれdocker-compose.yml内の環境変数にて変更出来ます。Desktop Dockerなどで起動する場合はデフォルトのままでいいかもしれませんが、Kubernetesなどで起動するときは変更する必要があります。変更対象は以下に記載のTOMCAT_HOST及びLDAP_HOSTです。

```
version: '3'
services:
  httpd:
    container_name: httpd
    build:
      context: httpd
    ports:
      - 443:443
    environment:
      # この環境変数でhttpdからのajpプロトコルによるTomcatへの接続先を定義します
      TOMCAT_HOST: "tomcat"
  tomcat:
    container_name: tomcat
    build:
      context: tomcat
    ports:
      - 8009:8009
    environment:
      # この環境変数でhibbolethからLDAPへの接続先を定義します
      LDAP_HOST: "ldap"
  ldap:
    container_name: ldap
    build:
      context: openldap
    ports:
      - '389:389'
    environment:
      LDAP_DOMAIN: "example.com"
      LDAP_ADMIN_PASSWORD: "password"
```
