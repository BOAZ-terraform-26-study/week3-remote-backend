# Week3 과제② (다음 리뷰: Week4)

## 목표

본인 계정에 remote backend(S3 + DynamoDB)를 구성하고, app 스택의 state를 원격으로 이전합니다.

## 코드로 해야 하는 것

1. `bootstrap/` 스택으로 state용 S3 버킷과 DynamoDB 테이블(`PAY_PER_REQUEST`)을 만듭니다. TODO 8개를 채우면 리소스 5개입니다.
2. app 스택을 **먼저 로컬 state로** `apply`합니다. `Plan: 7 to add`가 나와야 합니다.
3. `app/backend.tf`의 주석을 풀고 bootstrap output 값을 넣은 뒤 `terraform init -migrate-state`로 이전합니다. 이어서 `plan`이 `No changes.`여야 합니다.
4. app 스택을 `destroy`합니다. bootstrap의 S3·DynamoDB는 7주차까지 남겨 둡니다.

> [!IMPORTANT]
> 3번의 순서를 지키세요. `backend.tf`를 처음부터 켜두면 옮길 state가 없어서 `-migrate-state`가 아무 일도 하지 않습니다. 자세한 절차는 `lecture/실습워크북.md` Block B에 있습니다.

## 증빙

- S3에 `week03/app/terraform.tfstate` 객체가 올라간 스크린샷
- 잠금 재현 화면 또는 `Error acquiring the state lock` 메시지
- `terraform state list` 빈 출력과 `scripts/check-leftover.sh` 결과

## 제출물

이 리포지토리의 `submissions/{본인-github-id}/` 아래에 넣고 PR을 올립니다.

- [ ] `bootstrap/` · `app/`의 `.tf` 파일
- [ ] `example.tfvars` (값은 채우지 않은 상태)
- [ ] `state-list.txt` (마스킹 완료)
- [ ] `observations.md` : 실습워크북의 `[관찰 ✍️]` 답안 (A-2 · A-6 · B-3 · B-7)
- [ ] S3 객체 스크린샷 (마스킹 완료)
- [ ] 스크린샷과 로그의 계정번호 12자리 · 공인 IP를 가렸습니다

> [!CAUTION]
> `terraform.tfvars` · `terraform.tfstate` · `*.backup` · `state.json` · `backend.hcl` · `.pem` 파일은 올리지 않습니다. `.gitignore`로 제외되어 있지만 푸시 전에 `git status`로 한 번 더 확인하세요. 마스킹 명령은 실습워크북 C-4에 있습니다.
>
> `practice/`를 직접 고쳐 올리지 마세요. 머지되는 순간 다음 사람이 풀 빈칸이 없어집니다.

## 다음 주 예습

`variable` 타입(map/list/object), `for_each` vs `count`, `locals`, `output`

## 심화 (심화 ⭐)

- `-backend-config=backend.hcl` 파일로 값 분리 (실습워크북 B-8)
- Terraform 1.10+ S3 backend의 `use_lockfile = true`로 DynamoDB 없이 잠그고 비교 (실습워크북 B-9)

## 리뷰 방식

Week4 과제 리뷰 5분에 대표 PR을 함께 봅니다.
