	#rds cluster

resource "aws_rds_cluster" "default" {

	depends_on = [
		aws_db_subnet_group.default
	]

	cluster_identifier   = "rds-clust-${var.namespace}"
	database_name        = "${var.rds_dbname}"
	master_username      = "${var.rds_user}"
	master_password      = "${var.rds_pass}"
	db_subnet_group_name = "rds-sng-${var.namespace}"
	skip_final_snapshot  = "${var.rds_skipsnap}"
	engine               = "${var.rds_engine}"
	engine_version       = "${var.rds_engine_ver}"
  
	vpc_security_group_ids = [  
		aws_security_group.primary.id
	]

	tags = {
        name   = "rds-clust-${var.namespace}"
		deploy = "terraform"
    } 
}

	#rds instances on private subnet group

resource "aws_rds_cluster_instance" "default" {
	count                  = "${var.az_count}"
	identifier             = "rds-${var.namespace}-${count.index}"
	cluster_identifier     = "${aws_rds_cluster.default.id}"
	instance_class         = "${var.rds_instance_class}"
	db_subnet_group_name   = "rds-sng-${var.namespace}"
	engine                 = "${var.rds_engine}"
	engine_version         = "${var.rds_engine_ver}"
  
	tags = {
		name   = "rds-clust-${var.namespace}"
		deploy = "terraform"
    }
}

	#private subnet group for instance

resource "aws_db_subnet_group" "default" {
	name       = "rds-sng-${var.namespace}"
	subnet_ids = "${aws_subnet.private.*.id}"
}

	#route53 record in private zone for container connectivity

resource "aws_route53_record" "rds" {

	depends_on = [
		aws_rds_cluster.default
	]

	zone_id = "${aws_route53_zone.default.zone_id}"
	name    = "db.${var.namespace}.priv"
	type    = "CNAME"
	ttl     = "300"
	records = [
		"${aws_rds_cluster.default.endpoint}"
	]
}