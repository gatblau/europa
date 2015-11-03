Vagrant.configure(2) do |config|
  config.vm.box = "bento/centos-7.1"
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
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "build/europa.yml"
    ansible.inventory_path = "build/inv-remote.txt"
    ansible.sudo = true
    ansible.verbose = "vv"
    ansible.extra_vars = {
        ansible_ssh_user: 'vagrant',
        ansible_ssh_private_key_file: "~/.vagrant.d/insecure_private_key"
    }
  end
end