FROM senthilrajar/bahmni_centos
ARG rpm_version
RUN echo -e "[bahmni] \nname=Bahmni development repository for RHEL/CentOS 6\nbaseurl=http://repo.mybahmni.org.s3-website-ap-southeast-1.amazonaws.com/rpm/bahmni/\nenabled=1\ngpgcheck=0\n" > /etc/yum.repos.d/bahmni.repo
RUN yum install -y sudo openssh-server openssh-clients tar wget yum-plugin-ovl  ; yum clean all
RUN echo $rpm_version
RUN yum install -y bahmni-installer-$rpm_version* ; yum clean all
RUN yum install -y http://yum.postgresql.org/9.2/redhat/rhel-6-x86_64/pgdg-centos92-9.2-7.noarch.rpm
RUN yum install -y yum install -y ftp://195.220.108.108/linux/Mandriva/devel/cooker/x86_64/media/contrib/release/mx-1.4.5-1-mdv2012.0.x86_64.rpm
RUN echo -e "selinux_state: disabled \npostgres_version: 9.2 \ntimezone: Asia/Kolkata \nimplementation_name: default \nbahmni_support_group: bahmni_support \nbahmni_support_user: bahmni_support \nbahmni_password_hash: $1$IW4OvlrH$Kui/55oif8W3VZIrnX6jL1 \nbahmni_repo_url: http://repo.mybahmni.org/rpm/bahmni/ \nopenerp_url: localhost:8069" > /etc/bahmni-installer/setup.yml
RUN sed -i "1,100 s/^/#/" /opt/bahmni-installer/bahmni-playbooks/roles/iptables/tasks/main.yml
RUN sed -i "59,71 s/^/#/" /opt/bahmni-installer/bahmni-playbooks/roles/mysql/tasks/main.yml
RUN sed -i "65,77 s/^/#/" /opt/bahmni-installer/bahmni-playbooks/roles/postgres/tasks/main.yml
RUN sed -i "8,34 s/^/#/" /opt/bahmni-installer/bahmni-playbooks/roles/httpd/tasks/main.yml
RUN sed -i "115,125 s/^/#/" /opt/bahmni-installer/bahmni-playbooks/roles/bahmni-emr/tasks/main.yml
RUN sed -i "59,73 s/^/#/" /opt/bahmni-installer/bahmni-playbooks/roles/bahmni-erp/tasks/main.yml
RUN sed -i "28,42 s/^/#/" /opt/bahmni-installer/bahmni-playbooks/roles/bahmni-event-log-service/tasks/main.yml
RUN sed -i "79,93 s/^/#/" /opt/bahmni-installer/bahmni-playbooks/roles/bahmni-lab/tasks/main.yml
RUN sed -i "40,54 s/^/#/" /opt/bahmni-installer/bahmni-playbooks/roles/bahmni-reports/tasks/main.yml
RUN sed -i "12,29 s/^/#/" /opt/bahmni-installer/bahmni-playbooks/roles/dcm4chee/tasks/main.yml
RUN sed -i "20,34 s/^/#/" /opt/bahmni-installer/bahmni-playbooks/roles/nagios/tasks/main.yml
RUN sed -i "54,68 s/^/#/" /opt/bahmni-installer/bahmni-playbooks/roles/pacs-integration/tasks/main.yml
RUN sed -i "15,29 s/^/#/" /opt/bahmni-installer/bahmni-playbooks/roles/atomfeed-console/tasks/main.yml
RUN sed -i "31,46 s/^/#/" /opt/bahmni-installer/bahmni-playbooks/roles/nagios-agent/tasks/main.yml
RUN bahmni -ilocal install
RUN rm -rf /var/run/openerp/openerp-server.pid
ENTRYPOINT service mysqld start && service postgresql-9.2 start && bahmni -ilocal start && service bahmni-lab restart && /bin/bash
# Apache
EXPOSE 443
# OpenMRS
EXPOSE 8050
# OpenERP
EXPOSE 8069
#OpenELIS
EXPOSE 8052
# MySQL
EXPOSE 3306
# Postgresql
EXPOSE 5432
