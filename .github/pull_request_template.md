## 이번 주 실습/과제 PR

- 주차: week3 (Remote Backend)
- GitHub ID:
- 제출 경로: `submissions/<본인-github-id>/`

### DoD 체크리스트
- [ ] bootstrap `terraform apply` 성공 (`state list` 5줄)
- [ ] app을 로컬 state로 apply 후 `init -migrate-state` 성공. 이어서 `plan`이 `No changes.`
- [ ] S3에 `week03/app/terraform.tfstate` 객체 확인 (스크린샷 첨부)
- [ ] **app 스택 `terraform destroy` 완료.** 콘솔 또는 `scripts/check-leftover.sh`에서 `Purpose=workload` 리소스가 0개인 것을 확인했습니다
- [ ] bootstrap 스택의 S3·DynamoDB는 **지우지 않았습니다** (7주차까지 유지)
- [ ] `git diff`로 자격증명 · `terraform.tfvars` · `*.tfstate` · `state.json` · `*.pem`이 커밋되지 않았는지 확인
- [ ] 스크린샷과 로그의 계정번호 12자리 · 공인 IP를 가렸습니다
- [ ] `submissions/<id>/observations.md`에 `[관찰 ✍️]` 답을 적었습니다 (A-2 · A-6 · B-3 · B-7)
- [ ] `practice/` 아래 파일을 고치지 않았습니다 (`git diff --name-only origin/main`으로 확인)

### 오늘 만든 것 (요약)


### 막힌 지점 / 질문


### destroy 확인
**app 스택에서** 실행한 `terraform state list` 출력:
```
(빈 출력이어야 함)
```

`scripts/check-leftover.sh` 결과 중 `[1] Purpose=workload` 부분:
```
(전부 0 이어야 함. bootstrap 의 S3·DynamoDB 는 [2]에 남아 있는 것이 정상입니다)
```
