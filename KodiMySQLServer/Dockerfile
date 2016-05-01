# Dockerfile to start a mysql server to host a kodi library. Note docker run *MUST* be run with ports exposed.

# Example build
# docker build -t kodi-mysql-server .

# Example debug run with an interactive terminal
# docker run --rm -it -p 3306:3306 kodi-mysql-server

# Example run to start the container / service as daemon
# docker run -d --name kodi-mysql-server -p 3306:3306 kodi-mysql-server


FROM ubuntu

MAINTAINER srwareham

# Expose is mostly for documentation purposes, still need to bind to host (e.g., using docker run -p 3306:3306)
EXPOSE 3306

# The root password for mysql-server
ENV PASSWORD=password

# Prepopulate the response field that pops up while installing mysql-server
# Note: do not reformat this, the space between password and $PASSWORD *must* be inside the quotes
RUN echo "mysql-server mysql-server/root_password password "$PASSWORD| debconf-set-selections && echo "mysql-server mysql-server/root_password_again password "$PASSWORD| debconf-set-selections

RUN apt-get update && apt-get -y install mysql-server
# Add mysql config file (only update is that conenctions from any IP address will be accepted instead of just 127.0.0.1 (localhost)
ADD my.cnf /etc/mysql/
# The sql file used to provision the kodi user. This creates the username and password required by advancedsettings.xml to connect to this mysql database
# Default values are:
#   username: kodi
#   password: kodi
ADD create_kodi.sql /create_kodi.sql
# The bash script which starts the service in the background, calls the above to provision the kodi user, then stops the service so that it can be run in foreground mode
ADD configure_mysql.sh /configure_mysql.sh
RUN /configure_mysql.sh

# Run mysql-server in foreground as necessitated by docker
ENTRYPOINT ["mysqld_safe"]
