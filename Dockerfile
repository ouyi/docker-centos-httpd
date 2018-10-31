FROM centos:7
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*; \
rm -f /etc/systemd/system/*.wants/*; \
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*; \
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]
RUN yum -y install epel-release && yum clean all
RUN yum -y install httpd mod_ssl lsof tree && yum clean all && systemctl enable httpd.service
RUN mkdir /etc/ssl/private && chmod 700 /etc/ssl/private && \
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/selfsigned.key -out /etc/ssl/certs/selfsigned.crt -subj '/CN=localhost' && \
openssl dhparam -dsaparam -out /etc/ssl/certs/dhparam.pem 2048 && \
cat /etc/ssl/certs/selfsigned.crt /etc/ssl/certs/dhparam.pem > /etc/ssl/certs/selfsigned-combined.crt
COPY config/ssl.conf /etc/httpd/conf.d/ssl.conf
COPY config/non-ssl.conf /etc/httpd/conf.d/non-ssl.conf
COPY config/index.html /var/www/html/index.html
EXPOSE 80 8080 443 8443
CMD ["/usr/sbin/init"]
