#!/bin/bash
yum -y install python-setuptools wget curl
easy_install pip
pip install python-daemon argparse pystache requests
cd /tmp
wget https://s3.amazonaws.com/openshift-cft/aws-cfn-bootstrap-1.4-8.tar.gz -O cfn.tgz
tar -xzvf cfn.tgz 
cd aws-*
python setup.py build
python setup.py install
