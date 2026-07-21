# TODO(L1): state 저장용 S3 버킷 (aws_s3_bucket) "${var.project_name}-tfstate"
#   + versioning Enabled + 서버측 암호화(SSE-S3) + public access block

# TODO(L1): state 잠금용 DynamoDB 테이블 (aws_dynamodb_table)
#   - name = "${var.project_name}-tflock"
#   - billing_mode = "PAY_PER_REQUEST"   ★ 반드시! (과금 방지)
#   - hash_key = "LockID" (type S)
