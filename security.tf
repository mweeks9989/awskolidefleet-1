	#security groups - defenitely needs attention

resource "aws_security_group" "primary" {
	name    = "sec-${var.namespace}"
	vpc_id  = "${aws_vpc.default.id}"
  
	ingress {
		from_port   = 22
		to_port     = 22
		protocol    = "tcp"
		cidr_blocks = [
			"${var.home_ip}",
			"${var.work_ip}",
			"${var.vpc_cidr_block}"
		]
	}

	ingress {
		from_port   = "${var.app_port}"
		to_port     = "${var.app_port}"
		protocol    = "tcp"
		cidr_blocks = [
			"${var.home_ip}",
			"${var.work_ip}",
			"${var.vpc_cidr_block}"
		]
	}
  
	ingress {
		from_port   = 443
		to_port     = 443
		protocol    = "tcp"
		cidr_blocks = ["${var.vpc_cidr_block}"]
	}
  
	ingress {
		from_port   = 3306
		to_port     = 3306
		protocol    = "tcp"
		cidr_blocks = ["${var.vpc_cidr_block}"]
	}	
  
	ingress {
		from_port   = 6379
		to_port     = 6379
		protocol    = "tcp"
		cidr_blocks = ["${var.vpc_cidr_block}"]
	}
  
	ingress {
		from_port   = 8
		to_port     = 0
		protocol    = "icmp"
		cidr_blocks = ["${var.vpc_cidr_block}"]
	}

	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
  
	tags = {
		name   = "sec-${var.namespace}"
		deploy = "terraform"
	}
}

	#sg to limit traffic to ecs from alb only - not in use

resource "aws_security_group" "ecs" {
	name        = "sc-ecs-${var.namespace}"
	description = "allow inbound access from the ALB only"
	vpc_id      = "${aws_vpc.default.id}"

	ingress {
		protocol        = "tcp"
		from_port       = "${var.app_port}"
		to_port         = "${var.app_port}"
		security_groups = ["${aws_security_group.primary.id}"]
	}

	egress {
		protocol    = "-1"
		from_port   = 0
		to_port     = 0
		cidr_blocks = ["0.0.0.0/0"]
	}
}