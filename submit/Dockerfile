FROM centos:centos6

# Yum installed dependencies
RUN mkdir /builddir
WORKDIR /builddir

RUN yum update -y && \
  yum install -y epel-release && \
  yum groupinstall -y development && \
  yum install -y zlib-dev openssl-devel sqlite-devel bzip2-devel && \
  yum install -y \
  logrotate \
  nginx \
  openldap-devel \
  openssh-server \
  wget \
  xz-libs 

# Install python 2.7.6 to /usr/local/bin and symlink to /usr/local/bin/python
RUN wget http://www.python.org/ftp/python/2.7.6/Python-2.7.6.tar.xz && \
  xz -d Python-2.7.6.tar.xz && \
  tar -xvf Python-2.7.6.tar && \
  cd Python-2.7.6 && \
  ./configure --prefix=/usr/local && \
  make && make altinstall && \
  wget --no-check-certificate https://pypi.python.org/packages/source/s/setuptools/setuptools-1.4.2.tar.gz && \
  tar -xvf setuptools-1.4.2.tar.gz && \
  cd setuptools-1.4.2 && \
  curl https://bootstrap.pypa.io/get-pip.py | python2.7 - && \
  pip install virtualenv && \
  ln -s /usr/local/bin/python2.7 /usr/local/bin/python && \
  pip install setuptools && \
  pip install pika && \
  pip install docopt 

RUN echo "Cleaning up from python build" && rm -rf /builddir

# Create the submit cs user
RUN adduser submit

# TODO: relocate all of these directories to a safe single location used by all docker things
RUN mkdir -p /docker /docker/files
WORKDIR /docker
COPY build_scripts /docker/build_scripts
COPY runtime_scripts /docker/runtime_scripts 
COPY files/* submit-cs-build.sh submit-cs-startup.sh /docker/files/

RUN chmod -R 755 /docker

# NGINX configuration
COPY files/nginx.conf /etc/nginx/nginx.conf
RUN chown root:root /etc/nginx/nginx.conf

# Fetch all of the pip modules and such and such
RUN /docker/files/submit-cs-build.sh
