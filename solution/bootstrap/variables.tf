variable "region" {
  description = "리소스를 만들 리전 (스터디 공통: 서울)"
  type        = string
  default     = "ap-northeast-2"
}

variable "project_name" {
  description = "리소스 이름 접두어. boaz26-w3-{본인-github-id} 형식"
  type        = string

  # S3 버킷 이름이 "${var.project_name}-tfstate" 로 조립되므로,
  # 버킷 이름 규칙(소문자·숫자·하이픈)을 여기서 미리 막는다.
  # 대문자가 섞이면 apply 한복판에서 InvalidBucketName 으로 죽는다.
  # CHANGE-ME 를 그대로 두면 대문자 때문에 이 검사에 걸린다.
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{2,39}$", var.project_name))
    error_message = "project_name은 소문자·숫자·하이픈만, 3~40자여야 합니다. (예: boaz26-w3-kdh1834)"
  }
}
