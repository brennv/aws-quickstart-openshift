touch /tmp/ssh-test.log
ssh -fN -o StrictHostKeyChecking=false ose-master &
echo "Master SSH testing" >> /tmp/ssh-test.log
ssh -fN -o StrictHostKeyChecking=false ose-node1 &
echo "Node1 SSH testing" >> /tmp/ssh-test.log
ssh -fN -o StrictHostKeyChecking=false ose-node2 &
echo "Node2  SSH testing" >> /tmp/ssh-test.log
