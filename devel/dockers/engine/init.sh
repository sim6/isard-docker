#!/bin/bash
#public_key="/root/.ssh/authorized_keys"
#if [ -f "$public_key" ]
#then
#	echo "$file found, so not generating new ones."
#else
#	echo "$file not found, generating new ones"
cat /dev/zero | ssh-keygen -q -N ""
mv /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys 

#fi
#ssh-keyscan isard-hypervisor > /tmp/known_hosts
#DIFF=$(diff /root/.ssh/know_hosts /tmp/known_hosts) 
#if [ "$DIFF" != "" ] 
#then
#    	echo "The HYPERVISOR key has been regenerated"
#	rm /root/.ssh/known_hosts

echo "Scanning isard-hypervisor key..."
ssh-keyscan isard-hypervisor > /root/.ssh/known_hosts
while [ ! -s /root/.ssh/known_hosts ]
do
  sleep 2
  echo "Waiting for isard-hypervisor to be online..."
  ssh-keyscan isard-hypervisor > /root/.ssh/known_hosts
done
echo "isard-hypervisor online, starting engine..."

#fi

######## Only on development
echo -e "isard\nisard" | (passwd --stdin root)
ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
sleep 2
echo "Starting sshd daemon"
/usr/sbin/sshd
########

#python3 /isard/python3 -m 'http.server'
echo "Starting engine..."
python3 /isard/run_docker_engine.py

