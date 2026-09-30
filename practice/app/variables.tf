variable "region" {
  description = "리소스를 만들 리전 (스터디 공통: 서울)"
  type        = string
  default     = "ap-northeast-2"
}

variable "project_name" {
  description = "리소스 이름 접두어. bootstrap 스택과 반드시 같은 값을 쓴다"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{2,39}$", var.project_name))
    error_message = "project_name은 소문자·숫자·하이픈만, 3~40자여야 합니다. (예: boaz26-w3-kdh1834)"
  }
}

variable "my_ip" {
  description = "SSH를 허용할 본인 공인 IP. `curl -4 ifconfig.me` 결과. CIDR 아님, 순수 IP."
  type        = string

  # 코드에서 "${var.my_ip}/32" 로 조립하므로, 여기에 이미 /32 가 붙어 있으면
  # "1.2.3.4/32/32" 가 되어 아래 cidrnetmask() 가 실패한다.
  # 정규식보다 cidrnetmask() 가 낫다. "999.1.1.1" 같은 값도 거부한다.
  validation {
    condition     = can(cidrnetmask("${var.my_ip}/32"))
    error_message = "my_ip는 1.2.3.4 처럼 순수 IPv4여야 합니다. /32나 CIDR을 넣지 마세요. (curl -4 ifconfig.me)"
  }
}

variable "instance_type" {
  description = "EC2 인스턴스 타입. week2와 같은 t3.micro(x86_64)를 씁니다."
  type        = string
  default     = "t3.micro"

  # 실수로 큰 타입을 넣어 과금되는 것을 코드 단계에서 막습니다.
  validation {
    condition     = contains(["t3.micro", "t2.micro"], var.instance_type)
    error_message = "이번 실습은 t3.micro 또는 t2.micro 만 허용합니다 (과금 방지). t3.micro 는 서울 리전에서 시간당 $0.0130 이 과금되니, 프리티어를 믿지 말고 세션 끝에 반드시 destroy 하세요."
  }
}
