#!/bin/bash

set -e

# Gemeinschaft4 Git branch. In the master branch do not set this to anything but "master"!
GIT_BRANCH="master"


if [ ! -e /etc/debian_version ]; then
  echo "This script must be run on a Debian system." >&2
  exit 1
fi
if ! grep '^6\.' /etc/debian_version ; then
  echo "This script must be run on Debian 6.x (\"Squeeze\")." >&2
  echo "(You have: `cat /etc/debian_version`)" >&2
  exit 1
fi


echo -e "Please enter your github.com username:\n"
read USER

echo -e "Please enter your github.com password:\n"
read PASS



set -x


echo -e "Adding APT sources ...\n"

(
echo 'deb      http://www.kempgen.net/pkg/deb/ squeeze contrib'
echo 'deb-src  http://www.kempgen.net/pkg/deb/ squeeze contrib'
) > /etc/apt/sources.list.d/kempgen.list

(
echo 'deb http://deb.kamailio.org/kamailio squeeze main'
echo 'deb-src http://deb.kamailio.org/kamailio squeeze main'
) > /etc/apt/sources.list.d/kamailio.list


aptitude update

echo -e "Installing required packages ...\n"

aptitude install -y --allow-untrusted \
  git \
  make \
  build-essential \
  debhelper \
  libfcgi-dev \
  libxml++-dev \
  libxslt-dev \
  libsqlite3-dev \
  libjpeg62 \
  kamailio  \
  kamailio-unixodbc-modules \
  freeswitch \
  freeswitch-lua  \
  freeswitch-perl freeswitch-spidermonkey \
  freeswitch-lang-de  \
  freeswitch-lang-en  \
  ghostscript  \
  imagemagick  \
  curl 
echo -e "Adding testing and setting APT Pin-Priority ...\n"
(
echo 'deb     http://ftp.debian.org/debian/ testing main'
echo 'deb-src http://ftp.debian.org/debian/ testing main'
) > /etc/apt/sources.list.d/testing.list
(
echo 'Package: *'
echo 'Pin: release a=testing'
echo 'Pin-Priority: -1'
) > /etc/apt/preferences.d/testing
(
echo 'Package: libsqliteodbc'
echo 'Pin: release a=testing'
echo 'Pin-Priority: 999'
) > /etc/apt/preferences.d/libsqliteodbc
aptitude update
apt-cache policy libsqliteodbc
echo -e "Installing sqlite-odbc\n"
aptitude install -y libsqliteodbc/testing


echo -e "Stopping services ...\n"
/etc/init.d/freeswitch  stop

/etc/init.d/kamailio    stop


echo -e "Downloading GS4 ...\n"

cd /opt
git clone -b "$GIT_BRANCH" "https://$USER:$PASS@github.com/amooma/Gemeinschaft4.git" gemeinschaft

echo -e "Installing Ruby ...\n"
cd /opt/gemeinschaft/misc/ruby-sane
make deb-install

echo -e "Installing Ruby on Rails ...\n"
gem install   rails
gem install   rake -v 0.8.7
apt-get install -t testing libpcre3-dev
apt-get install -t testing libcurl4-openssl-dev
aptitude install -y apache2 apache2-prefork-dev libapr1-dev libaprutil1-dev


/etc/init.d/apache2   stop
echo -e "Configuring ODBC ...\n"

echo "[gemeinschaft-production]
Description=My SQLite test database
Driver=SQLite3
Database=/opt/gemeinschaft/db/production.sqlite3
Timeout=2000" >> /etc/odbc.ini

ln -s /opt/gemeinschaft /opt/Gemeinschaft4

echo -e "Configuring Kamailio ...\n"

mv /etc/kamailio /etc/kamailio.dist
ln -s /opt/gemeinschaft/misc/kamailio/etc /etc/kamailio
sed -i 's/RUN_KAMAILIO=no/RUN_KAMAILIO=yes/' /etc/default/kamailio

echo -e "Configuring Apache ...\n"

cp /opt/gemeinschaft/misc/etc/apache/gemeinschaft /etc/apache2/sites-available
a2ensite gemeinschaft
cp -r /opt/gemeinschaft/misc/etc/ssl/amooma /etc/ssl/
chown www-data /etc/ssl/amooma/*
chmod 0600 /etc/ssl/amooma/*
a2enmod rewrite

echo -e "Configuring FreeSwitch ...\n"

mv /opt/freeswitch/conf /opt/freeswitch/conf.dist
ln -s /opt/gemeinschaft/misc/freeswitch/fs-conf     /opt/freeswitch/conf
ln -s /opt/gemeinschaft/misc/freeswitch/fs-scripts  /opt/freeswitch/scripts
sed -i 's/FREESWITCH_ENABLED="false"/FREESWITCH_ENABLED="true"/'  /etc/default/freeswitch
sed -i 's/^FREESWITCH_PARAMS.*/FREESWITCH_PARAMS="-nc -nonat"/'   /etc/default/freeswitch


echo -e "Setting up database ...\n"

cd /opt/gemeinschaft/
bundle install
bundle exec rake db:migrate  RAILS_ENV=production
bundle exec rake db:seed     RAILS_ENV=production

cd /opt/gemeinschaft/public/
bundle install --path .
#OPTIMIZE "bundle install --path ." installs the Gems into a "ruby" directory in /opt/gemeinschaft/. Why should we need this? We don't need it with the Debian packages.


echo -e "Creating and populating group \"gemeinschaft\" ...\n"
addgroup gemeinschaft || true
adduser www-data    gemeinschaft --quiet
adduser kamailio    gemeinschaft --quiet
adduser freeswitch  gemeinschaft --quiet

chown -R www-data:gemeinschaft /opt/gemeinschaft
chmod g+w /opt/gemeinschaft/db
chmod g+w /opt/gemeinschaft/db/production.sqlite3
chmod 777 /opt/gemeinschaft/misc/fax


echo -e "Downloading FreeSwitch sound files ...\n"
mkdir -p /opt/freeswitch/sounds
/opt/gemeinschaft/misc/freeswitch/download-freeswitch-sounds || true

gem install passenger

passenger-install-apache2-module
a2enmod ssl


echo -e "Retrieving FreeSwitch configuration ...\n"

/opt/freeswitch/scripts/freeswitch-gemeinschaft4.sh >>/dev/null
chmod g+w                      /opt/freeswitch/conf/freeswitch-gemeinschaft4.xml
chown freeswitch:gemeinschaft  /opt/freeswitch/conf/freeswitch-gemeinschaft4.xml


echo -e "Downloading FreeSwitch sound files ...\n"
mkdir -p  /opt/freeswitch/sounds
cd        /opt/freeswitch/sounds/

wget -c 'http://files.freeswitch.org/freeswitch-sounds-en-us-callie-8000-1.0.15.tar.gz'   2>&1 || true
wget -c 'http://files.freeswitch.org/freeswitch-sounds-en-us-callie-16000-1.0.15.tar.gz'  2>&1 || true
wget -c 'http://files.freeswitch.org/freeswitch-sounds-music-8000-1.0.8.tar.gz'           2>&1 || true
wget -c 'http://files.freeswitch.org/freeswitch-sounds-music-16000-1.0.8.tar.gz'          2>&1 || true

tar -xzf 'freeswitch-sounds-en-us-callie-8000-1.0.15.tar.gz'   2>&1 || true
tar -xzf 'freeswitch-sounds-en-us-callie-16000-1.0.15.tar.gz'  2>&1 || true
tar -xzf 'freeswitch-sounds-music-8000-1.0.8.tar.gz'           2>&1 || true
tar -xzf 'freeswitch-sounds-music-16000-1.0.8.tar.gz'          2>&1 || true

rm 'freeswitch-sounds-en-us-callie-8000-1.0.15.tar.gz'   2>&1 || true
rm 'freeswitch-sounds-en-us-callie-16000-1.0.15.tar.gz'  2>&1 || true
rm 'freeswitch-sounds-music-8000-1.0.8.tar.gz'           2>&1 || true
rm 'freeswitch-sounds-music-16000-1.0.8.tar.gz'          2>&1 || true

chgrp -R gemeinschaft /opt/freeswitch

cp /opt/gemeinschaft/misc/etc/sudoers.d/gemeinschaft /etc/sudoers.d/
chmod 0440 /etc/sudoers.d/gemeinschaft
grep '#includedir /etc/sudoers.d' /etc/sudoers || echo  '#includedir /etc/sudoers.d' >> /etc/sudoers

cp /opt/gemeinschaft/misc/etc/apparmor.d/* /etc/apparmor.d/

chown www-data:gemeinschaft /opt/freeswitch/conf/freeswitch-gemeinschaft4.xml

echo -e "\n"
echo -e "Is this an appliance on Knoppix base? (y|n)"
read n
case $n in
	y|Y)
		test -f /etc/sudoers.secure && grep '#includedir /etc/sudoers.d' /etc/sudoers.secure || echo  '#includedir /etc/sudoers.d' >> /etc/sudoers.secure	
		cd /opt/gemeinschaft;
		RAILS_ENV=production bundle exec rake db:appliance_seed
		cp /opt/gemeinschaft/misc/etc/init.d/* /etc/init.d/
		sed -i 's/\(SERVICES="\)\(.*\)/\1gs4 networking dnsmasq firewall apache2 apparmor freeswitch kamailio"/' /etc/rc.local
		a2dissite default
		mv /opt/gemeinschaft/db/* /opt/gemeinschaft-local/db/
		rmdir /opt/gemeinschaft/db/
		ln -s /opt/gemeinschaft-local/db /opt/gemeinschaft/db
		chown -R www-data /opt/gemeinschaft-local/db
		mv /etc/resolv.conf /opt/gemeinschaft-local/data/etc/
		ln -s /opt/gemeinschaft-local/data/etc/resolv.conf /etc/resolv.conf
		mkdir -p /opt/gemeinschaft-local/data/opt/freeswitch
		mkdir -p /opt/gemeinschaft-local/data/opt/freeswitch/recordings
		ln -s /opt/gemeinschaft-local/data/opt/freeswitch/recordings /opt/freeswitch/
		mkdir -p /opt/gemeinschaft-local/data/opt/gemeinschaft/misc
		mv /opt/gemeinschaft/misc/fax/ /opt/gemeinschaft-local/data/opt/gemeinschaft/misc/
		ln -s /opt/gemeinschaft-local/data/opt/gemeinschaft/misc/fax/ /opt/gemeinschaft/misc/fax
		mv /opt/gemeinschaft/tmp/ /opt/gemeinschaft-local/data/opt/gemeinschaft/
		ln -s /opt/gemeinschaft-local/data/opt/gemeinschaft/tmp /opt/gemeinschaft/tmp
		mkdir -p /opt/gemeinschaft-local/data/opt/gemeinschaft/misc/
		mv /opt/gemeinschaft/misc/freeswitch /opt/gemeinschaft-local/data/opt/gemeinschaft/misc/
		ln -s /opt/gemeinschaft-local/data/opt/gemeinschaft/misc/freeswitch /opt/gemeinschaft/misc/freeswitch
		mkdir -p /opt/gemeinschaft-local/data/opt/freeswitch/
		mv /opt/freeswitch/db/ /opt/gemeinschaft-local/data/opt/freeswitch/
		ln -s /opt/gemeinschaft-local/data/opt/freeswitch/db /opt/freeswitch/
		mkdir -p /opt/gemeinschaft-local/data/opt/freeswitch/run
		ln -s /opt/gemeinschaft-local/data/opt/freeswitch/run /opt/freeswitch/
		mkdir /var/log/freeswitch
		chgrp gemeinschaft /var/log/freeswitch
		chmod g+rw /var/log/freeswitch
		rmdir /opt/freeswitch/log
		ln -s /var/log/freeswitch /opt/freeswitch/log
		mkdir -p /opt/gemeinschaft-local/data/opt/freeswitch/storage
		ln -s /opt/gemeinschaft-local/data/opt/freeswitch/storage /opt/freeswitch/

	;;
	*)
	;;
esac

echo -e "\n\n"
echo -e "Done.\n\n"


