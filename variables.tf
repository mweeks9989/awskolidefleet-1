	#namespace

variable "namespace" {
	description = "default namespace"
	default     = "fleet"
}

	#region

variable "region" {
	description = "default region"
	default     = "add your region"
}


	#personal security allowance

variable "home_ip" {
	description = "allow access from my home ip"
	default     = ""
}

variable "work_ip" {
	description = "allow access from my work ip"
	default     = ""
}

	#networking
	
variable "az_count" {
	description = "number of az to use"
	default     = "3"
}

variable "vpc_cidr_block" {
	description = "cidr block used for vpc"
	default     = "192.168.0.0/16"
}
	
variable "vpc_cidr_net" {
	description = "for interpolation, probably a better way to do this"
	default     = "192.168"
}

variable "vpc_cidr_host" {
	description = "for interpolation, probably a better way to do this"
	default     = "0.0/16"
}

	#rds
	
variable "rds_skipsnap" {
	description = "dev only - skip final snapshot to allow rapid destroy"
	default     = "true"
}

variable "rds_instance_class" {
	description = "rds instance size" 
	default     = "db.t2.small"
}

variable "rds_engine" {
	description = "rds database engine" 
	default     = "aurora-mysql"
}

variable "rds_engine_ver" {
	description = "database engine"
	default     = "5.7.mysql_aurora.2.03.2" 
}

variable "rds_parameters" {
	description = "database parameter group" 
	default     = "default.mysql5.7"
}

variable "rds_user" {
	description = "database username" 
	default     = "root"
}

variable "rds_pass" {
	description = "database username" 
	default     = "pleaseH1DEme!"
}

variable "rds_dbname" {
	description = "database name" 
	default     = "kolide"
}

	#elasticache

variable "elc_port" {
	description = "elastic port" 
	default     = "6379"
}

variable "elc_desc" {
	description = "elastic rep group description" 
	default     = "redis cluster"
}

variable "elc_node_type" {
	description = "elastic instance size" 
	default     = "cache.t2.micro"
}

variable "elc_params" {
	description = "elastic parameter set" 
	default     = "default.redis5.0.cluster.on"
}

variable "elc_snaps" {
	description = "snapshots to retain" 
	default     = "2"
}

variable "elc_snap_window" {
	description = "snapshots to retain" 
	default     = "00:00-05:00"
}
 
variable "elc_nodes" {
	description = "replicas per node group" 
	default     = "1"
}

	#application

variable "app_port" {
	description = "application port" 
	default     = "8080"
}

variable "app_protocol" {
	description = "application protocol" 
	default     = "HTTPS"
}

	#alb
	
variable "alb_cert" {
	description = "acm cert for ssl term"
	default     = "arn of pre-provisioned acm cert here"
}

variable "pub_dns_id" {
	description = "public dns zone id"
	default     = "Z3309BH451Z7QT"
}

variable "pub_dns_name" {
	description = "dns zone namespace"
	default     = "public dns fqdn here"
}
	
variable "alb_matcher" {
	description = "healthy response code match"
	default     = "200-399"
}

variable "alb_ssl_policy" {
	description = "ssl negotiation policy"
	default     = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
}

	#ecs

variable "ecs_role" {
	description = 
	default     = "add ur own arm"
}
	
variable "ecs_image" {
	description = "docker image"
	default     = "arn of docker image here"
}

variable "ecs_netmode" {
	description = "container network mode"
	default     = "awsvpc"
}

variable "ecs_launch" {
	description = "ecs launch type"
	default     = "FARGATE"
}

variable "ecs_cpu" {
	description = "container cpu"
	default     = "256"
}

variable "ecs_mem" {
	description = "container mem"
	default     = "512"
}

