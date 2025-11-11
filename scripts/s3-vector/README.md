# S3 Vector 管理スクリプト

AWS S3 Vectors（プレビュー）の Vector Bucket と Vector Index を管理するためのシンプルスクリプトです。

## 前提条件

- AWS CLI v2 がインストールされていること
- AWS Profile `lgtm-cat` が設定されていること

## ディレクトリ構成

```
scripts/s3-vector/
├── README.md                     # このファイル
├── create-vector-resources.sh    # 簡易作成スクリプト
```

## 使い方

### 環境指定で実行

```bash
cd scripts/s3-vector

# ステージング環境
./create-vector-resources.sh stg

# 本番環境
./create-vector-resources.sh prod
```

### 実行結果

- 環境に応じて Vector Bucket を作成
  - stg → `stg-lgtm-cat-vectors`
  - prod → `prod-lgtm-cat-vectors`
- 環境ごとに Vector Index を作成
  - stg → `stg-multimodal-search-index`
  - prod → `prod-multimodal-search-index`

## 設定内容

| 環境 | Vector Bucket 名         | Index 名                        |
|------|-------------------------|--------------------------------|
| stg  | stg-lgtm-cat-vectors    | stg-multimodal-search-index    |
| prod | prod-lgtm-cat-vectors   | prod-multimodal-search-index   |

- データ型: `float32`
- 次元数: `1536`
- 距離測定方法: `cosine`

## 環境変数

```bash
# AWS Profile（デフォルト: lgtm-cat）
export AWS_PROFILE=your-profile

# 実行例
AWS_PROFILE=custom-profile ./create-vector-resources.sh prod
```

**注意**: リージョンは `us-east-1` 固定です。

## 注意事項

- S3 Vectors は現在プレビュー段階です
