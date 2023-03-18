# terraform-backend-s3

🦥🦥🦥 Terraformのバックエンドサービスを使用して、Terraformの状態をS3に保存して管理するためのサンプルプロジェクトです。  
GitHub Actionsを用いて、自動でクライドリソースのプロビジョニングを行います。  

## 準備

以下の内容をGitHub Secretsに設定してください。  

| Name | Description |
| --- | --- |
| AWS_ACCESS_KEY_ID | AWSアクセスキー |
| AWS_SECRET_ACCESS_KEY | AWSシークレットアクセスキー |
| AWS_REGION | AWSリージョン |
| BACKEND_BUCKET_NAME | Terraformのバックエンドとして使用するS3バケット名 |
| BACKEND_KEY_NAME | Terraformのバックエンドとして使用するS3オブジェクト名 |
| TFVARS | Terraformの変数ファイルの内容 |

mainブランチにプッシュすると、GitHub Actionsが自動で実行されます。  
これによって、Terraformの状態がS3に保存され、Terraformのプロビジョニングが実行されます。  
