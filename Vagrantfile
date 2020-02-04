# -*- mode: ruby -*-
# vi: set ft=ruby :

class CustomInstaller < VagrantVbguest::Installers::Linux
  def install(opts=nil, &block)
    communicate.sudo('dnf install -y libxcrypt-compat kernel-devel-$(uname -r) gcc make perl', opts, &block)
    # calling `super` will run the installation
    # also it takes care of uploading the right iso file into the box
    # and cleaning up afterward
    super
  end
end



# read vm and chef configurations from JSON files
nodes_config = (JSON.parse(File.read("nodes.json")))['nodes']

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  nodes_config.each do |node|
    node_name   = node[0] # name of node
    node_values = node[1] # content of node

    config.vbguest.auto_update = true
    config.vbguest.installer = CustomInstaller

    config.vm.box = node_values[':box']


    config.vm.define node_name do |config|
      # configures all forwarding ports in JSON array
      ports = node_values['ports']
      ports.each do |port|
        config.vm.network :forwarded_port,
          host:  port[':host'],
          guest: port[':guest'],
          id:    port[':id']
      end

      config.vm.hostname = node_name
      if node_values[':ip']== "dhcp"
        config.vm.network :private_network, type: "dhcp"
      else
        config.vm.network :private_network, ip: node_values[':ip']
      end
      config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", node_values[':memory']]
        vb.customize ["modifyvm", :id, "--name", node_name]
      end

      config.vm.provision :shell, :path => node_values[':bootstrap']
      #config.vm.synced_folder node_values[':sync'][0], node_values[':sync'][1], type: "nfs", mount_options: ['rw', 'vers=3', 'tcp'], linux__nfs_options: ['rw','no_subtree_check','all_squash','async']
      #config.vm.synced_folder node_values[':sync'][0], node_values[':sync'][1], mount_options: ["cache=none", "fmode=644"]
      config.vm.synced_folder node_values[':sync'][0], node_values[':sync'][1], mount_options: ["cache=none"]
    end
  end
end
