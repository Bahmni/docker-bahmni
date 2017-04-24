#!/bin/bash
sudo yum install -y docker-io
sudo chkconfig docker on
sudo service docker start
docker build --build-arg  rpm_version=$rpm_version  -t senthilrajar/bahmni_centos:$rpmversion .
docker run -d -p 8080:80 -p 9090:443 -p 3306:3306 -p 5432:5432 -p 8050:8050 -p 8069:8069 -p 8052:8052 --name $container_name1 senthilrajar/bahmni_centos
docker run -d -p 8081:80 -p 9091:443 -p 3306:3306 -p 5432:5432 -p 8050:8050 -p 8069:8069 -p 8052:8052 --name $container_name2 senthilrajar/bahmni_centos
