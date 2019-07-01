# Fedora Vagrant VM for Cloud Developers

This Vagrant VM is aimed for cloud developers who need access to various cloud providers.

Features:
- Fedora 30
- VIM 8.x + Thubos Vim Configuration
- Docker CE
- NodeJS
- Java 1.8.0_x

The following cloud tools will be installed:
- Google Cloud Shell
- Azure CLI 2.0
- Kubectl (latest)
- Kubectx/Kubens
- K9s
- Kubernetes Helm Client (latest)

The following helper tools will be installed:
- wharfee (http://wharfee.com/)
- pgcli (pgsql cli, https://www.pgcli.com/)
- mycli (mysql cli, https://www.mycli.net/)
- bpython (https://bpython-interpreter.org/)
- jmsepath-terminal (https://pypi.python.org/pypi/jmespath-terminal)

Other tools:
- googler (https://github.com/jarun/googler)

# Usage
## Requirements
- Vagrant
- Virtualbox

## Usage
- Install Vagrant plugins: install_vagrant_plugins.sh
- Copy nodes.json.template (or node.json.azure) to node.json and edit it
- call 'vagrant up'
- Login with 'vagrant ssh'

## node.json Config
```
{
  "nodes": {
    "server1": {                             <-- node name
      ":ip": "192.168.35.91",                <-- ip address or 'dhcp'
      "ports": [],                           <-- ports to forward to localhost
      ":memory": 1024,
      ":box": "fedora/29-cloud-base",
      ":bootstrap": "bootstrap-fedora.sh",
      ":sync": ["~/test", "/data"]           <-- Directory mount. This is useful to keep your data on your local Disk. First argument is the local path.
    },
    "server2": {                             <-- Second VM if needed. If not delete it. Mind the ',' in the line above!
      ":ip": "192.168.35.92",
      "ports": [],
      ":memory": 1024,
      ":box": "fedora/29-cloud-base",
      ":bootstrap": "bootstrap-fedora.sh",
      ":sync": ["~/test", "/data"]
    }
  }
}
```
