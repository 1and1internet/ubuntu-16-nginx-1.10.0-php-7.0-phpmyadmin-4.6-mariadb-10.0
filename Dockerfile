FROM 1and1internet/ubuntu-16-nginx-1.10.0-php-7.0-phpmyadmin-4.6:unstable
ARG DEBIAN_FRONTEND=noninteractive
MAINTAINER James Eckersall <james.eckersall@fasthosts.com>

COPY files/ /

ENV MYSQL_ROOT_PASSWORD=ReplaceWithENVFromBuild \
    DISABLE_PHPMYADMIN=0 \
    PMA_ARBITRARY=0 \
    PMA_HOST=localhost

RUN \
  groupadd mysql && \
  useradd -g mysql mysql && \
  apt-get update && \
  apt-get install -y mariadb-server && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/lib/mysql && \
  mkdir --mode=0777 /var/lib/mysql /var/run/mysqld

RUN /fix-permissions.sh /var/lib/mysql/ && \
    /fix-permissions.sh /var/log && \
    /fix-permissions.sh /var/run/ && \
    chown mysql:0 /var/lib/mysql && \
    sed -r -i -e 's/^bind-address\s+=\s+127\.0\.0\.1$/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

EXPOSE 3306 8080
#USER 1000
