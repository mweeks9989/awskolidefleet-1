	#elasticache subnet group
	
resource "aws_elasticache_subnet_group" "default" {

	name = "elc-${var.namespace}" 
	subnet_ids = "${aws_subnet.private.*.id}"
}

	#elasticache replication group
	
resource "aws_elasticache_replication_group" "default" {
  
	depends_on = [
		aws_elasticache_subnet_group.default
	]

	replication_group_id          = "elc-rep-${var.namespace}"
	replication_group_description = "${var.elc_desc}"
	node_type                     = "${var.elc_node_type}"
	port                          = "${var.elc_port}"
	parameter_group_name          = "${var.elc_params}"
	automatic_failover_enabled    = true
	snapshot_retention_limit      = "${var.elc_snaps}"
	snapshot_window               = "${var.elc_snap_window}"
	subnet_group_name             = "elc-${var.namespace}"
	security_group_ids            = [aws_security_group.primary.id]
  
	cluster_mode {
		replicas_per_node_group  = "${var.elc_nodes}"
		num_node_groups          = "${var.az_count}"
	}
  
	tags = {
		name   = "elc-rep-${var.namespace}"
		deploy = "terraform"
	}
}

	#route53 record in private zone for container connectivity

resource "aws_route53_record" "elastic" {

	depends_on = [
		aws_elasticache_replication_group.default
	]

	zone_id = "${aws_route53_zone.default.zone_id}"
	name    = "ec.${var.namespace}.priv"
	type    = "CNAME"
	ttl     = "300"
	records = ["${aws_elasticache_replication_group.default.configuration_endpoint_address}"]
}