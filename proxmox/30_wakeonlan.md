# proxmox wake on lan 対応

この通りやったらできた

https://qiita.com/murachi1208/items/53d6e728d5834e50c316

## express 5800 の bios の確認

[Advanced]→[PCI Subsystem]→[Wake On LAN/PME]

https://www.support.nec.co.jp/DownLoad.aspx?file=CBZ-050461-001-10_r11.pdf&id=3170102716

## 課題

メインで使ってる PC のサブネットが違うのでうまくいかないときがあるため要調査  
(何故か成功するときもある)

同じサブネットの raspberry pi から `wakeonlan`したら起動できた
