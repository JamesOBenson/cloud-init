#cloud-config

users:
  - default
  - name: stack
    lock_passwd: False
    sudo: ["ALL=(ALL) NOPASSWD:ALL\nDefaults:stack !requiretty"]
    shell: /bin/bash

write_files:
  - content: |
        #!/bin/sh
        echo 127.0.0.1 localhost $HOSTNAME >> /etc/hosts
        DEBIAN_FRONTEND=noninteractive sudo apt-get -qqy update || sudo yum update -qy
        DEBIAN_FRONTEND=noninteractive sudo apt-get install -qqy git || sudo yum install -qy git
        sudo chown stack:stack /home/stack
        cd /home/stack
        git clone https://git.openstack.org/openstack-dev/devstack -b stable/liberty
        cd devstack
        echo '[[local|localrc]]' > local.conf
        echo ADMIN_PASSWORD=password >> local.conf
        echo MYSQL_PASSWORD=password >> local.conf
        echo RABBIT_PASSWORD=password >> local.conf
        echo SERVICE_PASSWORD=password >> local.conf
        echo SERVICE_TOKEN=tokentoken >> local.conf
        echo disable_service n-net >> local.conf
        echo enable_service q-svc >> local.conf
        echo enable_service q-agt >> local.conf
        echo enable_service q-dhcp >> local.conf
        echo enable_service q-l3 >> local.conf
        echo enable_service q-meta >> local.conf
        # Optional, to enable tempest configuration as part of devstack
        echo enable_service tempest >> local.conf
        # The following 4 commands allow internet access to the instances
        echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf
        echo net.ipv4.conf.default.rp_filter=0 >> /etc/sysctl.conf
        echo net.ipv4.conf.all.rp_filter=0 >> /etc/sysctl.conf
        sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
        ./stack.sh
    path: /home/stack/start.sh
    permissions: 0755

runcmd:
  - su -l stack ./start.sh
