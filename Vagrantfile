Vagrant.configure("2") do |config|

  config.vm.define :node do |node|
    node.vm.hostname = "vm-ubuntu20"
    node.vm.synced_folder "./shared", "/opt/vagrant/data"
    node.vm.box = "ubuntu/focal64"
    node.vm.network "private_network", ip: "192.168.122.253"
    node.vm.provider :virtualbox do |vbox|
      vbox.memory = 2048
      vbox.cpus = 2
    end
    node.vm.provision "shell", path: "./shared/bootstrap.sh"
  end
end
