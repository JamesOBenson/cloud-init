#!/bin/bash
echo 127.0.0.1 localhost $HOSTNAME >> /etc/hosts
apt-get -qqy update