# Grafana を Raspberry pi にインストールして zabbix サーバと連携する

この手順は Chat-GPT4o 書きました

## 前提条件

- Raspberry Pi がインターネットに接続されていること
- Raspberry Pi OS が最新の状態であること

## 手順

### 1. パッケージの更新

システムのパッケージリストを更新し、アップグレードします。

```bash
sudo apt update
sudo apt upgrade
```

### 2. Grafana のリポジトリを追加

Grafana の公式リポジトリを Raspberry Pi に追加します。

```bash
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
```

### 3. Grafana の GPG キーを追加

Grafana のリポジトリからパッケージをインストールできるように、GPG キーを追加します。

```bash
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
```

### 4. パッケージリストを再度更新

リポジトリの変更を反映させるために、パッケージリストを再度更新します。

```bash
sudo apt update
```

### 5. Grafana のインストール

Grafana をインストールします。

```bash
sudo apt install grafana
```

### 6. Grafana のサービスを起動

インストールが完了したら、Grafana サービスを起動し、自動起動を有効にします。

```bash
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
```

### 7. Grafana の Web インターフェースにアクセス

インストールと起動が完了したら、Web ブラウザから Grafana の Web インターフェースにアクセスします。Raspberry Pi の IP アドレスとポート 3000 を使用します。

`http://<Raspberry PiのIPアドレス>:3000`

デフォルトのログイン情報は以下の通りです。

- ユーザー名: admin
- パスワード: admin

初回ログイン時にパスワードの変更を求められます。

## Grafana と zabbix 連携

1. **Zabbix サーバー**が動作していること
1. **Grafana サーバー**が動作していること
1. **Zabbix API ユーザー**が作成されていること

## 手順

### 1. Grafana に Zabbix プラグインをインストール

Grafana に Zabbix プラグインをインストールします。

```bash
sudo grafana-cli plugins install alexanderzobnin-zabbix-app
```

インストールが完了したら、Grafana を再起動します。

```bash
sudo systemctl restart grafana-server
```

### 2. Grafana で Zabbix プラグインを有効化

1. Grafana の Web インターフェースにログインします。
1. 左側のメニューから「Configuration」 > 「Plugins」を選択します。
1. "Zabbix" プラグインを検索し、クリックして有効化します。

### 3. Zabbix データソースを追加

1. 左側のメニューから「Configuration」 > 「Data Sources」を選択します。
1. 「Add data source」ボタンをクリックします。
1. 「Zabbix」を選択します。
1. 以下の情報を入力します：

   - Name: データソースの名前（例：Zabbix）
   - URL: Zabbix API のエンドポイント（例：http://your-zabbix-server-url/zabbix/api_jsonrpc.php）
   - Access: 「Server (default)」を選択
   - Auth: -「With credentials」をチェック
     - Zabbix API ユーザー名とパスワードを入力

1. 「Save & Test」ボタンをクリックして、接続が成功することを確認します。

### 4. ダッシュボードを作成

1. 左側のメニューから「Create」 > 「Dashboard」を選択します。
1. 「Add new panel」をクリックします。
1. パネルの設定でデータソースとして「Zabbix」を選択します。
1. 必要に応じてメトリクスを設定し、表示したいデータを選択します。
1. 設定が完了したら、パネルを保存し、ダッシュボードを保存します。

### トラブルシューティング

- 接続エラーが発生した場合:
  - Zabbix API のエンドポイントが正しいことを確認してください。
  - Zabbix サーバーのファイアウォール設定を確認し、Grafana サーバーからのアクセスが許可されていることを確認してください。
  - Zabbix API ユーザーの権限を確認してください。

これで、Grafana で Zabbix に蓄積されたデータを可視化することができます。
