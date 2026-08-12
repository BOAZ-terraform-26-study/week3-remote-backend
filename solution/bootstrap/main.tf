# ---------------------------------------------------------------------------
# main.tf: state 저장소를 만드는 스택  (리소스 5개)
#
# 이 스택의 state는 로컬(bootstrap/terraform.tfstate)에 남습니다.
# 자기가 만든 버킷에 자기 state를 넣으려면 버킷이 이미 있어야 하는데,
# 그 버킷을 지금 만드는 중이기 때문입니다(닭-달걀 문제. 개념워크북 3번).
# ---------------------------------------------------------------------------

# state를 담을 버킷. 이름은 전 세계에서 유일해야 합니다.
# 다른 사람이 이미 쓰고 있는 이름이면 BucketAlreadyExists 로 실패하므로
# project_name 에 본인 GitHub ID를 넣어 충돌을 피합니다.
resource "aws_s3_bucket" "tfstate" {
  bucket = "${var.project_name}-tfstate"

  # force_destroy 를 켜지 않습니다.
  # 켜면 terraform destroy 한 번에 state 이력 전체가 사라집니다.
  # 이 버킷을 지우는 절차는 실습워크북 C-5에 따로 적어 뒀습니다.

  tags = { Name = "${var.project_name}-tfstate" }
}

# 버전 관리. state 저장소에서는 선택이 아니라 필수입니다.
# 잘못된 state를 밀어 넣었을 때 되돌릴 수 있는 유일한 수단이기 때문입니다.
# 같은 키에 덮어써도 이전 버전이 남습니다(개념워크북 12번).
resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

# 서버측 암호화. state는 평문 JSON이고 그 안에 시크릿이 섞여 들어갑니다.
# AES256 은 S3가 관리하는 키를 쓰는 방식(SSE-S3)이라 추가 비용이 없습니다.
resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 퍼블릭 접근 차단 4종. state 버킷이 공개되면 인프라 전체 설계도가 유출됩니다.
# 실수로 공개 정책을 붙이더라도 이 리소스가 먼저 막습니다.
resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# state 잠금용 테이블.
# Terraform은 apply를 시작할 때 LockID 를 키로 항목 하나를 넣고, 끝나면 지웁니다.
# 항목이 이미 있으면 넣기가 실패하고, 그게 "다른 사람이 작업 중"이라는 신호가 됩니다.
#
# hash_key 이름은 반드시 "LockID" 여야 합니다. Terraform이 그 이름으로 찾습니다.
# billing_mode 는 반드시 PAY_PER_REQUEST. PROVISIONED 로 두면 쓰지 않아도 과금됩니다.
resource "aws_dynamodb_table" "tflock" {
  name         = "${var.project_name}-tflock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S" # S = 문자열
  }

  tags = { Name = "${var.project_name}-tflock" }
}
