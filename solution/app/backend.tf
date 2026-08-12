# bootstrap output 형식 예시입니다. 본인 project_name 으로 바꾸세요.
#
# 실습에서는 이 파일을 주석 상태로 시작해서 로컬 state로 apply 한 뒤,
# 주석을 풀고 `terraform init -migrate-state` 로 옮깁니다. 실습워크북 B-2 · B-4.
#
# init 할 때 dynamodb_table 이 deprecated 라는 경고가 뜹니다. 정상입니다.
# 오늘은 잠금이 걸리는 것을 콘솔에서 눈으로 보려고 DynamoDB 방식을 씁니다. 개념워크북 9번.
terraform {
  backend "s3" {
    bucket         = "boaz26-w3-kdh1834-tfstate"
    key            = "week03/app/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "boaz26-w3-kdh1834-tflock"
    encrypt        = true
  }
}
