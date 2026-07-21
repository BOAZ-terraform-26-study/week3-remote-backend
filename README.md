# Week 3. Remote Backend (S3 + DynamoDB) `[비대면]`

> 이번 주가 끝나면: **로컬 `tfstate`를 S3 원격 backend로 옮기고, DynamoDB로 state 잠금을 이해한다.**

## 0. 메타 정보
| 항목 | 내용 |
|------|------|
| 일시 | 2026-MM-DD · 60분 |
| 방식 | 비대면 (Discord) |
| 선행 | week2 완료 (VPC/EC2 코드 재사용) |
| 산출물 | 실습 PR + 워크북 · **과제② 출제** |

## 1. 학습 목표 (측정 가능)
- [ ] 로컬 tfstate의 한계(공유·잠금·유실·평문 시크릿)를 설명할 수 있다
- [ ] S3 backend + DynamoDB lock을 구성하고 `init -migrate-state`로 이전할 수 있다
- [ ] state 잠금이 언제 걸리는지(동시 apply) 재현할 수 있다

## 2. 사전 예습 (필수)
- HashiCorp: [Backend block](https://developer.hashicorp.com/terraform/language/backend), [S3 backend](https://developer.hashicorp.com/terraform/language/backend/s3) (15분)
- 예습 체크: "backend 블록에 변수를 못 쓰는 이유"를 안다

## 3. 진행 타임박스 (60분)
| 시간 | 구성 | 내용 |
|------|------|------|
| 0~10분 | 회고 | 랜덤 지목 |
| 10~55분 | 실습 45분 | bootstrap 배포 → app을 원격 backend로 이전 → 잠금 체험 |
| 55~60분 | 마무리 | 과제② 브리핑, 4주차 예고 |

## 4. 실습 개요 — 왜 2단 구조인가 (핵심!)
backend를 destroy하면 state 저장소 자체가 사라지는 "닭이 먼저냐 달걀이 먼저냐" 문제가 생깁니다. 그래서 **2단 스택**으로 나눕니다.

```
practice/
 ├─ bootstrap/   # state 저장소(S3+DynamoDB)를 만드는 스택 — 로컬 state로 apply
 └─ app/         # 실제 워크로드(week2 VPC/EC2) — backend.tf로 원격 state 사용
```

```bash
# 1) 저장소 먼저 만들기 (로컬 state)
cd practice/bootstrap
terraform init && terraform apply     # S3 버킷 + DynamoDB 테이블 생성
terraform output                      # bucket_name, table_name 확인

# 2) app 스택을 원격 backend로
cd ../app
#   backend.tf 의 bucket/dynamodb_table 값을 1)의 output으로 채우기
terraform init -migrate-state         # 로컬 -> S3 이전 (yes)
terraform apply

# 3) 정리: app 먼저 destroy, bootstrap은 스터디 마지막(7주)에 destroy
cd ../app && terraform destroy
```

## 5. 체크포인트 (DoD)
- [ ] S3에 `.tfstate` 객체가 올라간 것 확인 (콘솔)
- [ ] `init -migrate-state` 성공, 로컬 tfstate가 비워짐
- [ ] (선택) 두 터미널에서 동시 apply → 한쪽이 lock 대기하는 것 확인
- [ ] **app 스택 `destroy` 완료** (bootstrap은 마지막 주까지 유지 가능)

## 6. 트러블슈팅 FAQ
| 증상 | 원인 | 해결 |
|------|------|------|
| backend.tf에 `var.` 못 씀 | backend는 변수 불가 | 값 하드코딩 또는 `-backend-config` 파일 사용 |
| `NoSuchBucket` on init | bootstrap 안 만듦 | bootstrap 먼저 apply |
| lock 걸린 채 크래시 | 비정상 종료 | `terraform force-unlock <LOCK_ID>` (주의) |
| DynamoDB 과금 걱정 | Provisioned 큰 용량 | 반드시 `PAY_PER_REQUEST` (프리티어 내) |

## 7. 심화 도전과제 (Optional ⭐)
- L2: `-backend-config=backend.hcl` 파일로 값 분리
- L3-⭐: AWS provider 6.x의 **DynamoDB 없이** state 잠금 (`use_lockfile = true`) 비교

## 8. 다음 주 예고 & 준비물
- Week4(대면): 변수와 반복 — variables/outputs, for_each로 하드코딩 제거
- 예습: `variable` 타입(map/list/object), `for_each` vs `count`, `locals`

---
> ⚠️ **비용 주의**: DynamoDB는 **반드시 `PAY_PER_REQUEST`**. app 스택은 매주 destroy(EC2!). bootstrap의 S3/DynamoDB는 유지비 사실상 $0이지만, 7주차 마지막에 함께 destroy.
> **공통 규칙**: 자격증명/secret 커밋 금지 · `destroy` 확인 · 코드는 PR로
