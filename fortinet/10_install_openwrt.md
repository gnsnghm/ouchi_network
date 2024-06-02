# Fortinet FortiGate 50E に OpenWrt をインストールする

## OpenWrt とは

- ルーターやネットワークデバイス向けのオープンソースファームウェア
- Linux ベースであるためカスタマイズ性や拡張が容易に行える

### その他主な特徴

1. オープンソース
1. 高いカスタマイズ性
   - パッケージ管理システム(opkg)を備えており、必要な機能をパッケージとして追加・削除できる
1. 広範囲なデバイスサポート
1. 高度なネットワーク機能
   - VPN や QoS、ファイアウォール、ルーティング、IPv6 など
1. セキュリティ向上

## インストール手順

今回は Fortinet FortiGate 50E のファームウェアを書き換えて OpenWrt をインストールする

インストール手順は以下を参考に実行

https://taiha.hatenablog.jp/entry/2023/03/10/004523

## 準備するもの

- コンソールケーブル
- PC(今回は MacBookPro)

## 1. TFTP の有効化

今回は MacBookPro から OpenWrt の binary ファイルを TFTP で送る必要がある。

また、FortiGate 50E のファームウェアを書き戻しできるように保存しておきたいのでリモート接続を許可してあげる必要もある

Mac は デフォルトで TFTP サーバがインストールされているため、ターミナルから有効にするだけで OK

```shell
sudo launchctl load -w /System/Library/LaunchDaemons/tftp.plist
```

### 起動確認

`lsof` で tftp のデフォルトポート 69 が誰に使われているかかを確認すれば良い

```shell
sudo lsof -i:69
```

### 接続確認

自身の端末から `tftp` することで接続できるか確認する

quit で抜けられる

```shell
tftp localhost
```

```shell
tftp>
```

### 備考

サーバ停止の場合は以下のコマンド

```shell
sudo launchctl unload -w /System/Library/LaunchDaemons/tftp.plist
```

## 2. SSH の有効化(メーカファームウェアが不要の場合設定不要)

ライセンスが切れているとは言え、メーカファームウェアに書き戻しができるようにバイナリファイルを取得し、ローカルに保管しておくとき

Mac 側のリモートアクセス(SSH)を有効にしておく必要がある

1. システム設定>一般>共有
1. リモートログインのチェックを入れる

その他詳しい設定は公式のページの説明が詳しいので省略

https://support.apple.com/ja-jp/guide/mac-help/mchlp1066/mac

## 3. OpenWrt のバイナリファイルのダウンロード

MacBook で OpenWrt のバイナリを DL する

https://openwrt.org/toh/hwdata/fortinet/fortinet_fortigate_50e

`openwrt-mvebu-cortexa9-fortinet_fg-50e-initramfs-kernel.bin` をダウンロード

その後、 TFTP のルートディレクトリである `/private/tftpboot` に保管し、ファイル名を `image.out` と変更する

## 4. FortiGate 50E の TFTP パラメータの設定

FortiGate 50E がどのポートのどのアドレスで TFTP を受け入れているか確認する

### FortiGate 50E と MacBookPro をコンソール接続する

今回は USB-RJ45 で接続できるケーブルを買って接続

https://amzn.asia/d/0RQ28zI

### ターミナルから コンソールへの接続方法

インターフェースの確認

```shell
ls -alF /dev/tty.*
```

```shell
crw-rw-rw-  1 root  wheel   21,   0  6  1 19:32 /dev/tty.Bluetooth-Incoming-Port
crw-rw-rw-  1 root  wheel   21,   2  6  2 17:52 /dev/tty.usbserial-XXXXXX
```

`/dev/tty.usbserial-XXXXXX` がコンソールケーブルのインターフェースとなるので `screen` コマンドを使って接続する

Enter を押すとログインを求められる

```shell
screen /dev/tty.usbserial-XXXXXX
```

**`screen`で接続した状態で次の手順に進む**

## 5. FortiGate 50E を再起動して boot menu に入る

一度電源を抜いて、もう一度指し直して FortiGate 50E を再起動する

そうすると `Please wait for OS to boot, or press any key to display configuration menu` と出てくるので Enter で boot menu に入る

## 6. FortiGate 50E の TFTP の設定を確認する

Forigate がどのような設定で TFTP に接続しようとしているか確認する

### boot menu

```shell

```

`R` を押下

```shell

```

なので、 `WAN1` に LAN ケーブルを刺して MacBookPro に接続する

ネットワーク手動設定で以下のように設定する

- IP アドレス：192.168.1.168
- サブネット：255.255.255.0
- ゲートウェイ：192.168.1.254

**allow を忘れない**

## 7. イメージのダウンロード

`[T]: Initiate TFTP firmware transfer.` を選択すると、先ほどダウンロードした `image.out`がダウンロードされる

ダウンロード完了後、 `Save as Default firmware/Backup firmware/Run image without saving:[D/B/R]?`と聞かれるので `R` を押下して Flash に書き込まず実行する

## 8. メーカファームウェアをバックアップ

書き戻すことはたぶん無いけど勉強のためバックアップを取る

`dd` を用い、/proc/mtd を確認の上 "firmware-info", "kernel", "rootfs" を最低限取り出し、`scp` で MacbookPro に転送し保管する

確認

```shell
mkdir /tmp/mtd
cd /tmp/mtd
cat /proc/mtd
```

書き出し

```shell
dd if=/dev/mtdblock1 of=mtd1_firmware-info.bin
dd if=/dev/mtdblock5 of=mtd5_kernel.bin
dd if=/dev/mtdblock6 of=mtd6_rootfs.bin
```

バックアップの書き戻しは `mtd` コマンドでやるらしい

例

```shell
mtd write <backup image> <target partition>
```

### バイナリファイルを送信

WAN1 に LAN を刺したと思うが、LAN1 に指し直し、 DHCP で IP アドレスを取得する

その IP アドレスに向けてファイルを送信する

```shell
scp *.bin [ユーザ名]:[IPアドレス]:/Users/[ユーザ名]
```

## 9. OpenWrt 上で sysupgrade を実行

MacBook から sysupgrade 用のバイナリファイルを送信する

https://openwrt.org/toh/hwdata/fortinet/fortinet_fortigate_50e#conventions_per_characteristic

`openwrt-23.05.3-mvebu-cortexa9-fortinet_fg-50e-squashfs-sysupgrade.bin` をダウンロードし、 FortiGate 50E へ送信する

```shell
scp
openwrt-23.05.3-mvebu-cortexa9-fortinet_fg-50e-squashfs-sysupgrade.bin root@[ForiGate 50E のIPアドレス]:/root
```

Fortigate 50E で `sysupgrade`

```shell
sysupgrade -v openwrt-23.05.3-mvebu-cortexa9-fortinet_fg-50e-squashfs-sysupgrade.bin
```

勝手に再起動されるのを待つ

## 10. 再起動後の対応

もし再起動後、メーカファームウェアが起動する場合は、再起動の上 boot menu
に入り `[B]: Boot with backup firmware and set as default.` で書き換える

## 参考にしたリンク

[大破ログ Fortinet FortiGate 50E](https://taiha.hatenablog.jp/entry/2023/03/10/004523)

[FortiGate 50E に OpenWRT を入れ tinc をセットアップする](https://scrapbox.io/Geek-SpaceBox/FortiGate_50E%E3%81%ABOpenWRT%E3%82%92%E5%85%A5%E3%82%8Ctinc%E3%82%92%E3%82%BB%E3%83%83%E3%83%88%E3%82%A2%E3%83%83%E3%83%97%E3%81%99%E3%82%8B)

[闇ネット OS on Fortigate 50E（暫定）](https://scrapbox.io/Geek-SpaceBox/%E9%97%87%E3%83%8D%E3%83%83%E3%83%88OS_on_Fortigate_50E%EF%BC%88%E6%9A%AB%E5%AE%9A%EF%BC%89)

[TFTP サーバーの起動方法(Mac 編)](https://infrastructure-engineer.com/tftp-server-mac-001/)

[Mac でルータにコンソール接続する](https://qiita.com/yukihigasi/items/8a7deed5e3760b670969)

[Mac OS で tftp サーバー起動](https://sunabako.wordpress.com/2010/03/17/mac-os%E3%81%A7tftp%E3%82%B5%E3%83%BC%E3%83%90%E3%83%BC%E8%B5%B7%E5%8B%95/)
