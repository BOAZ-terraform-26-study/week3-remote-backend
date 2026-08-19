# Week3 관찰 기록

## [관찰 ✍️] A-2 기록

- 내가 정한 `project_name`: `boaz26-w3-hakyunghahm`

---

## [관찰 ✍️] A-6 기록

- 버킷 이름: `boaz26-w3-hakyunghahm-tfstate`
- 테이블 이름: `boaz26-w3-hakyunghahm-tflock`
- 이 스택의 state는 지금 (로컬 / S3) 에 있습니다: `로컬`
- `state list` 줄 수: `5`

---

## [관찰 ✍️] B-3. 로컬 state를 눈으로 보기

- `state list` 줄 수: `9` (리소스 7 + 데이터 소스 2)
- `terraform.tfstate` 파일 크기: `23760 bytes` (migrate 후 0 bytes로 줄어듦)
- 이 파일이 지금 있는 곳은 (내 노트북 / S3) 입니다: `내 노트북`

---

## [관찰 ✍️] B-6 기록

- 로컬 `terraform.tfstate` 크기: `0 bytes` (migrate 후 비워짐)
- `terraform.tfstate.backup` 크기: `23760 bytes`
- S3 객체 키 전체: `week03/app/terraform.tfstate`

---

## [관찰 ✍️] B-7. 잠금 재현

- 터미널 B에서 본 오류 첫 줄: `Error: Error acquiring the state lock`
- `Lock Info`의 `Who` 값: `hakyunghahm@<hostname>`
- `Operation` 값: `OperationTypeApply`
- DynamoDB 테이블에 항목이 생겼다 사라지는 것을 봤는지: `봤다`
- 잠금이 왜 필요한지 한 문장으로: `여러 사람이 동시에 apply할 경우 state가 서로 덮어씌워져 인프라가 불일치 상태가 되는 것을 막기 위해 필요합니다`

---

## [관찰 ✍️] C-3 기록

- `Purpose=workload` 항목들이 전부 0인가: `예`
- state S3 버킷은 남아 있는가: `예 (boaz26-w3-hakyunghahm-tfstate)`
- DynamoDB 항목 수: apply 중 `1` / 끝난 뒤 `0`
