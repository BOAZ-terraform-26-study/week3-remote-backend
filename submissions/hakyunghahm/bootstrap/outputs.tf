# app/backend.tf 에 넣을 값을 여기로 꺼냅니다. 실습워크북 A-4.
# 세 개 다 채우세요. A-6 에서 ⑧ 의 출력을 복사해 B-4 에 붙여 넣습니다.

output "bucket_name" {
  value = aws_s3_bucket.tfstate.id
}

output "table_name" {
  value = aws_dynamodb_table.tflock.name
}

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
