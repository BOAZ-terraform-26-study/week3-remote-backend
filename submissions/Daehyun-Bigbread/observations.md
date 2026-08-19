# Week3 관찰 기록

## [관찰 ✍️] A-2 기록

- 내가 정한 `project_name`: `boaz26-w3-daehyun-bigbread`

---

## [관찰 ✍️] A-6 기록

- 버킷 이름: `boaz26-w3-daehyun-bigbread-tfstate`
- 테이블 이름: `boaz26-w3-daehyun-bigbread-tflock`
- 이 스택의 state는 지금 (로컬 / S3) 에 있습니다: `로컬`
- `state list` 줄 수: `5`

---

## [관찰 ✍️] B-3. 로컬 state를 눈으로 보기

- `state list` 줄 수: `9` (리소스 7 + 데이터 소스 2)
- `terraform.tfstate` 파일 크기: `23854 bytes`
- 이 파일이 지금 있는 곳은 (내 노트북 / S3) 입니다: `내 노트북`

---

## [관찰 ✍️] B-6 기록

- 로컬 `terraform.tfstate` 크기: `0 bytes` (migrate 후 비워짐)
- `terraform.tfstate.backup` 크기: `23854 bytes`
- S3 객체 키 전체: `week03/app/terraform.tfstate`
- S3 객체 크기: `23854 bytes` (backup과 같은 크기. 그대로 옮겨졌다는 뜻입니다)

`init -migrate-state` 직후 `plan`은 `No changes. Your infrastructure matches the configuration.` 였습니다.

---

## [관찰 ✍️] B-7. 잠금 재현

미실시입니다. 채우지 못한 이유를 적어둡니다.

워크북 B-7은 터미널 A에서 `terraform apply`를 띄우고 `yes` 직전에 대기하라고 합니다. 그런데 B-5와 B-6을 지난 시점에는 `plan`이 `No changes.`입니다. 변경할 것이 없으면 Terraform은 확인 프롬프트를 띄우지 않고 바로 끝나므로 대기할 지점이 없고, 잠금도 유지되지 않았습니다. 그 상태에서 터미널 B의 `plan`은 막히지 않고 잠금을 정상 획득했습니다.

- 터미널 B에서 본 오류 첫 줄: `미실시`
- `Lock Info`의 `Who` 값: `미실시`
- `Operation` 값: `미실시`
- DynamoDB 테이블에 항목이 생겼다 사라지는 것을 봤는지: `못 봤다`
- 잠금이 왜 필요한지 한 문장으로: `두 사람이 동시에 apply하면 나중에 끝난 쪽이 상대의 변경을 덮어써 state와 실제 인프라가 어긋나기 때문에, 한 번에 한 명만 state를 쓰도록 막아야 합니다`

대신 관찰한 것을 적습니다. destroy가 끝난 뒤 DynamoDB 테이블을 스캔했을 때 항목이 1개 남아 있었는데, `LockID`가 `boaz26-w3-daehyun-bigbread-tfstate/week03/app/terraform.tfstate-md5`였습니다. 이것은 잠금 항목이 아니라 state 체크섬(`Digest`)을 보관하는 항목이고 상시 남아 있습니다. 실제 잠금 항목은 `LockID`가 `-md5` 없이 `버킷/키`로 끝나고 `Info` 필드를 갖습니다.

---

## [관찰 ✍️] C-3 기록

- `Purpose=workload` 항목들이 전부 0인가: `예` (EC2 · 미사용 EBS · Elastic IP · NAT Gateway · workload VPC 모두 0)
- state S3 버킷은 남아 있는가: `예 (boaz26-w3-daehyun-bigbread-tfstate)`
- DynamoDB 항목 수: destroy 뒤 `1` (위에 적은 `-md5` 다이제스트 항목)

`scripts/check-leftover.sh`가 서울 · 버지니아 · 도쿄 세 리전에서 살아 있는 인스턴스 0대를 확인했습니다.
