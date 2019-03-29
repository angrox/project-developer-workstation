#!/bin/sh

dnf -y install ansible bison flex psmisc
cp /vagrant/files/bin/* /usr/local/bin
chmod 755 /usr/local/bin
ansible-playbook /vagrant/ansible/install_playbook.yaml
