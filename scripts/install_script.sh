#!/bin/bash

/bin/ping -c1 ose-node1.rhosepaas.com
while [ $? -ne 0 ]; do
    sleep 10
    ping -c1 ose-node1.rhosepaas.com
done

/bin/ping -c1 ose-node2.rhosepaas.com

while [ $? -ne 0 ]; do
    sleep 10
    ping -c1 ose-node2.rhosepaas.com
done
yum install -y atomic-openshift* openshift* etcd
sleep 60
ssh -C -tt -v -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 ose-master.rhosepaas.com /bin/ansible-playbook /root/openshift-ansible/playbooks/byo/config.yml &> /tmp/ose_install.log
/bin/sed -i "s/name: deny_all/name: my_htpasswd_provider/g" /etc/origin/master/master-config.yaml
/bin/sed -i "/kind: DenyAllPasswordIdentityProvider/a \     \ file: /etc/origin/master/users.htpasswd" /etc/origin/master/master-config.yaml
/bin/sed -i "s/kind: DenyAllPasswordIdentityProvider/kind: HTPasswdPasswordIdentityProvider/g" /etc/origin/master/master-config.yaml
yum -y install httpd-tools
useradd ose_user; htpasswd -c -b /etc/origin/master/users.htpasswd ose_user redhat
sleep 10
systemctl restart atomic-openshift-master
sleep 60
echo "pods script execution"
ssh -C -tt -v -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 ose-master.rhosepaas.com /bin/bash -x /root/install_pods.sh &> /tmp/pods_install.log
/bin/sed -i 's/PermitRootLogin yes/#PermitRootLogin yes/g' /etc/ssh/sshd_config
