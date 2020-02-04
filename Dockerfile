# select operating system
FROM fedora:31

# add config and init files
COPY ansible/ /vagrant/ansible
COPY files/ /vagrant/files

RUN dnf --refresh install -y ansible vim dnf-plugins-core zsh \
    && groupadd --gid 1000 vagrant \
    && adduser --create-home --home-dir /home/vagrant --uid 1000 --gid 1000 --shell /usr/bin/zsh vagrant \
    && echo "vagrant ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/vagrant-nopasswd \
    && ansible-playbook --skip-tags vm_only --skip-tags update_os /vagrant/ansible/install_playbook.yaml \
    && dnf clean all

# start from init folder
USER vagrant
WORKDIR /home/vagrant
