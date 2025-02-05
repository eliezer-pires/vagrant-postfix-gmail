Vagrant.configure("2") do |config|
  config.vm.define "ubuntu" do |ubuntu|
    ubuntu.vm.box = "generic/ubuntu2204"
    ubuntu.vm.network "public_network", :dev => "wlp0s20f3", ip => "192.168.1.91"
    ubuntu.vm.hostname = "postfix-gmail"
    ubuntu.vm.synced_folder "configs", "/home/configs_vm"
  # Configurações do Virtualbox
    ubuntu.vm.provider "libvirt" do |vb|
      vb.memory = 2048
      vb.cpus = 2
    end
    ubuntu.vm.provision "shell", path: "postfix.sh"
  end
end