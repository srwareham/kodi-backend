#!/usr/bin/env bash

service mysql start
# Wait until service has actually started before attempting to provision kodi user
null=$(mysqladmin -u root "-p"$PASSWORD status)
status=$(echo $?)
while [ $status -ne 0 ]; do
  null=$(mysqladmin -u root "-p"$PASSWORD status)
  status=$(echo $?)
done
echo "Ignore the error: ERROR 2002 (HY000): Can't connect to local MySQL server through socket /var/run/mysqld/mysqld.sock (2)"
mysql -u root "-p"$PASSWORD < "/create_kodi.sql" && service mysql stop
