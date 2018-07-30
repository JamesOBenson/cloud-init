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
        git clone https://git.openstack.org/openstack-dev/devstack -b stable/ocata
        cd devstack
        echo '[[local|localrc]]' > local.conf
        echo ADMIN_PASSWORD=password >> local.conf
        echo DATABASE_PASSWORD=password >> local.conf
        echo RABBIT_PASSWORD=password >> local.conf
        echo SERVICE_PASSWORD=password >> local.conf
        echo SERVICE_TOKEN=tokentoken >> local.conf
        # The following 4 commands allow internet access to the instances
        echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf
        echo net.ipv4.conf.default.rp_filter=0 >> /etc/sysctl.conf
        echo net.ipv4.conf.all.rp_filter=0 >> /etc/sysctl.conf
        sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
        echo OFFLINE=True >> local.conf
        ./stack.sh
    path: /home/stack/start.sh
    permissions: 0755

runcmd:
  - su -l stack ./start.sh
