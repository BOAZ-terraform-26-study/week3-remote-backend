# ---------------------------------------------------------------------------
# main.tf: state 저장소를 만드는 스택  (채우면 리소스 5개)
#
# 이 스택의 state는 로컬(bootstrap/terraform.tfstate)에 남습니다.
# 자기가 만든 버킷에 자기 state를 넣으려면 버킷이 이미 있어야 하는데,
# 그 버킷을 지금 만드는 중이기 때문입니다(닭-달걀 문제. 개념워크북 3번).
#
# 실습워크북 A-3 / A-4 를 따라 아래 TODO 5개를 채우세요.
# ---------------------------------------------------------------------------

resource "aws_s3_bucket" "tfstate" {
  bucket = "${var.project_name}-tfstate"
  tags   = { Name = "${var.project_name}-tfstate" }
}

resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket                  = aws_s3_bucket.tfstate.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "tflock" {
  name         = "${var.project_name}-tflock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = { Name = "${var.project_name}-tflock" }
}
