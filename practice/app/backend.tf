# ⚠ backend 블록은 변수를 쓸 수 없습니다. bootstrap output 값을 직접 넣으세요.
terraform {
  backend "s3" {
    bucket         = "boaz-tf-yourname-tfstate" # TODO: bootstrap output bucket_name
    key            = "week03/app/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "boaz-tf-yourname-tflock" # TODO: bootstrap output table_name
    encrypt        = true
  }
}
