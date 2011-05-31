#!/bin/bash -x
echo -e "Please enter your github.com username\n"
read USER

echo -e "Please enter your github.com password\n"
read PASS


echo -e "Adding apt sources\n"

(
echo 'deb      http://www.kempgen.net/pkg/deb/ squeeze contrib'
echo 'deb-src  http://www.kempgen.net/pkg/deb/ squeeze contrib'
) > /etc/apt/sources.list.d/kempgen.list

(
echo 'deb http://deb.kamailio.org/kamailio squeeze main'
echo 'deb-src http://deb.kamailio.org/kamailio squeeze main'
) > /etc/apt/sources.list.d/kamailio.list


aptitude update

echo -e "Installing required packages\n"

aptitude install -y --allow-untrusted git \
make \
build-essential \
debhelper \
libfcgi-dev \
libxml++-dev \
libxslt-dev \
libsqlite3-dev \
libjpeg62 \
lighttpd \
kamailio  \
kamailio-unixodbc-modules \
freeswitch \
freeswitch-lua  \
freeswitch-perl freeswitch-spidermonkey \
freeswitch-lang-de  \
freeswitch-lang-en


echo -e "Adding testing and setting pin-priotity\n"
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

aptitude install libsqliteodbc/testing


echo -e "Stopping services for configuration\n"

/etc/init.d/freeswitch stop
/etc/init.d/lighttpd stop
/etc/init.d/kamailio stop


echo -e "Getting GS4\n"

cd /opt
git clone -b master https://$USER:$PASS@github.com/amooma/Gemeinschaft4.git

echo -e "Installing ruby\n"
cd /opt/Gemeinschaft4/misc/ruby-sane
make deb-install
gem install rails
gem install rake -v 0.8.7
gem uninstall rake -v 0.9.0


echo -e "Configuring odbc\n"

echo "[gemeinschaft-production]
Description=My SQLite test database
Driver=SQLite3
Database=/opt/gemeinschaft/db/production.sqlite3
Timeout=2000" >> /etc/odbc.ini


ln -s /opt/Gemeinschaft4 /opt/gemeinschaft

echo -e "Configuring freeswitch and kamailio\n"

mv /etc/kamailio/ /etc/kamailio.dist
ln -s /opt/Gemeinschaft4/misc/kamailio/etc /etc/kamailio
sed -i 's/RUN_KAMAILIO=no/RUN_KAMAILIO=yes/' /etc/default/kamailio

cp /opt/Gemeinschaft4/misc/lighttpd.conf /etc/lighttpd/

mv /opt/freeswitch/conf /opt/freeswitch/conf.dist
ln -s /opt/Gemeinschaft4/misc/freeswitch/fs-conf /opt/freeswitch/conf
ln -s /opt/Gemeinschaft4/misc/freeswitch/fs-scripts/ /opt/freeswitch/scripts
sed -i 's/FREESWITCH_ENABLED="false"/FREESWITCH_ENABLED="true"/' /etc/default/freeswitch

echo -e "Setting up database\n"

cd /opt/Gemeinschaft4
bundle install
rake db:migrate RAILS_ENV=production
rake db:seed RAILS_ENV=production

cd /opt/Gemeinschaft4/public
bundle install --path .
chown -R www-data /opt/Gemeinschaft4

echo -e "Starting services\n"

/etc/init.d/freeswitch start
/etc/init.d/lighttpd start
/etc/init.d/kamailio start


echo -e "\n\n"
echo -e "We are done\n\n"

