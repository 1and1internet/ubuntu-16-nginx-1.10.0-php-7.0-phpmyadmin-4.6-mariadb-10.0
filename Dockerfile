FROM 1and1internet/ubuntu-16-nginx-php-phpmyadmin:latest
MAINTAINER Brian Wojtczak <brian.wojtczak@1and1.co.uk>
ARG DEBIAN_FRONTEND=noninteractive

COPY files/ /

RUN \
  groupadd mysql && \
  useradd -g mysql mysql && \
  apt-get update && \
  apt-get install -y gettext-base mariadb-server && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/lib/mysql && \
  mkdir --mode=0777 /var/lib/mysql /var/run/mysqld && \
  chown mysql:mysql /var/lib/mysql && \
#  sed -r -i -e 's/^bind-address\s+=\s+127\.0\.0\.1$/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf && \
#  sed -r -i -e 's/^user\s+=\s+mysql$/#user = mysql/' /etc/mysql/mariadb.conf.d/50-server.cnf && \
#  sed -i -r -e 's/^#general_log_file\s+=.*/general_log_file=\/var\/log\/mysql\/mysql.log/g' /etc/mysql/mariadb.conf.d/50-server.cnf && \
#  sed -i -r -e '/^query_cache/d' /etc/mysql/mariadb.conf.d/50-server.cnf && \
  printf '[mysqld]\nskip-name-resolve\n' > /etc/mysql/conf.d/skip-name-resolve.cnf && \
  chmod 777 /docker-entrypoint-initdb.d && \
  chmod 0777 -R /var/lib/mysql /var/log/mysql && \
  chmod 0775 -R /etc/mysql && \
  chmod 0755 -R /hooks && \
  cd /opt/configurability/src/mariadb_config_translator && \
  pip --no-cache install --upgrade pip && \
  pip --no-cache install --upgrade .

ENV MYSQL_ROOT_PASSWORD=ReplaceWithENVFromBuild \
    DISABLE_PHPMYADMIN=0 \
    PMA_ARBITRARY=0 \
    PMA_HOST=localhost \
    MYSQL_GENERAL_LOG=0 \
    MYSQL_QUERY_CACHE_TYPE=1 \
    MYSQL_QUERY_CACHE_SIZE=16M \
    MYSQL_QUERY_CACHE_LIMIT=1M

EXPOSE 3306 8080
VOLUME /var/lib/mysql/
