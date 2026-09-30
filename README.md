# Week 3. Remote Backend (S3 + DynamoDB) `[비대면]`

> **강의자료:** [개념워크북](./lecture/개념워크북.pdf) · [실습워크북](./lecture/실습워크북.pdf)
> 개념워크북은 예습으로 읽고, 실습워크북을 위에서 아래로 따라가며 진행합니다. 원본은 같은 폴더의 `.md` 파일입니다.

> 이번 주가 끝나면: 로컬 `tfstate`를 **S3 원격 backend로 옮기고**, DynamoDB로 state 잠금이 걸리는 순간을 확인합니다.

## 0. 메타 정보
| 항목 | 내용 |
|------|------|
| 일시 | 2026-MM-DD · 60분 |
| 방식 | 비대면 (Discord) |
| 선행 | week2 완료 (VPC/EC2 코드 재사용) |
| 산출물 | `submissions/{github-id}/` PR · **과제② 출제** |

## 1. 학습 목표
- [ ] 로컬 tfstate의 한계(공유 · 잠금 · 유실 · 평문 시크릿)를 설명할 수 있습니다
- [ ] S3 backend와 DynamoDB 잠금을 구성하고 `init -migrate-state`로 이전할 수 있습니다
- [ ] state 잠금이 언제 걸리는지 동시 apply로 재현할 수 있습니다

## 2. 사전 예습 (필수)
- `lecture/개념워크북.md`의 Part 0 · 1 · 4 · 5를 읽어 오세요. 라이브에서는 Part 2 · 3 · 6만 다룹니다.
- HashiCorp: [Backend block](https://developer.hashicorp.com/terraform/language/backend) · [S3 backend](https://developer.hashicorp.com/terraform/language/backend/s3) (15분)
- 예습 체크: "backend 블록에 변수를 못 쓰는 이유"를 안다. 답은 개념워크북 4번입니다.

## 3. 진행 타임박스 (60분)
| 시간 | 구성 | 내용 |
|------|------|------|
| 0~10분 | 회고 | 무작위 지명 |
| 10~55분 | 실습 45분 | Block A 저장소 만들기 · Block B 원격 이전과 잠금 · Block C 정리 |
| 55~60분 | 마무리 | 과제② 브리핑, 4주차 예고 |

## 4. 실습 개요: 왜 스택을 둘로 나누는가

state를 담을 S3 버킷도 Terraform으로 만들고 싶은데, 그것을 만드는 apply의 state는 어디에 둘까요. 저장소가 아직 없습니다. 이 닭-달걀 문제를 스택 두 개로 나눠 풉니다.

```
practice/
 ├─ bootstrap/   # state 저장소(S3+DynamoDB) 5개. 이 스택의 state는 로컬에 남습니다
 └─ app/         # 워크로드(week2 VPC/EC2) 7개. backend.tf 로 원격 state 사용
```

```bash
# 1) 저장소 먼저 만들기 (로컬 state)
cd practice/bootstrap
cp example.tfvars terraform.tfvars    # project_name 채우기. 커밋 금지
terraform init
terraform plan                        # "Plan: 5 to add"
terraform apply                       # yes
terraform output -raw backend_config  # app/backend.tf 에 붙여 넣을 다섯 줄

# 2) app 스택: 먼저 로컬 state로 만들고, 그 다음 원격으로 옮깁니다
cd ../app
cp example.tfvars terraform.tfvars    # project_name(1과 동일) · my_ip 채우기
terraform init                        # backend.tf 는 아직 주석. 로컬 state
terraform plan                        # "Plan: 7 to add"
terraform apply                       # yes
#   backend.tf 주석을 풀고 1)의 output 값으로 bucket/dynamodb_table 교체
terraform init -migrate-state         # 로컬에서 S3로 이전 (yes)
terraform plan                        # "No changes." 여야 정상

# 3) 정리: app 만 destroy. bootstrap 은 7주차에 (실습워크북 C-5)
terraform destroy                     # yes
terraform state list                  # 빈 출력이어야 정상
../../scripts/check-leftover.sh       # Purpose=workload 전부 0
```

> [!IMPORTANT]
> 순서가 핵심입니다. `backend.tf`를 처음부터 켜두면 옮길 state가 없어서 `-migrate-state`가 아무 일도 하지 않습니다. 먼저 로컬로 `apply`한 뒤에 backend를 켜세요.

## 5. 체크포인트 (DoD)
- [ ] bootstrap `state list` 5줄, app `state list` 9줄 (리소스 7 + 데이터 소스 2)
- [ ] `init -migrate-state` 성공. 이어서 `plan`이 `No changes.`
- [ ] S3에 `week03/app/terraform.tfstate` 객체가 올라간 것 확인
- [ ] 두 터미널에서 동시 실행해 `Error acquiring the state lock` 재현
- [ ] **app 스택 `destroy` 완료.** bootstrap의 S3·DynamoDB는 7주차까지 남겨 둡니다
- [ ] `terraform state list`가 빈 것과 계정에 `Purpose=workload`가 0인 것을 각각 확인

## 6. 트러블슈팅 FAQ
| 증상 | 원인 | 해결 |
|------|------|------|
| `backend.tf`에 `var.` 못 씀 | init이 backend를 먼저 초기화하고 그때는 변수가 평가되지 않음 | 값 직접 입력 또는 `-backend-config` 파일 |
| `NoSuchBucket` on init | 버킷 이름 오타 또는 bootstrap 미실행 | `terraform output -raw backend_config` 출력과 대조 |
| `AccessDenied` on init | IAM 권한 부족 | 개념워크북 Part 3의 권한 목록 |
| migrate 후 `7 to add` | state가 옮겨지지 않음 | 멈추고 질문. 그대로 apply하면 리소스가 중복으로 생깁니다 |
| 잠금이 해제되지 않은 채 남음 | 비정상 종료 | 아무도 작업 안 하는 것 확인 후 `terraform force-unlock <LOCK_ID>` |
| `dynamodb_table` deprecated 경고 | Terraform 1.10+ 는 `use_lockfile` 권장 | 정상입니다. 잠금을 콘솔에서 보려고 DynamoDB를 씁니다 |
| DynamoDB 과금 걱정 | `PROVISIONED`는 쓰지 않아도 과금 | 반드시 `PAY_PER_REQUEST`. 온디맨드 요청은 프리티어 대상이 아니지만 서울 리전 쓰기 100만 건 $0.68이라 실습 규모에서는 $0.00입니다 |

## 7. 심화 도전과제 (심화 ⭐)
- L2: `-backend-config=backend.hcl` 파일로 값 분리 (실습워크북 B-8)
- L3: Terraform 1.10+ S3 backend의 `use_lockfile = true`로 **DynamoDB 없이** 잠그고 비교 (실습워크북 B-9)

## 8. 다음 주 예고 & 준비물

| 오늘 본 것 | Week4에서 문제가 되는 지점 |
|-----------|--------------------------|
| `backend.tf`에 버킷 이름을 직접 적었습니다 | backend는 변수를 못 받습니다. 나머지 값은 어디까지 분리할 수 있을까요 |
| `project_name` 하나로 리소스 12개 이름을 조립했습니다 | 이름 목록 자체가 여러 개라면 (`for_each` vs `count`) |
| 같은 조립식을 여러 파일에 반복했습니다 | 한 곳에 모아 관리할 방법이 필요합니다 (`locals`) |

- Week4(대면): 변수와 반복. variables/outputs, `for_each`로 하드코딩 제거
- 예습: `variable` 타입(map/list/object), `for_each` vs `count`, `locals`

---

> [!CAUTION]
> **비용.** app 스택은 시간당 $0.019입니다. destroy를 잊고 한 달 두면 약 $13.87이 발생합니다. bootstrap의 S3·DynamoDB는 한 달 $0.01 미만이라 7주차까지 남겨 둡니다. stop은 destroy가 아닙니다. 인스턴스를 멈춰도 EBS 8GiB의 월 $0.73은 계속 발생합니다.
>
> **올리면 안 되는 값.** 본인 공인 IP · AWS 계정번호 12자리 · 액세스 키 · `terraform.tfvars` · `terraform.tfstate` · `state.json` · `.pem` 파일. 마스킹 절차는 실습워크북 C-4에 있습니다.

> **제출.** `submissions/{본인-github-id}/`에 PR로 올립니다. `practice/`는 직접 고쳐 올리지 마세요. 머지되는 순간 다음 사람이 풀 빈칸이 없어집니다.
