# 자격증명은 여기 넣지 않습니다. aws configure / 환경변수로만 주입.
provider "aws" {
  region = var.region

  # 이 스택이 만드는 모든 리소스에 자동으로 붙는 태그입니다.
  # Purpose = workload 로 표시해 두면 scripts/check-leftover.sh 가
  # "오늘 지워야 하는 것(workload)"과 "7주차까지 남겨둘 것(terraform-state)"을
  # 태그로 갈라냅니다. 실습워크북 C-3.
  default_tags {
    tags = {
      Project   = var.project_name
      Study     = "boaz-terraform-26"
      Week      = "3"
      ManagedBy = "terraform"
      Purpose   = "workload"
    }
  }
}
