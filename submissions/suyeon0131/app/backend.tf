# ---------------------------------------------------------------------------
# backend.tf: app 스택의 state를 어디에 둘지 정하는 파일
#
# 지금은 전체가 주석입니다. 이대로 두고 먼저 로컬 state로 apply 하세요.
# 옮길 state가 있어야 -migrate-state 가 옮길 것이 생깁니다.
#
# backend 블록에는 변수를 쓸 수 없습니다. var.project_name 을 넣을 수 없으니
# bootstrap 스택의 output 값을 손으로 넣어야 합니다. 이유는 개념워크북 4번.
#
# TODO(B-4): 아래 주석을 풀고 bucket 과 dynamodb_table 을
#            `terraform output -raw backend_config` 결과로 바꾸세요.
#            그 출력을 복사해서 붙이면 다섯 줄이 그대로 맞습니다.
# ---------------------------------------------------------------------------

terraform {
  backend "s3" {
    bucket         = "boaz26-w3-suyeon0131-tfstate"
    key            = "week03/app/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "boaz26-w3-suyeon0131-tflock"
    encrypt        = true
  }
}
