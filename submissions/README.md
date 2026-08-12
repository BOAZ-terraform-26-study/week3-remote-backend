# submissions

Week3 실습 제출 폴더입니다. **본인 GitHub ID로 폴더를 만들어** 제출하세요.

```
submissions/
├── kdh1834/
│   ├── bootstrap/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── variables.tf
│   │   ├── providers.tf
│   │   ├── versions.tf
│   │   └── example.tfvars
│   ├── app/
│   │   ├── backend.tf          # 주석을 푼 상태. 버킷 이름은 본인 것
│   │   ├── network.tf
│   │   ├── compute.tf
│   │   ├── outputs.tf
│   │   ├── variables.tf
│   │   ├── providers.tf
│   │   ├── versions.tf
│   │   └── example.tfvars
│   ├── state-list.txt          # destroy 전에 저장한 증빙 (마스킹 필수)
│   ├── s3-object.png           # S3 에 tfstate 올라간 화면 (마스킹 필수)
│   └── observations.md         # 워크북 [관찰 ✍️] 답안
└── {your-github-id}/
    └── ...
```

## 규칙

- 폴더 이름은 **본인 GitHub ID**. 사람마다 폴더가 달라서 PR이 충돌하지 않고 전부 머지됩니다.
- **`practice/`는 건드리지 마세요.** 거기는 다음 사람이 풀 `# TODO` 스켈레톤입니다.
- **`terraform.tfvars`(내 공인 IP) · `terraform.tfstate` · `*.backup` · `state.json` · `backend.hcl` · `*.pem`은 절대 커밋 금지.** `.gitignore`가 막고 있지만 푸시 전에 `git status`로 한 번 더 확인하세요.
- 증빙에서 **두 가지를 반드시 가리세요.**
  - **공인 IP** (`x.x.x.x`). 22번이 열려 있던 서버 주소이고 `my_ip`에 넣은 본인 주소입니다
  - **계정번호 12자리.** ARN 안에 들어 있습니다 (`arn:aws:dynamodb:ap-northeast-2:123456789012:table/...`)

## `observations.md`에 넣을 것

실습워크북의 `[관찰 ✍️]` 문항입니다.

| 스텝 | 문항 |
|------|------|
| A-2 | 내가 정한 `project_name` |
| A-6 | 버킷 이름 · 테이블 이름 · 이 스택의 state 위치 |
| B-3 | `state list` 줄 수 · `terraform.tfstate` 크기 · 파일이 있는 곳 |
| B-7 | 잠금 오류 첫 줄 · `Lock Info`의 `Who` · `Operation` · DynamoDB 항목을 봤는지 · 잠금이 왜 필요한지 |

## 마스킹 명령

`practice/app`에서 destroy **전에** 실행합니다. `ID`를 본인 GitHub ID로 바꾸세요.

```bash
ID=본인-github-id
echo "$ID"                  # 바꿨는지 눈으로 확인
mkdir -p "../../submissions/$ID"

terraform state list > "../../submissions/$ID/state-list.txt"

sed -E \
  -e 's/[0-9]{12}/<account-id>/g' \
  -e 's/([0-9]{1,3}\.){3}[0-9]{1,3}/x.x.x.x/g' \
  "../../submissions/$ID/state-list.txt" > "../../submissions/$ID/masked.txt"
mv "../../submissions/$ID/masked.txt" "../../submissions/$ID/state-list.txt"
```

커밋 직전에 확인합니다. 아무것도 안 나와야 정상입니다.

```bash
git diff --cached | grep -nE '([0-9]{1,3}\.){3}[0-9]{1,3}|[0-9]{12}|AKIA[0-9A-Z]{16}'
git status --porcelain | grep -E 'terraform\.tfvars|\.tfstate|\.pem'
```

저장한 뒤 **파일을 한 번 눈으로 읽고** 커밋하세요. 스크린샷은 명령으로 걸러지지 않으니 직접 가려야 합니다.

자세한 절차는 [실습워크북 C-4 · C-6](../lecture/실습워크북.md)과 [과제 문서](../assignment/ASSIGNMENT.md).
