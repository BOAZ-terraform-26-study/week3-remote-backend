# 자격증명은 여기 넣지 않습니다. aws configure / 환경변수로만 주입.
provider "aws" {
  region  = var.region
  profile = "terraform"

  # 이 스택이 만드는 모든 리소스에 자동으로 붙는 태그입니다.
  # Purpose 로 state 저장소임을 표시해 둡니다. app 스택 리소스와 구분되어
  # scripts/check-leftover.sh 가 "지워야 할 것"과 "남겨둘 것"을 가려냅니다. 실습워크북 C-3.
  default_tags {
    tags = {
      Project   = var.project_name
      Study     = "boaz-terraform-26"
      Week      = "3"
      ManagedBy = "terraform"
      Purpose   = "terraform-state"
    }
  }
}
