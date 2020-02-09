resource "aws_instance" "default" {
  ami                    = "ami-0dacb0c129b49f529"
  instance_type          = "t2.micro"
  key_name               = "AWSKey2"
  vpc_security_group_ids = [aws_security_group.primary.id]
  subnet_id              = aws_subnet.public.0.id
  
  depends_on = [
	aws_ecs_service.default
  ]
  
  tags = {
    Name   = "ec2-${var.namespace}"
	Deploy = "terraform"
  }
 
  user_data = <<-EOF
#!/bin/bash
yum update -y && yum upgrade -y
yum install wget unzip -y
curl -L https://pkg.osquery.io/rpm/GPG | sudo tee /etc/pki/rpm-gpg/RPM-GPG-KEY-osquery
yum-config-manager --add-repo https://pkg.osquery.io/rpm/osquery-s3-rpm.repo
yum-config-manager --enable osquery-s3-rpm
yum install osquery -y
cp /usr/share/osquery/osquery.example.conf /etc/osquery/osquery.conf
echo '[Unit]' >> /etc/systemd/system/osqueryd.service
echo 'Description=osquery' >> /etc/systemd/system/osqueryd.service
echo 'After=network.target' >> /etc/systemd/system/osqueryd.service
echo '' >> /etc/systemd/system/osqueryd.service
echo '[Service]' >> /etc/systemd/system/osqueryd.service
echo 'LimitNOFILE=8192' >> /etc/systemd/system/osqueryd.service
echo 'ExecStart=/bin/osqueryd \' >> /etc/systemd/system/osqueryd.service
echo '	--enroll_secret_path=/etc/osquery/enroll \' >> /etc/systemd/system/osqueryd.service
echo '	--tls_server_certs=/etc/osquery/kolide.pem \' >> /etc/systemd/system/osqueryd.service
echo '	--tls_hostname=app.fleet.priv:8080 \' >> /etc/systemd/system/osqueryd.service
echo '	--host_identifier=uuid \' >> /etc/systemd/system/osqueryd.service
echo '	--enroll_tls_endpoint=/api/v1/osquery/enroll \' >> /etc/systemd/system/osqueryd.service
echo '	--config_plugin=tls \' >> /etc/systemd/system/osqueryd.service
echo '	--config_tls_endpoint=/api/v1/osquery/config \' >> /etc/systemd/system/osqueryd.service
echo '	--config_refresh=10 \' >> /etc/systemd/system/osqueryd.service
echo '	--disable_distributed=false \' >> /etc/systemd/system/osqueryd.service
echo '	--distributed_plugin=tls \' >> /etc/systemd/system/osqueryd.service
echo '	--distributed_interval=10 \' >> /etc/systemd/system/osqueryd.service
echo '	--distributed_tls_max_attempts=3 \' >> /etc/systemd/system/osqueryd.service
echo '	--distributed_tls_read_endpoint=/api/v1/osquery/distributed/read \' >> /etc/systemd/system/osqueryd.service
echo '	--distributed_tls_write_endpoint=/api/v1/osquery/distributed/write \' >> /etc/systemd/system/osqueryd.service
echo '	--logger_plugin=tls \' >> /etc/systemd/system/osqueryd.service
echo '	--logger_tls_endpoint=/api/v1/osquery/log \' >> /etc/systemd/system/osqueryd.service
echo '	--logger_tls_period=10' >> /etc/systemd/system/osqueryd.service
echo '' >> /etc/systemd/system/osqueryd.service
echo '[Install]' >> /etc/systemd/system/osqueryd.service
echo '' >> /etc/systemd/system/osqueryd.service
echo 'WantedBy=multi-user.target' >> /etc/systemd/system/osqueryd.service
              EOF
}