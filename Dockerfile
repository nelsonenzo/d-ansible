#Latest Ubuntu LTS
FROM ubuntu:14.04
MAINTAINER Nelson Hernandez <nelsonh@gmail.com>

RUN apt-get -y update && \
    apt-get install -y python-yaml python-jinja2 python-httplib2 python-keyczar python-paramiko python-setuptools python-pkg-resources git python-pip curl
RUN pip install boto

RUN apt-get install -y libpq-dev postgresql-client  python-dev libxml2-dev libxslt1-dev zlib1g-dev
RUN pip install psycopg2

RUN mkdir /etc/ansible/
RUN mkdir /opt/ansible/
RUN git clone http://github.com/ansible/ansible.git /opt/ansible/ansible
RUN cd /opt/ansible/ansible && git submodule update --init
WORKDIR /etc/ansible
ENV PATH /opt/ansible/ansible/bin:/bin:/usr/bin:/sbin:/usr/sbin
ENV PYTHONPATH /opt/ansible/ansible/lib
ENV ANSIBLE_LIBRARY /opt/ansible/ansible/library

