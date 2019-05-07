$script = <<SCRIPT
echo 'Creating the Europa group'
groupadd -g 501 europa
echo 'Creating the Europa user'
useradd europa -u 501 -g europa -G wheel
echo 'Setting up a password for the user'
echo "eur0pa"|passwd --stdin europa
echo 'Adding the user to the sudoer list'
echo 'europa        ALL=(ALL)       NOPASSWD: ALL' >> /etc/sudoers.d/europa
chmod 0440 /etc/sudoers.d/europa
SCRIPT

# OS detection
module OS
    def OS.windows?
        (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    end
end

Vagrant.configure(2) do |config|
  config.vm.box = "bento/centos-7.6"
  config.vm.box_version = "201812.27.0"
  config.ssh.insert_key = false
  config.vm.provider "virtualbox" do |vbox|
    vbox.memory = 4096
    vbox.cpus = 2
    vbox.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vbox.customize ["modifyvm", :id, "--ioapic", "on"]
  end
  config.vm.network "private_network", ip: "192.168.50.10"
  config.vm.hostname = "europa"
  config.vm.define :europa do |europa| end
  config.vm.provision "shell", inline: $script

  # if not building in windows then
  if OS.windows?
    config.vm.synced_folder "./cache", "/vagrant/build/cache"

    # use a local provisioner
    config.vm.provision "ansible_local" do |ansible|
        ansible.playbook = "build/site.yml"
        ansible.become = true
        ansible.verbose = "vv"
        ansible.skip_tags = "gnome"
    end
  else
    # use ansible to ssh to remote host
    config.vm.provision "ansible" do |ansible|
        ansible.playbook = "build/site.yml"
        ansible.become = true
        ansible.verbose = "vv"
        ansible.skip_tags = "gnome"
        ansible.inventory_path = "build/inv-remote.txt"
        ansible.extra_vars = {
            ansible_ssh_user: 'vagrant',
            ansible_ssh_private_key_file: "~/.vagrant.d/insecure_private_key"
        }
    end
  end
end
