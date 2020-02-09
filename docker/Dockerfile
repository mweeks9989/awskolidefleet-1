FROM centos:7
MAINTAINER <your_name>

RUN cp /etc/localtime /root/old.timezone && \
	rm -f /etc/localtime && \
	ln -s /usr/share/zoneinfo/America/Chicago /etc/localtime

RUN	yum -y --exclude=systemd* --setopt=tsflags=nodocs update && \
	yum -y --exclude=systemd* --setopt=tsflags=nodocs upgrade && \
	yum -y --setopt=tsflags=nodocs install epel-release unzip wget && \
  	yum clean all

RUN	mkdir -p /opt/fleet/certs && \
	cd /opt/fleet && \
	wget -q https://github.com/kolide/fleet/releases/latest/download/fleet.zip && \
	unzip fleet.zip 'linux/*' && \
	rm -f ./fleet.zip && \
	cp ./linux/fleet* /usr/bin/
	
RUN yum -y remove unzip wget && \
  	yum clean all
	
RUN	rm -f /etc/yum.repos.d/*.rpm
RUN rm -fr /var/cache/*
	
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done) && \
	rm -f /lib/systemd/system/multi-user.target.wants/* && \
	rm -f /etc/systemd/system/*.wants/* && \
	rm -f /lib/systemd/system/local-fs.target.wants/* && \
	rm -f /lib/systemd/system/sockets.target.wants/*udev* && \
	rm -f /lib/systemd/system/sockets.target.wants/*initctl* && \
	rm -f /lib/systemd/system/basic.target.wants/* && \
	rm -f /lib/systemd/system/anaconda.target.wants/*

ADD ./start.sh /usr/bin/
ADD ./kolide.key /opt/fleet/certs
ADD ./kolide.cert /opt/fleet/certs

RUN chmod 755 /usr/bin/start.sh && \
    chmod 755 /opt/fleet/certs/kolide.key && \
	chmod 755 /opt/fleet/certs/kolide.cert

EXPOSE 8080

WORKDIR /usr/bin/
CMD start.sh