# ---------------------------------------------------------------------------
# main.tf: state 저장소를 만드는 스택  (채우면 리소스 5개)
#
# 이 스택의 state는 로컬(bootstrap/terraform.tfstate)에 남습니다.
# 자기가 만든 버킷에 자기 state를 넣으려면 버킷이 이미 있어야 하는데,
# 그 버킷을 지금 만드는 중이기 때문입니다(닭-달걀 문제. 개념워크북 3번).
#
# 실습워크북 A-3 / A-4 를 따라 아래 TODO 5개를 채우세요.
# ---------------------------------------------------------------------------

# TODO(A-3) ①: state를 담을 S3 버킷
resource "aws_s3_bucket" "tfstate" {
  bucket = "${var.project_name}-tfstate" # 이름은 전 세계에서 유일해야 합니다

  tags = { Name = "${var.project_name}-tfstate" }
}
#
#   force_destroy 는 넣지 마세요. 켜면 destroy 한 번에 state 이력 전체가 사라집니다.

# TODO(A-3) ②: 버전 관리 Enabled
resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id # 참조. 버킷이 먼저 만들어져야 합니다

  versioning_configuration {
    status = "Enabled"
  }
}

# TODO(A-3) ③: 서버측 암호화 (SSE-S3)
resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# TODO(A-3) ④: 퍼블릭 접근 차단 4종
resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# TODO(A-4) ⑤: state 잠금용 DynamoDB 테이블
resource "aws_dynamodb_table" "tflock" {
  name         = "${var.project_name}-tflock"
  billing_mode = "PAY_PER_REQUEST" # PROVISIONED 는 쓰지 않아도 과금됩니다
  hash_key     = "LockID"          # 이 이름이어야 Terraform이 찾습니다

  attribute {
    name = "LockID"
    type = "S" # S = 문자열
  }

  tags = { Name = "${var.project_name}-tflock" }
}
