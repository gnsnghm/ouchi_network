# Cloudflare tunnel と Microsoft Entra ID(旧 Azure AD) を利用してお家ネットワークにセキュアにアクセスする

proxmox は Cloudflare tunnel を活用して特定のメールアドレスを入力すると、そのメールアドレス宛てにワンタイムパスワードが届くような仕組みを取っていた。

しかしながらメールが来るタイミングが10分かかったりメールが届かなかったりしてあまりに気に入っていなかった。

困っていたら会社で「Azure AD でやってみたで～」って人にやり方教えてもらった。

色々と忘れていたりしたので入れたかった Apache Guacamole もいれつつ手順をまとめる。

## おおまかな手順

1. Cloudflare で Tunnel 登録
1. 
1. 
1. 
1. 
1. 
1. 
1. 
1. 
1. 
1. 
1. 

## Tunnel 登録



## RTX1210 で IPとポートを指定して許可

```config
ip filter 808080 pass * 192.168.101.111 tcp * 8080
```