#!/bin/bash
sudo yum install -y docker
sudo chkconfig docker on
sudo service docker start
sudo docker login -u $hub_username -p $hub_password
sudo docker build -t senthilrajar/bahmni_centos:${rpm_version} --build-arg rpm_version=${rpm_version} .
sudo docker run -it -d -p 8080:80 -p 9090:443 -p 3306:3306 -p 5432:5432 -p 8050:8050 -p 8069:8069 -p 8052:8052 --privileged --name $container_name senthilrajar/bahmni_centos:${rpm_version} /bin/bash
