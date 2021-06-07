$script = <<SCRIPT
echo 'Creating the Europa group'
groupadd -g 1000000001 europa
echo 'Creating the Europa user'
useradd europa -u 1000000001 -g europa -G wheel
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
  config.vm.box = "generic/rhel8"
  config.vm.box_version = "3.2.12"
  config.ssh.insert_key = false
  config.vm.provider "virtualbox" do |vbox|
    vbox.gui = true
    vbox.memory = 4096
    vbox.cpus = 2
    vbox.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vbox.customize ["modifyvm", :id, "--ioapic", "on"]
  end
  config.vm.network "private_network", ip: "192.168.50.10"
  config.vm.hostname = "europa"
  config.vm.define :europa do |europa| end
  config.vm.provision "shell", inline: $script
  config.vm.provision "shell", inline: "sudo yum -y install epel-release"
  config.vm.provision "shell", inline: "set +e; sudo subscription-manager remove --all 2>&1 >/dev/null; sudo subscription-manager unregister 2>&1 >/dev/null; sudo subscription-manager clean 2>&1 >/dev/null"
  config.vm.provision "shell" do |s|
    s.env = {RH_USERNAME:ENV['RH_USERNAME'], RH_PASSWORD:ENV['RH_PASSWORD']}
    s.inline = "sudo subscription-manager register --username ${RH_USERNAME} --password ${RH_PASSWORD} --name europa --auto-attach"
  end
  config.vm.provision "shell", inline: "sudo subscription-manager repos --enable codeready-builder-for-rhel-8-x86_64-rpms"

  # if not building in windows then
  if OS.windows?
#    config.vm.synced_folder "./cache", "/vagrant/build/cache"
    config.vm.synced_folder ".", "/vagrant"

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
