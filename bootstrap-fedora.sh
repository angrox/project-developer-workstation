#!/bin/sh

dnf -y install ansible bison flex psmisc libxcrypt-compat
chmod 755 /usr/local/bin
su vagrant -c "ansible-galaxy collection install community.general"
su vagrant -c "ansible-playbook /vagrant/ansible/install_playbook.yaml"
