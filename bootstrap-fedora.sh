#!/bin/sh

dnf -y install ansible
ansible-playbook /vagrant/ansible/install_playbook.yaml
