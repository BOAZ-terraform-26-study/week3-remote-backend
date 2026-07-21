# bootstrap output 값으로 채워진 예시. 각자 project_name에 맞게 수정.
terraform {
  backend "s3" {
    bucket         = "boaz-tf-yourname-tfstate"
    key            = "week03/app/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "boaz-tf-yourname-tflock"
    encrypt        = true
  }
}
