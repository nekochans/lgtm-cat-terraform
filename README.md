# terraform-boilerplate
Terraformの設計を行う際に雛形となるプロジェクトです。

このプロジェクトはAWSの管理に特化していますが、他のCloudのResourcesも管理出来るように設計してあります。

## 想定読者

- ある程度Terraformを使った事がある方
- AWSに関する基礎的なスキルを持っている方

## 事前準備

### 実行環境

tfenvとDockerの利用を紹介します。

どちらの実行環境でもいいですが、Terraformはマイナーバージョンでも破壊的な変更を行う事があるのでバージョンを気軽に切り替えられる事は必須です。

非推奨の機能が次のマイナーバージョンでいきなり削除されることも過去にはあったので、Terraformの警告を無視しない事が非常に大切になります。

#### tfenv

詳細は[tfenv](https://github.com/Zordrak/tfenv/blob/master/README.md)を確認してください。

`brew install tfenv` でインストールします。

その後以下の手順で設定を行います。

- `tfenv install 0.12.25`
- `tfenv use 0.12.25`
- `terraform --version` で Terraform v0.12.25 が表示されればOK

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

その後、`aws configure --profile nekochans-dev`

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
[nekochans-dev]
aws_access_key_id = あなたのアクセスキーID
aws_secret_access_key = あなたのシークレットアクセスキー
```

このプロジェクトではprofile名を `nekochans-dev` としています。

この名前は任意の物でも構いませんが、必ずprofile名を明示的に付けておく事が重要です。

そうしないと複数のAWS環境を管理する際に誤って他の環境に適応してしまう、等の事故が発生する可能性があるからです。

profile名を書き換えた場合、`providers/aws/environments/○○/○○/` 配下の `provider.tf`, `backend.tf` を書き換えて下さい。

### S3Bucketを作成する

`.tfstate` というファイルに実行状態を記録します。（実体はただのJSONファイルです）

このプロジェクトでは `dev-nekochans-tfstate` というS3Bucketがその保存先になります。

この設定は `providers/aws/environments/○○/backend.tf` に記載されています。

S3Bucketはグローバルの名前空間でユニークな名前になっている必要があります。（同じ名前のS3Bucketは作成出来ない）

このプロジェクトを元に設計を行う場合は、この部分を自身が作ったS3Bucketに書き換える必要があります。

## ディレクトリ構成

下記のようなディレクトリ構成になっています。

```
terraform-boilerplate/
  ├ modules/
  │  └ aws/
  └ providers/
     └ aws/
       └ environments/
         ├ dev/
         │ ├ 10-network/
         │ └ 20-xxxx/
         └ prod/
           ├ 10-network/
           └ 20-xxxx/
```

### 環境分割

本番環境とステージング・開発環境など複数環境に構築するケースを想定し、`environments/`配下に環境ごとのディレクトリを作成しています。

### 依存関係

`providers` の頭の数字に注目して下さい。

`.tfstate` はこれらのディレクトリ配下毎に存在しますが、数字の大きなディレクトリは数字が小さなディレクトリに依存しています。

その為、必ず数字が小さいディレクトリから `terraform apply` を実行する必要があります。

今後このプロジェクトをベースに機能を追加する際も依存関係を意識してディレクトリ名を決める必要があります。

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

`terraform fmt` は必ずプロジェクトルートで実行を行ってください。

そうしないと全ての `.tf` ファイルに修正が適応されません。

## 参考資料

### [公式ドキュメント](https://www.terraform.io/docs/providers/aws/index.html)

各Resourcesのパラメータ等はここで確認するのが確実です。

### [Terraform Recommended Practices](https://www.terraform.io/docs/enterprise/guides/recommended-practices/index.html)

公式が公開しているベストプラクティス。

設計方針を決める前に一通り見ておく事を推奨します。

### [Terraform Module Registry](https://registry.terraform.io/)

Terraformの開発元である、HashiCorp社が作成したmodule等を見る事が出来る。

基本的にここを参考にすると良いです。

[【モダンTerraform】ベストプラクティスはTerraform Module Registryを参照しよう](http://febc-yamamoto.hatenablog.jp/entry/2018/02/01/090046)

### その他

どの記事も実戦で良く使うテクニックが載っている良記事です。

- [Terraform職人入門: 日々の運用で学んだ知見を淡々とまとめる](https://qiita.com/minamijoyo/items/1f57c62bed781ab8f4d7)
- [Terraformを1年間運用して学んだトラブルパターン4選](https://medium.com/eureka-engineering/terraform%E3%82%921%E5%B9%B4%E9%96%93%E9%81%8B%E7%94%A8%E3%81%97%E3%81%A6%E5%AD%A6%E3%82%93%E3%81%A0%E3%83%88%E3%83%A9%E3%83%96%E3%83%AB%E3%83%91%E3%82%BF%E3%83%BC%E3%83%B34%E9%81%B8-f31b751a14e6)
- [Terraform Best Practices in 2017](https://qiita.com/shogomuranushi/items/e2f3ff3cfdcacdd17f99)
- [同僚に「早く言ってよ〜」と言われたTerraform小技](https://blog.grasys.io/post/kyouhei/tips-of-terraform_target-and-ignore_changes-and-plugin-dir/)
