# app/backend.tf 에 넣을 값을 여기로 꺼냅니다. 실습워크북 A-4.
# 세 개 다 채우세요. A-6 에서 ⑧ 의 출력을 복사해 B-4 에 붙여 넣습니다.

# TODO(A-4) ⑥: bucket_name  ( value = aws_s3_bucket.tfstate.id )
# TODO(A-4) ⑦: table_name   ( value = aws_dynamodb_table.tflock.name )

output "bucket_name" {
  description = "state를 담는 S3 버킷 이름. app/backend.tf 의 bucket 에 그대로 넣습니다"
  value       = aws_s3_bucket.tfstate.id
}

output "table_name" {
  description = "잠금용 DynamoDB 테이블 이름. app/backend.tf 의 dynamodb_table 에 넣습니다"
  value       = aws_dynamodb_table.tflock.name
}

# TODO(A-4) ⑧: backend.tf 에 붙여 넣을 다섯 줄을 그대로 출력
#   손으로 옮겨 적다가 버킷 이름을 틀리면 init 이 NoSuchBucket 으로 죽습니다.
#   복사해서 붙이면 그 사고가 없어집니다.
#
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
