# MariaDB 5 with phpMyAdmin on Ubuntu 16.04 LTS (Xenial Xerus)

This image provides a common MariaDB database server. The intent is for the data itself to be stored in persistent storage wihch is then mounted in to this image at `/var/lib/mysql`

## Updates

Please consult [the official Ubuntu site](https://www.ubuntu.com/info/release-end-of-life) for information on when this version of Ubuntu becomes end of life.

Please consult [the official MariaDB site](https://mariadb.org/about/maintenance-policy/) to know when this version of MariaDB becomes end of life. It is recommended that you move to a newer version of MariaDB once this version passed out of active support.

## Usage

Please note this image is explictly intended to be run as a non-privileged user. Ensure you specify a user id (UID) other than zero when you run it. Running as root will not function.


```bash
UID=999
DB_PORT=3306
WEB_ADMIN_PORT=80
DB_ROOT="/my/local/path/"

docker run -u ${UID}:0 -p ${DB_PORT}:3306 -p ${WEB_ADMIN_PORT}:8080 -v ${DATABASE_ROOT}:/var/lib/mysql/ 1and1internet/ubuntu-16-nginx-php-phpmyadmin-mariadb-10
```

## Environment Variables

This image honours the following environment variables.

 * ``MYSQL_ROOT_PASSWORD`` - Cause an admin user called 'root' to be created with the specified password.

 * ``MYSQL_RANDOM_ROOT_PASSWORD`` - Cause an admin user called 'root' to be created with a random password. Overrides any password specified in MYSQL_ROOT_PASSWORD.

 * ``MYSQL_ALLOW_EMPTY_PASSWORD`` - Cause an admin user called 'root' to be created even if no password is being set.

 * ``MYSQL_ADMIN_USER`` - Creates an admin user named after the value of this variable.

 * ``MYSQL_ADMIN_PASSWORD`` - Specifies the password for the admin user created by specifying MYSQL_ADMIN_USER. Does nothing if MYSQL_ADMIN_USER is not specified.

 * ``MYSQL_RANDOM_ADMIN_PASSWORD`` - Causes a random password to be set for the admin user created by specifying MYSQL_ADMIN_USER. Overrides any password specified in MYSQL_ADMIN_PASSWORD. Does nothing if MYSQL_ADMIN_USER is not specified.

 * ``MYSQL_USER`` - Creates a standard (non-admin) user named after the value of this variable. Will be given full access to any database created using MYSQL_DATABASE. Does nothing if MYSQL_PASSWORD is not specified.

 * ``MYSQL_PASSWORD`` - Specifies the password for the standard user created by specifying MYSQL_USER. Does nothing if MYSQL_USER is not specified.

 * ``MYSQL_DATABASE`` - Causes a blank database to be created named after the value of this variable. Any standard user created with MYSQL_USER will be granted full access to this database.

## Building and testing

A simple Makefile is included for your convience. It assumes a linux environment with a docker socket available at `/var/run/docker.sock`

To build and test just run `make`.
You can also just `make pull`, `make build` and `make test` separately.

Please see the top of the Makefile for various variables which you may choose to customise. Variables may be passed as arguments, e.g. `make IMAGE_NAME=bob` or `make build BUILD_ARGS="--rm --no-cache"`

## Modifying the tests

The tests depend on shared testing code found in its own git repository called [drone-tests](https://github.com/1and1internet/drone-tests).

To use a different tests repository set the TESTS_REPO variable to the git URL for the alternative repository. e.g. `make TESTS_REPO=https://github.com/1and1internet/drone-tests.git`

To use a locally modified copy of the tests repository set the TESTS_LOCAL variable to the absolute path of where it is located. This variable will override the TESTS_REPO variable. e.g. `make TESTS_LOCAL=/tmp/github/1and1internet/drone-tests/`
