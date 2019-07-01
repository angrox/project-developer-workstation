#!/bin/sh

dnf -y install ansible bison flex psmisc libxcrypt-compat
cp /vagrant/files/bin/* /usr/local/bin
chmod 755 /usr/local/bin
ansible-playbook /vagrant/ansible/install_playbook.yaml
