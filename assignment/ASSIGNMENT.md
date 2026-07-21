# Week3 과제② (다음 리뷰: Week4)

## 목표
- 본인 계정에 remote backend(S3+DynamoDB)를 구성하고, app state를 원격으로 이전한다.

## 필수 (Must)
1. `bootstrap/` 스택으로 state용 S3 버킷 + DynamoDB(`PAY_PER_REQUEST`) 생성
2. `app/backend.tf`를 채우고 `terraform init -migrate-state`로 로컬 state를 S3로 이전
3. S3 콘솔에서 `.tfstate` 객체 확인 스크린샷
4. app 스택 `destroy` (bootstrap은 유지 OK)
5. Week4 예습: `variable` 타입(map/list/object), `for_each` vs `count`, `locals`, `output`

## 제출물 (repo: `assignments`, 폴더: `round2-week3/{github-id}/`)
- [ ] bootstrap + app 코드 (`terraform.tfvars`, `*.tfstate` 제외)
- [ ] 워크북 (`workbook-week3.md`)
- [ ] S3에 tfstate 올라간 스크린샷 + destroy 확인

## 심화 (Optional ⭐)
- `-backend-config` 파일 분리 / DynamoDB 없이 `use_lockfile` 방식 비교

## 리뷰 방식
- Week4 과제 리뷰 5분에 대표 PR 공유
