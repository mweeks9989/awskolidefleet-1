# Kolide Fleet for OSQuery Management on AWS ECS Fargate, Aruora RDS and Redis Elasticache

## Usage
1. Bring your own aws account, supply creds via your method of choice, add your region "region" in varibles.tf.
2. Initialize ECS to create the proper iam ecs role (arn:aws:iam::<acnt_id>:role/ecsTaskExecutionRole)and add the arn to "ecs_role" under ecs.
3. Build and upload Docker image to ECR, put arn in variables.tf "ecs_image" under ecs.
4. Bring your own public r53 zone, put the zone id and fqdn in variables.tf "pub_dns_name" and "pub_dns_id" under alb.
5. Bring your own ACM cert fleet.<yourdnszone.fqdn> for your public r53 zone, put cert arn in variables.tf "alb_cert" under alb.
6. Self-signed cert chain provided in pem format for the internal ABL for client connectivity, app.fleet.priv signed by ca.fleet.priv. Certs exist in docker and cert dirs, better method inc.
7. Once build, SSH to instance described in the Output info.
8. Create /etc/osquery/enroll with the enroll_secret found in Fleet console and /etc/osquery/kolide.pem using the kolide.cert from the project or download it from Fleet app. Run systemctl restart osqueryd.
9. Setup your own S3/Dynamo DB backend. Not required, but strongly suggested.  This is not fun to manually destroy if you lose your state.
10. I'm a noob and this is a only a proof of concept.
11. ???????
12. Get rich or die tryin.

## Infrastructure
1. Multi-AZ capable via az_count variable, public / private subnets and routes with NAT/IGW support.
2. External ALB with verifiable ACM cert and internal ALB with self-signed cert chain (this works somehow!!??).
2. Aurora RDS cluster with multi-az support.
3. Redis Elasticache cluster with multi-az for node groups with relicas.
4. ECS Fargate cluster with multi-az support running Fleet containers.
5. Instance to test connectivity.  

## License
1. Steal whatever you want and take all the credit (doesn't align well with step #12 above).