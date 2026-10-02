### [관찰 ✍️] 내가 정한 `project_name`: `boaz26-w3-seoyeon83`

### [관찰 ✍️] A-6 기록

- 버킷 이름: `boaz26-w3-seoyeon83-tfstate`
- 테이블 이름: `boaz26-w3-seoyeon83-tflock`
- 이 스택의 state는 지금 (로컬 / S3) 에 있습니다: `로컬`
- `state list` 줄 수: `5`

### [관찰 ✍️] B-3. 로컬 state를 눈으로 보기

지금 하는 일은 옮기기 전에 무엇을 옮기는지 확인하는 것입니다.

```bash
# pwd == practice/app
terraform state list        # 9줄
ls -l terraform.tfstate     # 파일 크기
```

- `state list` 줄 수: `9` (리소스 7 + 데이터 소스 2)
- `terraform.tfstate` 파일 크기: `23721`
- 이 파일이 지금 있는 곳은 (내 노트북 / S3) 입니다: `내 노트북`

### [관찰 ✍️] B-6 기록

- 로컬 `terraform.tfstate` 크기: `0`
- `terraform.tfstate.backup` 크기: `23721`
- S3 객체 키 전체: `s3://boaz26-w3-seoyeon83-tfstate/week03/app/terraform.tfstate`

### [관찰 ✍️] B-7. 잠금 재현

- 터미널 B에서 본 오류 첫 줄: Error message: operation error DynamoDB: PutItem, https response error StatusCode: 400`
- `Lock Info`의 `Who` 값: `DESKTOP-JLL1P0D\mool8@DESKTOP-JLL1P0D`
- `Operation` 값: `OperationTypePlan`
- DynamoDB 테이블에 항목이 생겼다 사라지는 것을 봤는지: (봤다 / 못 봤다) `봤다`
- 잠금이 왜 필요한지 한 문장으로: `두 작업자가 동시에 작업하면 앞 사람이 작업하던 것들이 덮어씌워질 수 있기 때문에`

### [관찰 ✍️] C-3 기록

- `Purpose=workload` 항목들이 전부 0인가: `네`
- state S3 버킷은 남아 있는가: `네`
- DynamoDB 항목 수: apply 중 `1` / 끝난 뒤 `0`
