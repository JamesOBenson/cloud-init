# cloud-init
Openstack Cloud-init scripts


##cloud-init-devstack-master.sh	
--cloud-init for CentOS 7 and Ubuntu 14.04 using master

##cloud-init-devstack-stable-liberty.sh	
-- cloud-init for CentOS 7 and Ubuntu 14.04 using stable/liberty

##cloud-init-ubuntu.sh
-- Generic cloud-init script to help resolv hostname and perform updates

## cloud-init-devstack-stable-liberty_neutron.sh
-- cloud-init script to deploy liberty with neutron.
Neutron is by default not installed.  This will install it for you automatically.

## cloud-init-devstack-stable-liberty_neutron-www-enabled.sh
-- cloud-init script to deploy liberty with neutron.
Neutron is by default not installed.  This will install it for you automatically.
This cloud-init script also allows instances INSIDE of devstack to be able to ping the outside world i.e. google.com
