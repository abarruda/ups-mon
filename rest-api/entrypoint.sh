#! /bin/sh -e

# This seems to establish a connection with the nut server
upsc -l

cd  /usr/local/tomcat
catalina.sh run
