# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 他のファイルへの参照

**以下のように @<path> の形式で書かれている場合は別のファイルへの参照になりますので、対象ファイルを探して内容を確認してください。**

**以下に記載例を示します。**

@modules/aws/acm/main.tf（modules/aws/acm/main.tf を参照）
@.github/PULL_REQUEST_TEMPLATE.md （.github/PULL_REQUEST_TEMPLATE.md を参照）

## プロジェクト概要

LGTMeow (https://lgtmeow.com) のインフラ管理用Terraformリポジトリです。AWSリソースをモジュラー方式で管理し、環境ごとに分離されたstateファイルを使用しています。

## よく使うコマンド

### 初期化

プロジェクトルートから全Terraformディレクトリを初期化:
```bash
./terraform-init.sh
```

Dockerを使用する場合:
```bash
docker-compose exec terraform ./terraform-init.sh
```

### コードフォーマット

必ずプロジェクトルートから実行して全`.tf`ファイルをフォーマット:
```bash
terraform fmt -recursive
```

### Plan と Apply

特定の環境ディレクトリに移動してから実行:
```bash
cd providers/aws/environments/prod/10-network
terraform plan
terraform apply
```

### State のリフレッシュ

コード変更していないのに`terraform plan`で差分が出る場合:
```bash
terraform apply -refresh-only
```

## アーキテクチャ

### ディレクトリ構成

```
lgtm-cat-terraform/
  ├ modules/aws/          # 再利用可能なTerraformモジュール
  └ providers/aws/
    └ environments/
      ├ prod/             # 本番環境
      └ stg/              # ステージング環境
```

### モジュールシステム

- **modules/aws/**: 再利用可能なモジュール（vpc, ecs, cognito, iamなど）。環境やリージョン固有の値はハードコードしない
- **providers/aws/environments/**: 環境固有の実装。適切なパラメータでモジュールを呼び出す
- 各番号付きディレクトリ（10-network, 11-acmなど）は独自の`.tfstate`ファイルを持つ

### 番号付きディレクトリと依存関係

ディレクトリの番号は依存順序を示します。**重要**: 大きい番号は小さい番号に依存するため、必ず数字順に適用する必要があります:

1. **10-network**: VPC、サブネット、VPCエンドポイント（S3, ECR, SSM, CloudWatch Logs）
2. **11-acm**: ACM証明書
3. **12-images**: 画像保存用S3バケット
4. **13-vercel**: Vercel連携
5. **14-txt**: Route53 TXTレコード（`terraform.tfvars`が必要）
6. **15-iam**: IAMロールとポリシー
7. **16-ses**: SES設定（`terraform.tfvars`が必要）
8. **17-cognito**: Cognitoユーザープール
9. **20-api**: API Gateway + ECS（lgtm-cat-image-recognitionのデプロイが前提）
10. **21-lambda-securitygroup**: Lambdaセキュリティグループ
11. **22-lgtm-image-processor**: Lambda画像処理

### State管理

- バックエンド: S3バケット `lgtm-cat-tfstate`（prod）と`stg-lgtm-cat-tfstate`（stg）
- 各番号付きディレクトリは`backend.tf`で定義された独自のstateファイルを持つ
- ディレクトリ間の依存関係は`terraform_remote_state`データソースで管理
- AWSプロファイル: `lgtm-cat`

### 環境間の依存関係

prodとstg環境は同じAWSアカウントを共有します。一部のリソースはprodのみに存在します（ACM証明書などの共有リソース）。ステージングリソースは`terraform_remote_state`経由で本番リソースに依存する場合があります:

- stgがprodを参照: network（VPC）、acm（証明書）

### 特別な依存関係

**20-api**: 適用前にSecrets Managerのシークレットが存在している必要があります:
- `/stg/lgtm-cat/image-recognition`（ステージング）
- `/prod/lgtm-cat/image-recognition`（本番）

コンテンツ形式:
```json
{
  "api_id": "xxxxxxxxxx"
}
```

`api_id`は https://github.com/nekochans/lgtm-cat-image-recognition を先にデプロイして取得します。

## 必要な設定ファイル

適用前に以下のファイルを作成:

### providers/aws/environments/prod/14-txt/terraform.tfvars
```terraform
txt_records = ["google-site-verification=XXXXXXXXXXX"]
```

### providers/aws/environments/prod/16-ses/terraform.tfvars
```terraform
from_email = "your-verified@email.com"  # SESで検証済みのメールアドレス
```

## コーディング規約

| 項目 | 規約 |
|------|-----------|
| ファイル/ディレクトリ名 | ケバブケース |
| リソース/データソース名 | スネークケース |
| リソースID | ケバブケース |
| 変数名 | スネークケース |
| タグ名 | ケバブケース |

**重要**: 一部のAWSリソース（RDS Clusterなど）は識別子にアンダースコアを禁止しているため、リソースIDにはケバブケースを使用します。

### ファイル構成パターン

各番号付きディレクトリに含まれるファイル:
- `main.tf` - モジュール呼び出しと主要リソース
- `variables.tf`またはlocals - 環境固有の値
- `backend.tf` - S3バックエンドとリモートstateデータソース
- `provider.tf` - AWSプロバイダー設定
- `versions.tf` - Terraformとプロバイダーのバージョン制約
- `outputs.tf` - 他モジュール向けのエクスポート値
- `terraform.tfvars` - 機密/環境固有の値（gitには含めない）

## 設計原則

- モジュールは可能な限りプロバイダー非依存（現在はAWSのみ）
- モジュール内にリージョンや環境の値をハードコードしない
- マルチリージョン運用に対応した設計
- Provider Plugin Cacheが有効（terraform configを参照）
- 未使用のキャッシュされたプラグインは手動で削除する必要がある

## ワークフローガイドライン

1. 必ず番号順のディレクトリ順で適用する
2. 新しい番号付きディレクトリ（例: 23-xxx）を追加する場合は、stg環境で先にテストしてからprod環境に適用する
3. コミット前に必ずプロジェクトルートで`terraform fmt -recursive`を実行
4. Terraformの警告を無視しない - 非推奨機能が次のマイナーバージョンで削除される可能性がある
5. コード変更なしでplanに差分が出る場合は`terraform apply -refresh-only`を使用
6. ディレクトリ間の依存関係は`terraform_remote_state`で明示的に定義されている

## GitとGitHubワークフロールール

### GitHubの利用ルール

GitHubのMCPサーバーを利用してGitHubへのPRを作成する事が可能です。

許可されている操作は以下の通りです。

- GitHubへのPRの作成
- GitHubへのPRへのコメントの追加
- GitHub Issueへのコメントの追加

### PR作成ルール

- ブランチはユーザーが作成しますので現在のブランチをそのまま利用します
- PRのタイトルは日本語で入力します
- PRの作成先は特別な指示がない場合は `main` ブランチになります
- PRの説明欄は @.github/PULL_REQUEST_TEMPLATE.md を参考に入力します
- 対応issueがある場合は、PRの説明欄に `#<issue番号>` を記載します
- Issue番号は現在のブランチ名から取得出来ます、例えば `feature/issue7/add-docs` の場合は `7` がIssue番号になります
- PRの説明欄には主に以下の情報を含めてください

#### PRの説明欄に含めるべき情報

- 変更内容の詳細説明よりも、なぜその変更が必要なのかを重視
- 他に影響を受ける機能があれば明記

#### 以下の情報はPRの説明欄に記載する事を禁止する

- 1つのissueで1つのPRとは限らないので `fix #issue番号` や `close #issue番号` のようなコメントは禁止します
- 全てのテストをパス、Linter、型チェックを通過などのコメント（テストやCIが通過しているのは当たり前でわざわざ書くべき事ではない）

## コーディング時に利用可能なツール

コーディングを効率的に行う為のツールです。必ず以下に目を通してください。
