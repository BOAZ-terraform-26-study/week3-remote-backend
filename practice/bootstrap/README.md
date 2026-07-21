# bootstrap — state 저장소 만들기 (로컬 state)
```bash
cp ../example.tfvars terraform.tfvars
terraform init && terraform apply
terraform output   # app/backend.tf 에 넣을 bucket/table 이름
```
이 스택은 로컬 state로 둡니다. destroy는 스터디 마지막(7주)에.
