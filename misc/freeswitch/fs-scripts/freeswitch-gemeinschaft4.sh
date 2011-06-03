#! /bin/sh

set -e
cd /opt/freeswitch/conf/
wget \
        -O freeswitch-gemeinschaft4.xml \
        --dns-timeout=10 \
        --connect-timeout=10 \
        --read-timeout=60 \
        --tries=30 \
        --retry-connrefused \
        --waitretry=10 \
        http://127.0.0.1/freeswitch-configuration/freeswitch.xml \
        1>>/dev/null 2>>/dev/null || true