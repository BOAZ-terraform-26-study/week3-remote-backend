# Week3 정답 코드

`practice/`의 TODO를 채운 결과입니다. 막혔을 때 대조용으로 보세요.

1. `bootstrap/`을 먼저 apply하고 `terraform output -raw backend_config`로 다섯 줄을 확인합니다. 리소스 5개입니다.
2. `app/`을 **먼저 로컬 state로** apply합니다. 리소스 7개입니다.
3. `app/backend.tf`의 bucket과 dynamodb_table을 1의 output 값으로 바꾸고 `terraform init -migrate-state`로 옮깁니다. 이어서 `plan`이 `No changes.`여야 합니다.
4. app만 destroy합니다. bootstrap의 S3·DynamoDB는 7주차에 지웁니다. 절차는 `lecture/실습워크북.md` C-5.

> [!NOTE]
> `app/backend.tf`는 이미 채워진 상태로 두었습니다. 실습에서는 이 파일이 주석으로 시작하고 B-4에서 주석을 풉니다. 로컬 state를 먼저 만들어야 `-migrate-state`가 옮길 것이 생기기 때문입니다.
