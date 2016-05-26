FROM 1and1internet/ubuntu-16-nginx-1.10.0-php-7.0-phpmyadmin-4.6:unstable
MAINTAINER James Eckersall <james.eckersall@fasthosts.com>
ARG DEBIAN_FRONTEND=noninteractive

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
  mkdir --mode=0777 /var/lib/mysql /var/run/mysqld && \
  chmod 777 /etc/mysql/debian.cnf

RUN \
    sed -r -i -e 's/^bind-address\s+=\s+127\.0\.0\.1$/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf && \
    sed -r -i -e 's/^user\s+=\s+mysql$/#user = mysql/' /etc/mysql/mariadb.conf.d/50-server.cnf && \
    chmod 777 /var/lib/mysql && \
    chmod 777 -R /var/log/mysql && \
    chmod 755 /hooks/entrypoint-pre.d/50_phpmyadmin_setup /hooks/supervisord-pre.d/50_mariadb_setup && \
    chmod 777 /docker-entrypoint-initdb.d && \
    chmod 755 /hooks

EXPOSE 3306 8080
