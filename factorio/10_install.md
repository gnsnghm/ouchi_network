# factorio server のインストール

## 準備

```shell
apt update && apt upgrade -y
apt install vim
```

```shell
adduser factorio
```

## factorio headless server の開始

factorio ユーザで作業

```shell
su - factorio
```

```shell
# ダウンロード 解凍
cd ~/
wget https://www.factorio.com/get-download/1.1.107/headless/linux6
tar xvf linux64
cd ~/factorio

# ゲーム初期化
./bin/x64/factorio --create testServer

# ゲームを起動
./bin/x64/factorio --start-server testServer
```

ctrl + c で終了

## ゲームの設定

~/factorio/config/config.ini が生成されているのでポート番号などを設定できる

```shell
# 設定例

autosave_interval=2 // 自動セーブの頻度
port=34197          // ポート番号
```

## バックグラウンド実行

いったんデーモン化は面倒なのでしない

```shell
# 起動

```

終了の場合で殺す

```shell
ps aux | grep "factorio" | grep "start-server" | grep -v "grep" | awk '{print $2}' | xargs -I{} kill {}
```

## アップデート

[factorio-updater](https://github.com/narc0tiq/factorio-updater) を活用

python がいるらしい

いっかい root に戻ってインストールする

```shell
# python をインストール
apt install python3-pip
pip install --upgrade pip
```

もう一度 factorio ユーザに切り替えて実行

```shell
cd ~/factorio
wget https://raw.githubusercontent.com/narc0tiq/factorio-updater/master/update_factorio.py

# 必要なライブラリをインストール
pip install requests

# アップデートを確認
factorio@factorio:~/factorio$ python3 update_factorio.py -p core-linux_headless64 -f 1.1.107 -x
No updates available for version 1.1.107 (latest experimental is 1.1.107).
```

## テスト接続

1. factorio 起動
1. マルチプレイ
1. アドレスに接続
1. [IP アドレス]:[ポート番号]

特にパスワードも指定していないので接続できた
