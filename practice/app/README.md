# app — 워크로드 스택 (원격 backend 사용)
```bash
# backend.tf 의 bucket/dynamodb_table 을 bootstrap output으로 채운 뒤
terraform init -migrate-state   # 로컬 state가 있으면 S3로 이전
terraform apply
terraform destroy               # 실습 끝나면 반드시
```
