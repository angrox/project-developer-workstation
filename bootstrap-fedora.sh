#!/bin/sh

dnf -y install ansible
cp /vagrant/files/update_helm /usr/local/bin
chmod 755 /usr/local/bin
ansible-playbook /vagrant/ansible/install_playbook.yaml
