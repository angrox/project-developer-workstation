# Fedora local VM

This VM is aimed for cloud developers who need access to various cloud providers.

Features:
- a lot :-)

The following cloud tools will be installed:
- Google Cloud Shell
- Azure CLI
- Kubectl (latest)
- Kubectx/Kubens
- K9s
- Kubernetes Helm Client (latest)
- binenv as virtual package provider for github binaries

The following helper tools will be installed:
- wharfee (http://wharfee.com/)
- pgcli (pgsql cli, https://www.pgcli.com/)
- mycli (mysql cli, https://www.mycli.net/)
- bpython (https://bpython-interpreter.org/)

Other stuff:
- oh-my-zsh (https://ohmyz.sh/)
- powerlevel10k (https://github.com/romkatv/powerlevel10k)

**powerlevel10k requires a compatible [font](https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k).**

# Usage
## Requirements
- lima (https://github.com/lima-vm/lima/)
- A powerlevel10k compatible [font](https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k), if you want to use it. See above how to use with other font.

## Usage
- Copy fedora.yaml.example to fedora.yaml and change the "<DIR>" placeholder to your working directory (this directory)
- Call 'lima start fedora.yaml'
- Login via the connect_fedora script
- Use chezmoi to add your dot_files git directory and checkout your dotfiles
