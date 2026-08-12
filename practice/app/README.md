# app: 워크로드 스택 (원격 backend 사용)

`network.tf` · `compute.tf`는 week2 정답 코드와 같습니다. 오늘은 채우지 않고 읽기만 합니다.
손으로 만드는 것은 `terraform.tfvars`와 `backend.tf`뿐입니다.

순서가 핵심입니다. 먼저 로컬 state로 만들고, 그 다음 옮깁니다.

```bash
cp example.tfvars terraform.tfvars   # project_name(bootstrap과 같은 값) · my_ip 채우기
terraform init                       # backend.tf 는 아직 주석. 로컬 state로 시작
terraform plan                       # "Plan: 7 to add"
terraform apply                      # yes. 여기까지 state는 로컬 파일

# backend.tf 주석을 풀고 bucket/dynamodb_table 을 bootstrap output 값으로 교체
terraform init -migrate-state        # yes. 로컬에서 S3로 이전
terraform plan                       # "No changes." 여야 정상

terraform destroy                    # 실습 끝나면 반드시. "7 destroyed"
```

- 자세한 순서는 `lecture/실습워크북.md` Block B.
- `terraform state list`는 9줄입니다. 리소스 7개에 데이터 소스 2개가 더해집니다.
- `init` 때 `dynamodb_table` deprecated 경고가 뜨는 것은 정상입니다. 개념워크북 9번.

> [!IMPORTANT]
> `-migrate-state` 뒤의 `plan`이 `No changes.`가 아니라 `7 to add`면 state가 옮겨지지 않은 것입니다. 그대로 `apply`하면 리소스가 두 벌 생깁니다. 멈추고 물어보세요.
