# トラブルシューティング

## noVNC が開けない問題

クラスタ削除が原因らしい

メインクラスタで以下を実行してクラスタ再起動すれば直る

```shell
/usr/bin/ssh -e none -o 'HostKeyAlias=sea-bird4' root@[noVNCが開かないクラスタのIPアドレス] /bin/true
```

https://qiita.com/murachi1208/items/bb029274336ed2c0990b

## zabbix welcome page が出てきてしまう問題

`apt update && apt upgrade -y` したせいで色々初期化されてた

### /etc/nginx/sites-available/default を削除

```shell
sudo rm -v /etc/nginx/sites-available/default
```

### /etc/zabbix/nginx.conf を編集

以下を追加

```shell
listen 80;
```

再起動

```shell
systemctl restart zabbix-server zabbix-agent httpd php-fpm
```
