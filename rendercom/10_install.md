# Render.com に vue.js で開発したシステムを deploy するメモ

恥ずかしい話だが、Heroku が無料じゃなくなったのを知らなかった。

その代替案を探したところ [Render.com](rennder.com) というサービスで同じことができるらしいとのことで、開発したシステムを deploy してみることにした

## deploy するシステムについて

インシデント登録システム

ユーザはインシデントが発生したとき、本システムへログイン

![](10_img/10.png)

ログイン後、ユーザはインシデントを登録する

![](10_img/20.png)

登録後、インシデントを検索して経過を登録することもできる

![](10_img/30.png)

リポジトリは以下

frontend： https://github.com/gnsnghm/inc

backend： https://github.com/gnsnghm/inc_be

## render.com への手順

frontend、 backend 共に同じ手順で OK

1. アカウントの登録
1. `+ New` > `Web Service` > `Git Provider`
1. Build Command を設定
1. Start Command を設定
1. Environment を設定

## PostgreSQL の
