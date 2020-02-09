output "elc_endpoint" {
	value = "${aws_elasticache_replication_group.default.configuration_endpoint_address}"
}

output "elc_dns" {
	value = "ec.${var.namespace}.priv"
}

output "rds_endpoint" {
	value = "${aws_rds_cluster.default.endpoint}"
}

output "rds_dns" {
	value = "db.${var.namespace}.priv"
}

output "alb_public_endpoint" {
	value = "${aws_alb.public.dns_name}"
}

output "alb_private_endpoint" {
	value = "${aws_alb.private.dns_name}"
}

output "alb_private_dns" {
	value = "app.${var.namespace}.priv"
}

output "alb_pub_dns" {
	value = "https://${var.namespace}.${var.pub_dns_name}:${var.app_port}"
}

output "instance_pub_dns" {
	value = "${aws_instance.default.public_dns}"
}

output "instance_pub_ip" {
	value = "${aws_instance.default.public_ip}"
}

output "instance_connect" {
	value = "ssh -i AWSkey2.pem ec2-user@${aws_instance.default.public_dns}"
}






