# PostgreSQL 16 を ubuntu 22.04 にインストール

## 事前処理

```shell
sudo apt update && sudo apt upgrade -y
sudo apt install gnupg2 wget vim curl
```

## リポジトリの追加

```shell
sudo sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
```

秘密鍵の追加

```shell
curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg
```

## パッケージリストのアップデート

```shell
sudo apt update
```

## インストール

```shell
sudo apt install postgresql-16 postgresql-contrib-16
```

## サービスの開始・自動化

```shell
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

## サービスの確認

```shell
root@pgsql16:/etc/postgresql/16/main# systemctl status postgresql
* postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/lib/systemd/system/postgresql.service; enabled; vendor preset: enabled)
     Active: active (exited) since Sun 2024-05-26 23:00:57 JST; 24min ago
   Main PID: 13874 (code=exited, status=0/SUCCESS)
        CPU: 1ms

May 26 23:00:57 pgsql16 systemd[1]: Starting PostgreSQL RDBMS...
May 26 23:00:57 pgsql16 systemd[1]: Finished PostgreSQL RDBMS.
```

## pg_hba.conf の編集

```shell
vim /etc/postgresql/16/main/pg_hba.conf
```

接続先 IP アドレスを追加

192.168.100.1 ～ 192.168.100.254 が全部許可するなら以下

```conf
host    all             all             192.168.100.0/24        scram-sha-256
```

## SUPERUSER ロールの追加

postgres ロールで色々するのもアレなので SUPERUSER ロールを作る

### 対話型ターミナルへログイン

```shell
sudo -u postgres psql
```

### gnsnghm に SUPERUSER と LOGIN を付与

```psql
CREATE ROLE gnsnghm WITH SUPERUSER LOGIN;
```

### パスワードを設定

`\password [ROLE名]`で Enter。小文字なのを注意する。

```psql
\password gnsnghm
Enter new password for user "gnsnghm":
Enter it again:
```

## ベンチ用の DB を作成

```shell
CREATE DATABASE bench;
```

## pgbench の初期化

```shell
su - postgres
```

```shell
pgbench -i -s 1000 -q bench
```

## いったん pgbench してみる

config 何もいじっていない状態でベンチマーク

scaling factor 1000 はやりすぎたかパラメータを真面目に考えたら改善するか確かめる

```shell
root@pgsql16:/etc/postgresql/16/main# su - postgres
postgres@pgsql16:~$ pgbench -c 2 -T 60 bench
pgbench (16.3 (Ubuntu 16.3-1.pgdg22.04+1))
starting vacuum...end.
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 1000
query mode: simple
number of clients: 2
number of threads: 1
maximum number of tries: 1
duration: 60 s
number of transactions actually processed: 948
number of failed transactions: 0 (0.000%)
latency average = 126.642 ms
initial connection time = 4.433 ms
tps = 15.792537 (without initial connection time)
```

config 修正し、以下のように設定

```shell
# DB Version: 16
# OS Type: linux
# DB Type: web
# Total Memory (RAM): 4096 MB
# CPUs num: 4
# Connections num: 100
# Data Storage: ssd

max_connections = 100
shared_buffers = 1GB
effective_cache_size = 3GB
maintenance_work_mem = 256MB
checkpoint_completion_target = 0.9
wal_buffers = 16MB
default_statistics_target = 100
random_page_cost = 1.1
effective_io_concurrency = 200
work_mem = 5242kB
huge_pages = off
min_wal_size = 1GB
max_wal_size = 4GB
max_worker_processes = 4
max_parallel_workers_per_gather = 2
max_parallel_workers = 4
max_parallel_maintenance_workers = 2
```

かわらんやないかい 😭

```shell
postgres@pgsql16:~$ pgbench -c 2 -T 60 bench
pgbench (16.3 (Ubuntu 16.3-1.pgdg22.04+1))
starting vacuum...end.
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 1000
query mode: simple
number of clients: 2
number of threads: 1
maximum number of tries: 1
duration: 60 s
number of transactions actually processed: 1016
number of failed transactions: 0 (0.000%)
latency average = 118.245 ms
initial connection time = 4.452 ms
tps = 16.914001 (without initial connection time)
```

## セクタサイズが大きすぎた可能性を加味して初期化

`--init-steps`初期化ステップを指定。

d(テーブル削除)、t(テーブル作成)、p(Primary key 作成)、G(サーバ側データ生成、ロード)、v(VACCUM)

```shell
pgbench -i --init-steps=dtpGv -s 10 bench
```

再実行。やっぱり性能低いらしい

```shell
postgres@pgsql16:~$ pgbench -c 16 bench
pgbench (16.3 (Ubuntu 16.3-1.pgdg22.04+1))
starting vacuum...end.
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 10
query mode: simple
number of clients: 16
number of threads: 1
maximum number of tries: 1
number of transactions per client: 10
number of transactions actually processed: 160/160
number of failed transactions: 0 (0.000%)
latency average = 65.522 ms
initial connection time = 32.639 ms
tps = 244.193536 (without initial connection time)
```

古い Xeon ではこんなもんだということにする

```shell
Model name:             Intel(R) Xeon(R) CPU E3-1220 v5 @ 3.00GHz
```

## 補足

Intel i7-8700K でやったら普通に出た。そらそうか。

```shell
Intel(R) Core(TM) i7-8700K CPU @ 3.70GHz
```

初期化条件は同じ

```shell
pgbench -i --init-steps=dtpGv -s 10 bench
dropping old tables...
NOTICE:  table "pgbench_accounts" does not exist, skipping
NOTICE:  table "pgbench_branches" does not exist, skipping
NOTICE:  table "pgbench_history" does not exist, skipping
NOTICE:  table "pgbench_tellers" does not exist, skipping
creating tables...
creating primary keys...
generating data (server-side)...
vacuuming...
done in 2.06 s (drop tables 0.00 s, create tables 0.00 s, primary keys 0.01 s, server-side generate 1.90 s, vacuum 0.15 s).
```

tps 3000 オーバーだった

```shell
pgbench -c 16 bench
pgbench (16.3 (Ubuntu 16.3-1.pgdg20.04+1))
starting vacuum...end.
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 10
query mode: simple
number of clients: 16
number of threads: 1
maximum number of tries: 1
number of transactions per client: 10
number of transactions actually processed: 160/160
number of failed transactions: 0 (0.000%)
latency average = 4.502 ms
initial connection time = 32.681 ms
tps = 3554.291807 (without initial connection time)
```
