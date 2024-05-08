# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
INSTANCES_COUNT = 3

def assignIP(num)
    return "192.168.59.#{num+200}"
end

def assignSSH(num)
    return num+2200
end

def assignNAME(num)
    return num == 1 ? "k8s-controller" : "k8s-worker-00#{num-1}"
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = "bento/ubuntu-20.04"
    config.vm.box_version = "202309.09.0"
    (1..INSTANCES_COUNT).each do |i|
        config.vm.define vm_instance_name = assignNAME(i) do |instance|
            instance.vm.hostname = vm_instance_name
            instance.vm.network "private_network", ip: assignIP(i)
            instance.vm.network :forwarded_port, guest: 22, host: assignSSH(i), id: 'ssh'
            instance.vm.provision "shell", path: "./scripts/bootstrap.sh", args: assignIP(i)
        end
    end
    config.vm.provider "virtualbox" do |vb|
        vb.cpus = 1
        vb.memory = 1024
    end
end
