	#standard ecs cluster

resource "aws_ecs_cluster" "default" {
  name = "ecs-clust-${var.namespace}"
}

	#continer task definition

resource "aws_ecs_task_definition" "default" {
	family                   = "${var.namespace}"
	network_mode             = "${var.ecs_netmode}"
	requires_compatibilities = ["${var.ecs_launch}"]
	cpu                      = "${var.ecs_cpu}"
	memory                   = "${var.ecs_mem}"
	execution_role_arn       = "${var.ecs_role}"

	container_definitions = <<DEFINITION
[
  {
    "image": "${var.ecs_image}",
	"cpu": ${var.ecs_cpu},
    "memory": ${var.ecs_mem},
    "name": "${var.namespace}",
    "networkMode": "${var.ecs_netmode}",
    "portMappings": [
      {
        "containerPort": ${var.app_port},
        "hostPort": ${var.app_port}
      }
    ]
  }
]
DEFINITION
}

	#ecs service with fargate launch, public subnet group, load balancer association

resource "aws_ecs_service" "default" {

	depends_on = [
		aws_route53_record.elastic,
		aws_route53_record.rds,
		aws_alb.public,
		aws_alb.private,
		aws_alb_target_group.public,
		aws_alb_target_group.private,
		aws_alb_listener.public,
		aws_alb_listener.private,
	]

	name            = "ecs-svc-${var.namespace}"
	cluster         = aws_ecs_cluster.default.id
	task_definition = aws_ecs_task_definition.default.arn
	desired_count   = "${var.az_count}"
	launch_type     = "${var.ecs_launch}"

	network_configuration {
		assign_public_ip = true
    
		security_groups  = [
			aws_security_group.primary.id,
		]
	
		subnets = "${aws_subnet.public.*.id}"

	}
  
    load_balancer {
		target_group_arn = "${aws_alb_target_group.public.id}"
		container_name   = "${var.namespace}"
		container_port   = "${var.app_port}"
	}
	
	load_balancer {
		target_group_arn = "${aws_alb_target_group.private.id}"
		container_name   = "${var.namespace}"
		container_port   = "${var.app_port}"
	}
  
}