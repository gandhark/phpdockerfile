FROM ubuntu:latest

MAINTAINER Sukhada Sankpal<sukhadas@cybage.com>

ENV ANT_VERSION 1.9.6

RUN apt-get update -y --force-yes -qq

RUN apt-get install -y --force-yes python-software-properties wget software-properties-common

#---- ADDING PACKAGAES TO REPO

RUN add-apt-repository ppa:ondrej/php5

#RUN add-apt-repository ppa:ondrej/php5-5.6

RUN add-apt-repository ppa:webupd8team/java

#----- JAVA

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes openjdk-7-jre-headless php5

RUN apt-get update -y --force-yes -qq

#------ANT-----

RUN cd && \
    wget -q http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz && \
    tar -xzf apache-ant-${ANT_VERSION}-bin.tar.gz && \
    mv apache-ant-${ANT_VERSION} /opt/ant && \
    rm apache-ant-${ANT_VERSION}-bin.tar.gz

ENV ANT_HOME /opt/ant

ENV PATH ${PATH}:/opt/ant/bin

#---- GIT
RUN add-apt-repository ppa:git-core/ppa
RUN apt-get update -y --force-yes -qq
RUN apt-get install -y git-core


#---- Jenkins user
RUN adduser --quiet jenkins

RUN echo "jenkins:jenkins" | chpasswd

#---- Composer

COPY auth.json /root/.composer/
COPY auth.json /home/jenkins/.composer/
COPY auth.json /home/ajinkyab/.composer/
RUN chmod -R 755 /root/.composer/auth.json 


RUN apt-get install -y --force-yes -qq curl php5 php5-pgsql php5-cgi php5-cli php5-common php5-mysql php5-xdebug libapache2-mod-php5 php5-xsl mcrypt php5-mcrypt

RUN curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
#COPY composer.phar /usr/local/bin/composer
RUN apt-get -y install php5-xsl

ADD ./run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh
CMD ["/bin/sh","-e","/usr/bin/run.sh"]

