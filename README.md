# Dockerized httpd (Apache HTTP Server) on CentOS 7

## Development notes

### Use systemd in centos:7 containers

Based on [this documentation (section `Systemd integration`)](https://hub.docker.com/_/centos/) and [this post](https://developers.redhat.com/blog/2014/05/05/running-systemd-within-docker-container/).

### Self-signed certificates for TLS

Based on [this tutorial](https://www.digitalocean.com/community/tutorials/how-to-create-an-ssl-certificate-on-apache-for-centos-7).

## Usage

### Build the Docker image

```
docker build . -t docker-centos-httpd
```

### Start the Docker container

```
docker run -p 8080:80 -p 8443:443 -d --cap-add=SYS_ADMIN -v /sys/fs/cgroup:/sys/fs/cgroup:ro docker-centos-httpd
```

### Tests within the container

```
curl https://localhost/ # CA not trusted
curl --cacert /etc/ssl/certs/selfsigned.crt https://localhost/ # Shall work
curl localhost # Will be redirected
curl -L --cacert /etc/ssl/certs/selfsigned.crt http://localhost/ # Shall work
```
