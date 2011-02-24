#!/bin/bash

echo -e "Please enter your github.com username\n"
read USER

echo -e "Please enter your github.com password\n"
read PASS

echo "Updating apt cache"
aptitude update

echo "Installing required packages."
aptitude -y install curl git-core patch file \
  build-essential bison \
  openssl zlib1g-dev libssl-dev libreadline5-dev libxml2-dev \
  libreadline5-dev libxml2-dev sqlite3 libsqlite3-dev libxslt-dev \
  libfcgi-ruby1.9.1 libfcgi-dev lighttpd libpcre3-dev libyaml-dev \
  nmap

echo "Getting Ruby source"
cd /usr/local/src
wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.2-p180.tar.bz2
tar -xvjf ruby-1.9.2-p180.tar.bz2
cd ruby-1.9.2-p180

echo "Building ruby"

./configure
make

echo "Installing ruby"
make install

echo "Installing required gems"
gem update
gem install rake
gem install bundler

echo "Getting Gemeinschaft4, Cantina and sipproxy"
cd /opt
PROJECTS="Gemeinschaft4 
Cantina 
sipproxy";
for i in $PROJECTS
do
  cd /opt
  
  git clone https://$USER:$PASS@github.com/amooma/$i.git
  cd /opt/$i
  
  bundle install
  
  rake db:migrate RAILS_ENV=production
  rake db:seed RAILS_ENV=production
  
  cd /opt/$i/public
  bundle install --path .
  chown -R www-data /opt/$i
done

echo "Installing rewuired packages for Kamailio build"
aptitude -y install gcc flex bison libmysqlclient-dev make \
  libcurl4-openssl-dev libpcre3-dev libpcre++-dev

echo "Getting Kamailio source"
cd /usr/local/src
git clone git://git.sip-router.org/sip-router kamailio
cd kamailio
git checkout -b 3.1 origin/3.1

echo "Building Kamailio"
make FLAVOUR=kamailio  include_modules="dbtext dialplan" cfg
make PREFIX="/opt/kamailio-3.1" FLAVOUR=kamailio include_modules="db_text dialplan" cfg
make all

echo "Installing Kamailio"
make install

echo "Copy Kamailio and lighttpd configuration"
cp /etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf.DIST
cp /opt/Gemeinschaft4/misc/lighttpd.conf /etc/lighttpd/lighttpd.conf
/etc/init.d/lighttpd restart
cp -r /opt/Gemeinschaft4/misc/kamailio/etc/* /opt/kamailio-3.1/etc/kamailio/

echo "Fixing rights for webserver. Rights will be managed by SELinux in the future."
chgrp www-data /opt/kamailio-3.1/etc/kamailio/db_text/subscriber
chgrp www-data /opt/kamailio-3.1/etc/kamailio/db_text/dbaliases
chmod g+rw /opt/kamailio-3.1/etc/kamailio/db_text/subscriber 
chmod g+rw /opt/kamailio-3.1/etc/kamailio/db_text/dbaliases
cp /opt/Gemeinschaft4/misc/etc/init.d/kamailio /etc/init.d/

echo "Starting Kamailio"
update-rc.d  kamailio defaults
/etc/init.d/kamailio start

echo "We are done."
