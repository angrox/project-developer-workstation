# select operating system
FROM fedora:31

# add config and init files
COPY ansible/ /vagrant/ansible
COPY files/ /vagrant/files

RUN dnf --refresh install -y ansible vim dnf-plugins-core\
    && ansible-playbook --skip-tags vm_only /vagrant/ansible/install_playbook.yaml \
    && dnf clean all

# start from init folder
ENTRYPOINT ["/bin/bash"]
