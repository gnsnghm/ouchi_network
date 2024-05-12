### 構築済み Raspberry pi の IP アドレスを変更する

1年くらい前に何故かDHCP で使っていた Raspberry pi の IP アドレスを変更する。

## 手順
1. `/etc/dhcpcd.conf` を編集
1. 再起動

## /etc/dhcpcd.conf を編集

/etc/dhcpcd.conf(一部抜粋)
```conf
interface eth0
static ip_address=192.168.101.200/24
#static ip6_address=fd51:42f8:caae:d92e::ff/64
static routers=192.168.101.1
static domain_name_servers=1.1.1.1 1.0.0.1
```

## 再起動

`reboot`
