# bootstrap: state 저장소를 만드는 스택 (state는 로컬에 남깁니다)

```bash
cp example.tfvars terraform.tfvars   # project_name 채우기 (app 스택과 같은 값)
terraform fmt && terraform init
terraform validate
terraform plan                       # "Plan: 5 to add"
terraform apply                      # yes
terraform output -raw backend_config # app/backend.tf 에 붙여 넣을 다섯 줄
```

- `main.tf` · `outputs.tf`의 `# TODO` 8개를 채우며 진행합니다. 자세한 순서는 `lecture/실습워크북.md` Block A.
- 이 스택의 state는 원격으로 옮기지 않습니다. 옮길 저장소를 지금 만드는 중이라 옮길 곳이 없습니다(닭-달걀 문제).
- **이 스택은 세션 끝에 destroy하지 않습니다.** app 스택의 state가 이 버킷 안에 들어 있습니다. 지우는 절차는 실습워크북 C-5.

> [!CAUTION]
> `terraform.tfstate` 파일을 지우지 마세요. 이 파일은 `.gitignore` 대상이라 커밋되지 않고,
> 7주차에 버킷과 테이블을 지울 때 필요한 유일한 기록입니다. 파일을 잃으면
> `terraform destroy` 로 지울 수 없고 콘솔에서 직접 지워야 합니다.
> 폴더를 백업해 두거나, 버킷 이름과 테이블 이름을 따로 적어 두세요.
