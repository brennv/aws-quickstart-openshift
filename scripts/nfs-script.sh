/bin/ping -c1 ose-node1.rhosepaas.com
while [ $? -ne 0 ]; do
    sleep 10
    ping -c1 ose-node1.rhosepaas.com
done
sleep 60
showmount -e ose-node1
mount ose-node1:/opt/secure /mnt
cp /mnt/id_rsa* /root/.ssh/
cat /mnt/id_rsa.pub >> /root/.ssh/authorized_keys
