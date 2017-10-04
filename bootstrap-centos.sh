#!/bin/sh
while getopts "u" opt; do
  case $opt in
    u)
      UPDATE=1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

# Do not do this via update
if [ -z "$UPDATE" ]; then
  # EPEL
  sudo rpm -ihv https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  # Deltarpm && Update
  sudo yum -y --nogpgcheck install applydeltarpm
  sudo yum -y --nogpgcheck update
  # Disable Firewall
  sudo systemctl stop firewalld
  sudo systemctl disable firewalld

  # COPR Repo for vim8
  curl https://copr.fedorainfracloud.org/coprs/mcepl/vim8/repo/epel-7/mcepl-vim8-epel-7.repo > /etc/yum.repos.d/copr-vim8.repo
  rpm --import https://copr-be.cloud.fedoraproject.org/results/mcepl/vim8/pubkey.gpg
  # Dep. Error:
  yum remove -y vim-minimal
  yum install -y vim-enhanced
  yum install -y sudo

  # Requirements for the things below and a few utilities
  sudo yum -y install wget unzip nodejs telnet jq nmap traceroute tcpdump strace ltrace mtr rsync zip myrepo git
  sudo yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-devel

  # Docker Repo
  yum -y remove docker \
                    docker-common \
                    container-selinux \
                    docker-selinux \
                    docker-engine
  yum-config-manager -y --add-repo https://download.docker.com/linux/centos/docker-ce.repo

  # Ansible
  sudo yum -y --nogpgcheck install ansible

  # Enable SCLs
  sudo yum -y install centos-release-scl
  sudo yum-config-manager --enable rhel-server-rhscl-7-rpms
  # Google Cloud
  sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo << EOM
[google-cloud-sdk]
name=Google Cloud SDK
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOM
  # The indentation for the 2nd line of <code>gpgkey</code> is important.
  rpm --import https://packages.cloud.google.com/yum/doc/yum-key.gpg
  rpm --import https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
  # Install the Cloud SDK
  sudo yum -y install google-cloud-sdk

  # Python 3.5
  yum -y --nogpgcheck install python35 rh-python35-python-pip scl-utils rh-python35-python-devel
  source /opt/rh/rh-python35/enable
  echo "source /opt/rh/rh-python35/enable" >> ~vagrant/.bash_profile
  echo "source /opt/rh/rh-python35/enable" >> ~/.bash_profile

  yum -y --nogpgcheck install rh-git29
  source /opt/rh/rh-git29/enable
  echo "source /opt/rh/rh-git29/enable" >> ~vagrant/.bash_profile
  echo "source /opt/rh/rh-git29/enable" >> ~/.bash_profile
  # SDK Man (supports more recent sdks)
  curl -s https://get.sdkman.io | su - vagrant -c /bin/bash
  # Install gradle
  su - vagrant -c "sdk install gradle"

  # Install liquidprompt
  git clone https://github.com/nojhan/liquidprompt.git /usr/share/liquidprompt
  echo "source /usr/share/liquidprompt/liquidprompt" >> ~vagrant/.bash_profile
  echo "source /usr/share/liquidprompt/liquidprompt" >> ~/.bash_profile

  # Custom SSH Key (presumly to access git)
  mkdir ~vagrant/.ssh
  chmod 700 ~vagrant/.ssh
  cp /vagrant/ssh/* ~vagrant/.ssh/
  chown -R vagrant:vagrant ~vagrant/.ssh/id*
  chmod 700 ~vagrant/.ssh/id*

  # Requirements for azure cli
  yum -y install libffi-devel gcc

else
  # UPDATES
  yum -y update
  su - vagrant -c "sdk selfupdate"
  su - vagrant -c "sdk upgrade gradle"
  cd /usr/share/liquidprompt && git pull
fi

# Vim config
curl https://raw.githubusercontent.com/Thubo/dotconfig-vim/master/.vimrc >/home/vagrant/.vimrc
chown vagrant:vagrant /home/vagrant/.vimrc

# docker compose
curl -L https://github.com/docker/compose/releases/download/1.12.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod 755 /usr/local/bin/docker-compose

# Profitbricks CLI
sudo npm install -g profitbricks-cli

# Terraform and TF Profitbricks plugin
if [ -z "$TERRAFORM_VERSION" ]
then
  TERRAFORM_VERSION=`curl -s "https://releases.hashicorp.com/terraform/" | grep terraform_ | grep -v beta | head -1 | cut -d/ -f3`
fi
wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
sudo unzip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip
sudo chmod 755 /usr/local/bin/terraform

# Kubectl
curl -o /usr/local/bin/kubectl -L https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod 755 /usr/local/bin/kubectl

# Add cli tools
# Upgraded version of pip
# Install Wharfee (http://wharfee.com/)
# Install pgcli (pgsql cli, https://www.pgcli.com/)
# Install mycli (mysql cli, https://www.mycli.net/)
# Install bpython (https://bpython-interpreter.org/)
# Install jmsepath-terminal (https://pypi.python.org/pypi/jmespath-terminal)
# AWS CLI and Elastic Beanstalk CLI
# Azure CLI
for i in pip wharfee pgcli mycli bpython jmespath-terminal awscli awsebcli azure-cli
do
  su - vagrant -c "pip install --upgrade --user $i"
done

# Install googler
googler_url=`curl -s https://api.github.com/repos/jarun/googler/releases/latest |jq -r ".assets[] | select(.name|test(\"centos\")) .browser_download_url"`
rpm -Uhv $googler_url
