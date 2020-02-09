	#application load balancers on public subnet group

resource "aws_alb" "public" {
	name            = "alb-pub-${var.namespace}"
	internal        = false
	security_groups = [aws_security_group.primary.id]
	subnets         = "${aws_subnet.public.*.id}"
}

resource "aws_alb" "private" {
	name            = "alb-priv-${var.namespace}"
	internal        = "true"
	security_groups = [aws_security_group.primary.id]
	subnets         = "${aws_subnet.private.*.id}"
}

	#alb target groups with health checks

resource "aws_alb_target_group" "public" {
	name        = "alb-target-public-${var.namespace}"
	port        = "${var.app_port}"
	protocol    = "${var.app_protocol}"
	vpc_id      = aws_vpc.default.id
	target_type = "ip"
  
	health_check {
		healthy_threshold   = "3"
		interval            = "30"
		protocol            = "${var.app_protocol}"
		port                = "${var.app_port}"
		matcher             = "${var.alb_matcher}"
		timeout             = "3"
		path                = "/"
		unhealthy_threshold = "2"
	}

	tags = {
		name   = "alb-target-public-${var.namespace}"
		deploy = "terraform"
	}
}

resource "aws_alb_target_group" "private" {
	name        = "alb-target-private-${var.namespace}"
	port        = "${var.app_port}"
	protocol    = "${var.app_protocol}"
	vpc_id      = aws_vpc.default.id
	target_type = "ip"
  
	health_check {
		healthy_threshold   = "3"
		interval            = "30"
		protocol            = "${var.app_protocol}"
		port                = "${var.app_port}"
		matcher             = "${var.alb_matcher}"
		timeout             = "3"
		path                = "/"
		unhealthy_threshold = "2"
	}

	tags = {
		name   = "alb-target-private-${var.namespace}"
		deploy = "terraform"
	}
}

	#self-signed cert chain for internal app connectivity

resource "aws_iam_server_certificate" "private" {
	name             = "iam_cert_private_${var.namespace}"
	certificate_body = "${file("${path.module}/docker/kolide.cert")}"
	private_key      = "${file("${path.module}/docker/kolide.key")}"
}

	#alb forwarding listeners with SSL termination and public acm cert

resource "aws_alb_listener" "public" {
	load_balancer_arn = "${aws_alb.public.id}"
	port              = "${var.app_port}"
	protocol          = "${var.app_protocol}"
	ssl_policy        = "${var.alb_ssl_policy}"
	#certificate_arn   = "${aws_iam_server_certificate.public.arn}"
	certificate_arn   = "${var.alb_cert}"
	

	default_action {
		target_group_arn = "${aws_alb_target_group.public.id}"
		type             = "forward"
	}
}

resource "aws_alb_listener" "private" {
	load_balancer_arn = "${aws_alb.private.id}"
	port              = "${var.app_port}"
	protocol          = "${var.app_protocol}"
	ssl_policy        = "${var.alb_ssl_policy}"
	certificate_arn   = "${aws_iam_server_certificate.private.arn}"

	default_action {
		target_group_arn = "${aws_alb_target_group.private.id}"
		type             = "forward"
	}
}

	#route53 records in private zone for app connectivity

resource "aws_route53_record" "private" {

	depends_on = [
		aws_elasticache_replication_group.default
	]

	zone_id = "${aws_route53_zone.default.zone_id}"
	name    = "app.${var.namespace}.priv"
	type    = "CNAME"
	ttl     = "300"
	records = ["${aws_alb.private.dns_name}"]
}

	#route53 record in public zone for app connectivity


resource "aws_route53_record" "public" {

	depends_on = [
		aws_elasticache_replication_group.default
	]

	zone_id = "${var.pub_dns_id}"
	name    = "${var.namespace}.${var.pub_dns_name}"
	type    = "CNAME"
	ttl     = "300"
	records = ["${aws_alb.public.dns_name}"]
}
