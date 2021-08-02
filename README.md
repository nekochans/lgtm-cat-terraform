# lgtm-cat-terraform
lgtm-cat（サービス名 LGTMeow https://lgtmeow.com のインフラ管理用プロジェクトです。

## 事前準備

### 実行環境

tfenvとDockerの利用を紹介します。

どちらの実行環境でもいいですが、Terraformはマイナーバージョンでも破壊的な変更を行う事があるのでバージョンを気軽に切り替えられる事は必須です。

非推奨の機能が次のマイナーバージョンでいきなり削除されることも過去にはあったので、Terraformの警告を無視しない事が非常に大切になります。

#### tfenv

詳細は[tfenv](https://github.com/Zordrak/tfenv/blob/master/README.md)を確認してください。

`brew install tfenv` でインストールします。

その後以下の手順で設定を行います。

- `tfenv install 1.0.3`
- `tfenv use 1.0.3`
- `terraform --version` で Terraform v1.0.3 が表示されればOK

#### Docker

Docker上でTerraformを実行します。

*初回起動*

`docker-compose up --build -d`

*起動*

二回目以降は下記のコマンドを実行します。

`docker-compose up -d`

### AWSのIAMユーザーを作成

`AdministratorAccess` を付与したユーザーを作成して下さい。

アクセスキーでアクセス出来るように設定しておく必要があります。

Terraformはこのアクセスキーを使ってAWSの各種Resourcesを作成・管理します。

### aws_access_key_id, aws_secret_access_keyの設定

Macの場合 `brew install awscli` を実行してaws cliのインストールを行います。

その後、`aws configure --profile lgtm-cat`

対話形式のインターフェースに従い入力します。

```
AWS Access Key ID [None]: `アクセスキーIDを入力`
AWS Secret Access Key [None]: `シークレットアクセスキーを入力`
Default region name [None]: ap-northeast-1
Default output format [None]: json
```

ちなみに aws cli なしでもAWSクレデンシャルを設定する事は可能です。

`~/.aws/credentials` という名前のファイルを作成して以下の内容を設定します。

```
[lgtm-cat]
aws_access_key_id = あなたのアクセスキーID
aws_secret_access_key = あなたのシークレットアクセスキー
```

このプロジェクトではprofile名を `lgtm-cat` としています。

この名前は任意の物でも構いませんが、必ずprofile名を明示的に付けておく事が重要です。

### S3Bucketを作成する

`.tfstate` というファイルに実行状態を記録します。（実体はただのJSONファイルです）

このプロジェクトでは `lgtm-cat-tfstate` というS3Bucketがその保存先になります。

この設定は `providers/aws/environments/○○/backend.tf` に記載されています。

### 環境変数用ファイルの配置

以下のファイルを配置して下さい。

#### providers/aws/environments/prod/13-txt/terraform.tfvars

```terraform
txt_records = ["google-site-verification=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"]
```

#### providers/aws/environments/prod/15-ses/terraform.tfvars

```terraform
from_email = "us-east-1のSES EmailAddressesに定義されているメールアドレスを指定"
```

### 初期化

Docker起動後にホストOS上で以下のコマンドを実行すると `terraform init` が実行されます。

```bash
chmod 755 terraform-init.sh
docker-compose exec terraform ./terraform-init.sh
```

## ディレクトリ構成

下記のようなディレクトリ構成になっています。

```
lgtm-cat-terraform/
  ├ modules/
  │  └ aws/
  └ providers/
     └ aws/
       └ environments/
         ├ stg/
         │ ├ 11-images/
         │ └ 20-xxxx/
         └ prod/
           ├ 11-images/
           └ 20-xxxx/
```

### 環境分割

本番環境とステージング・開発環境など複数環境に構築するケースを想定し、`environments/`配下に環境ごとのディレクトリを作成しています。

### 依存関係

`providers` の頭の数字に注目して下さい。

`.tfstate` はこれらのディレクトリ配下毎に存在しますが、数字の大きなディレクトリは数字が小さなディレクトリに依存しています。

その為、必ず数字が小さいディレクトリから `terraform apply` を実行する必要があります。

今後このプロジェクトをベースに機能を追加する際も依存関係を意識してディレクトリ名を決める必要があります。

[LGTMeow](https://lgtmeow.com) では本番環境とステージング環境など、その他の環境も同じAWSアカウント上にリソースが存在します。

その為、AWSアカウントに1つだけ存在すれば良いリソースに関しては `providers/aws/environments/prod` にのみ定義されている場合があります。

ステージング用のリソースが本番用のリソースに依存しているケースもあるので、先に本番用の `providers/aws/environments/prod` 配下の `terraform apply` を全て終わらせておく必要があります。

## 設計方針

- 今はAWSのみだが、他のproviderが増えても大丈夫なように `providers/` を作ってあります
- 各moduleには特定のリージョンに依存した値はハードコードしない（AZの名前とか）
- 各moduleには特定の環境に依存した値はハードコードしない
- マルチリージョンでの運用にも耐えられるディレクトリ設計

## コーディング規約

以下の命名規則に従って命名します。

| 項目名         | 命名規則       |
|----------------|----------------|
| ファイル名     | ケバブケース   |
| ディレクトリ名 | ケバブケース   |
| リソースID     | スネークケース |
| リソース名     | ケバブケース   |
| 変数名         | スネークケース |

リソースIDというのは `resource` や `data` 等のTerraformの予約語に付けられる名前です。

```hcl
resource "aws_security_group_rule" "ssh_from_all_to_bastion" {
}
```

リソース名はそのリソースの中で一意になっている必要がある値です。

下記の例だと `key_name` がそれに該当します。

```hcl
resource "aws_key_pair" "ssh_key_pair" {
  public_key = "${file(var.ssh_public_key_path)}"
  key_name   = "${terraform.workspace}-ssh-key"
}
```

他にもタグ名を良く付ける事がありますが、それもこちらのルールの通りケバブケースで命名します。

このようなややこしい規則になっている理由ですが、RDSCluster等、一部のリソース名で `_` が禁止文字に設定されている為です。

他にもインデント等細かいルールがありますが、こちらに関しては `terraform fmt -recursive` を実行すれば自動整形されるのでこれを利用すれば良いでしょう。

`terraform fmt -recursive` は必ずプロジェクトルートで実行を行ってください。

そうしないと全ての `.tf` ファイルに修正が適応されません。

## ECS Exec

踏み台用の ECS Cluster を構築しています。

### 実行環境

- AWS CLI v2 バージョン 2.1.31以降
- Session Manager プラグイン 

インストール方法は下記を参考にしてください。

[AWS CLI バージョン 2 のインストール、更新、アンインストール - AWS Command Line Interface](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/install-cliv2.html)
[(Optional) Install the Session Manager plugin for the AWS CLI - AWS Systems Manager](https://docs.aws.amazon.com/ja_jp/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html)

### 実行コマンド
下記を実行することでコンテナに入ることができます。

起動中のタスクIDを設定してください。

```bash
aws ecs execute-command  \
    --profile lgtm-cat \
    --region ap-northeast-1 \
    --cluster lgtm-cat-bastion-cluster \
    --task <タスクID> \
    --container bastion \
    --command "/bin/sh" \
    --interactive
```
