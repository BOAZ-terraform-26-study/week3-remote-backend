# ---------------------------------------------------------------------------
# backend.tf: app 스택의 state를 어디에 둘지 정하는 파일
#
# 이 파일을 켜기 전에 먼저 로컬 state로 apply 했습니다.
# 옮길 state가 있어야 -migrate-state 가 옮길 것이 생깁니다.
#
# backend 블록에는 변수를 쓸 수 없습니다. var.project_name 을 넣을 수 없으니
# bootstrap 스택의 output 값을 손으로 넣어야 합니다. 이유는 개념워크북 4번.
#
# 아래 다섯 줄은 bootstrap 의 `terraform output -raw backend_config` 출력입니다.
# ---------------------------------------------------------------------------

terraform {
  backend "s3" {
    bucket         = "boaz26-w3-daehyun-bigbread-tfstate"
    key            = "week03/app/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "boaz26-w3-daehyun-bigbread-tflock"
    encrypt        = true
  }
}
