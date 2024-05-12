# Guacamole  をインストールする

# 初期設定

```shell
apt update && apt upgrade -y
apt install git maven
```

## 依存関係のソフトウェアをインストール

```shell
sudo apt install build-essential libcairo2-dev libjpeg-turbo8-dev libpng-dev libtool-bin uuid-dev libossp-uuid-dev
```

## その他必要そうなパッケージのインストール

```shell
sudo apt install libavcodec-dev libavformat-dev libavutil-dev libswscale-dev freerdp2-dev libpango1.0-dev libssh2-1-dev libvncserver-dev libssl-dev libvorbis-dev libwebp-dev
```

## Guacamole のソースを Github からダウンロード

```shell
git clone https://github.com/apache/guacamole-server.git
```
## ビルド

```shell
cd guacamole-server
autoreconf -fi
```

./configure が生成される

```shell
root@guacamole:~/guacamole-server# ls -alF
total 808
drwxr-xr-x 11 root root   4096 May 12 08:50 ./
drwx------  5 root root   4096 May 12 08:46 ../
-rw-r--r--  1 root root    639 May 12 08:46 .dockerignore
drwxr-xr-x  8 root root   4096 May 12 08:46 .git/
drwxr-xr-x  3 root root   4096 May 12 08:46 .github/
-rw-r--r--  1 root root    463 May 12 08:46 .gitignore
-rw-r--r--  1 root root   1984 May 12 08:46 CONTRIBUTING
-rw-r--r--  1 root root   6205 May 12 08:46 Dockerfile
-rw-r--r--  1 root root  11358 May 12 08:46 LICENSE
-rw-r--r--  1 root root   2687 May 12 08:46 Makefile.am
-rw-r--r--  1 root root  31832 May 12 08:50 Makefile.in
-rw-r--r--  1 root root    165 May 12 08:46 NOTICE
-rw-r--r--  1 root root   6108 May 12 08:46 README
-rw-r--r--  1 root root   3199 May 12 08:46 README-unit-testing.md
-rw-r--r--  1 root root  56229 May 12 08:50 aclocal.m4
drwxr-xr-x  2 root root   4096 May 12 08:50 autom4te.cache/
drwxr-xr-x  2 root root   4096 May 12 08:46 bin/
drwxr-xr-x  2 root root   4096 May 12 08:50 build-aux/
-rw-r--r--  1 root root   6629 May 12 08:50 config.h.in
-rwxr-xr-x  1 root root 589031 May 12 08:50 configure*
-rw-r--r--  1 root root  39562 May 12 08:46 configure.ac
drwxr-xr-x  4 root root   4096 May 12 08:46 doc/
drwxr-xr-x  2 root root   4096 May 12 08:50 m4/
drwxr-xr-x 12 root root   4096 May 12 08:46 src/
drwxr-xr-x  2 root root   4096 May 12 08:46 util/
```

```shell
./configure --with-init-dir=/etc/init.d
make
make install
```

## systemd の再読込

```shell
ldconfig
systemctl daemon-reload
```

## guacd を起動

```shell
systemctl start guacd
systemctl enable guacd
```

## guacamole-client のインストール

tomcat 必要

```shell
apt install tomcat9 tomcat9-admin tomcat9-common tomcat9-user
```

```shell
git clone https://github.com/apache/guacamole-client
```

```shell
cd guacamole-client
mvn package
```

ここまで来たらエラーでた。どうも guacamole-common でエラー出ているみたい

どうも上手くいかないので docker container で提供しているようなのでそっちを使う

その資料は[こちら](install_guacamole_docker.md)

```shell
[WARNING] Unable to autodetect 'javac' path, using 'javac' from the environment.
[INFO] ------------------------------------------------------------------------
[INFO] Reactor Summary for guacamole-client 1.5.5:
[INFO] 
[INFO] guacamole-client ................................... SUCCESS [  6.583 s]
[INFO] guacamole-common ................................... FAILURE [  0.963 s]
[INFO] guacamole-ext ...................................... SKIPPED
[INFO] guacamole-common-js ................................ SKIPPED
[INFO] guacamole .......................................... SKIPPED
[INFO] extensions ......................................... SKIPPED
[INFO] guacamole-auth-ban ................................. SKIPPED
[INFO] guacamole-auth-duo ................................. SKIPPED
[INFO] guacamole-auth-header .............................. SKIPPED
[INFO] guacamole-auth-jdbc ................................ SKIPPED
[INFO] guacamole-auth-jdbc-base ........................... SKIPPED
[INFO] guacamole-auth-jdbc-mysql .......................... SKIPPED
[INFO] guacamole-auth-jdbc-postgresql ..................... SKIPPED
[INFO] guacamole-auth-jdbc-sqlserver ...................... SKIPPED
[INFO] guacamole-auth-jdbc-dist ........................... SKIPPED
[INFO] guacamole-auth-json ................................ SKIPPED
[INFO] guacamole-auth-ldap ................................ SKIPPED
[INFO] guacamole-auth-quickconnect ........................ SKIPPED
[INFO] guacamole-auth-sso ................................. SKIPPED
[INFO] guacamole-auth-sso-base ............................ SKIPPED
[INFO] guacamole-auth-sso-cas ............................. SKIPPED
[INFO] guacamole-auth-sso-openid .......................... SKIPPED
[INFO] guacamole-auth-sso-saml ............................ SKIPPED
[INFO] guacamole-auth-sso-ssl ............................. SKIPPED
[INFO] guacamole-auth-sso-dist ............................ SKIPPED
[INFO] guacamole-auth-totp ................................ SKIPPED
[INFO] guacamole-history-recording-storage ................ SKIPPED
[INFO] guacamole-vault .................................... SKIPPED
[INFO] guacamole-vault-base ............................... SKIPPED
[INFO] guacamole-vault-ksm ................................ SKIPPED
[INFO] guacamole-vault-dist ............................... SKIPPED
[INFO] guacamole-display-statistics ....................... SKIPPED
[INFO] guacamole-example .................................. SKIPPED
[INFO] guacamole-playback-example ......................... SKIPPED
[INFO] ------------------------------------------------------------------------
[INFO] BUILD FAILURE
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  8.140 s
[INFO] Finished at: 2024-05-12T09:05:17Z
[INFO] ------------------------------------------------------------------------
[ERROR] Failed to execute goal org.apache.maven.plugins:maven-compiler-plugin:3.8.1:compile (default-compile) on project guacamole-common: Compilation failure -> [Help 1]
[ERROR] 
[ERROR] To see the full stack trace of the errors, re-run Maven with the -e switch.
[ERROR] Re-run Maven using the -X switch to enable full debug logging.
[ERROR] 
[ERROR] For more information about the errors and possible solutions, please read the following articles:
[ERROR] [Help 1] http://cwiki.apache.org/confluence/display/MAVEN/MojoFailureException
[ERROR] 
[ERROR] After correcting the problems, you can resume the build with the command
[ERROR]   mvn <args> -rf :guacamole-common
```

## 参考

https://zenn.dev/seiwell/articles/b52b124370ad81
