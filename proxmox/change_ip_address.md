# 構築済み Proxmox の IP アドレス変更手順

おうちネットワークで色々するために VLAN でネットワークを分離した。

再構築も考えたが色々面倒だったし、IPアドレスを変更して対応することにした。

## 手順

1. `/etc/network/interfaces` を編集
1. `systemctl stop pve-cluster.service` と `systemctl stop corosync.service` を実行してクラスタのサービスを停止する
1. `pmxcfs -l` でマウント
1. `/etc/pve/corosync.conf` を編集
1. `/etc/hosts` を編集
1. reboot

## /etc/network/interfaces を編集

/etc/network/interfaces (一部抜粋)

```conf
auto vmbr0
iface vmbr0 inet static
        address 192.168.101.100/24
        gateway 192.168.101.1
        bridge-ports enp2s0
        bridge-stp off
        bridge-fd 0
```

## サービス停止

```bash
systemctl stop pve-cluster.service
systemctl stop corosync.service
```

## マウント

```bash
pmxcfs -l
```

## corosync.conf 編集

/etc/pve/corosync.conf(一部抜粋)

```conf
  node {
    name: pve
    nodeid: 1
    quorum_votes: 1
    ring0_addr: 192.168.101.100
  }
```
## hosts 編集

/etc/hosts(一部抜粋)

```config
192.168.101.100 pve.local pve
```

## 参考

https://www.youtube.com/watch?v=IPUspSZ9geM