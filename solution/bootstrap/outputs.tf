output "bucket_name" {
  description = "state를 담는 S3 버킷 이름. app/backend.tf 의 bucket 에 그대로 넣습니다"
  value       = aws_s3_bucket.tfstate.id
}

output "table_name" {
  description = "잠금용 DynamoDB 테이블 이름. app/backend.tf 의 dynamodb_table 에 넣습니다"
  value       = aws_dynamodb_table.tflock.name
}

# app/backend.tf 에 붙여 넣을 다섯 줄을 그대로 출력합니다.
# 직접 옮겨 적다가 버킷 이름을 틀리면 init 이 NoSuchBucket 으로 실패합니다.
# 복사해서 붙이면 그 사고가 없어집니다.
#
# 꺼내는 명령: terraform output -raw backend_config
output "backend_config" {
  description = "app/backend.tf 의 backend \"s3\" 블록 안에 붙여 넣을 값 다섯 줄"
  value       = <<-EOT
    bucket         = "${aws_s3_bucket.tfstate.id}"
    key            = "week03/app/terraform.tfstate"
    region         = "${var.region}"
    dynamodb_table = "${aws_dynamodb_table.tflock.name}"
    encrypt        = true
  EOT
}
