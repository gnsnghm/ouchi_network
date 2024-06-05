# Cisco Catalyst 2960C の初期設定

Cisco WS-C2960C-8PC-L をヤフオクで落札したので設定していく

現状メイン L2 スイッチは SWX2200-8G を使っているが、

AP や Raspberry Pi を PoE で動作させていきたいので、こちらのスイッチをメインに変更予定

近々でハンズオン用で使う予定なので今回はさらっと触るだけ

## 環境

PC：MacBookPro

Console 接続：RJ45-USB

## 初期設定手順

0. AC ケーブルを抜いておく
1. コンソールケーブルを接続
1. terminal などから console 接続する
1. mode ボタンを押しながら AC ケーブルを挿す
1. しばらく待つ

## セットアップモードのスキップ

初回起動時に `Would you like to enter the initial configuration dialog? [yes/no]: `と聞かれるので `no` と入力

## 特権モードに入る

`enable` で特権モードに入る

```console
Switch> enable
Switch#
```

## グローバルコンフィグレーションモードに入る

`configure treminal` でグローバルコンフィグレーションモードに入る

`Switch(config)#`に変化する

```console
Switch# configure terminal
Switch(config)#
```

## ホスト名を指定

スイッチのホスト名を設定する

```console
Switch(config)# hostname MySwitch
MySwitch(config)#
```

## 管理用 IP アドレスの設定

VLAN を設定する

```console
MySwitch(config)# interface vlan 1
MySwitch(config-if)# ip address 192.168.1.2 255.255.255.0
MySwitch(config-if)# no shutdown
MySwitch(config-if)# exit
```

## デフォルトゲートウェイを設定する

```console
MySwitch(config)# ip default-gateway 192.168.1.1
```

## コンソールパスワードの設定

```console
MySwitch(config)# line console 0
MySwitch(config-line)# password cisco
MySwitch(config-line)# login
MySwitch(config-line)# exit
```

## 設定を保存

```console
MySwitch# copy running-config startup-config
Destination filename [startup-config]? [Enter]
```
