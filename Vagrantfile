VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Configure The Box
  config.vm.box = 'bento/centos-7.2'
  config.vm.hostname = 'centstead-box'

  # Don't Replace The Default Key https://github.com/mitchellh/vagrant/pull/4707
  config.ssh.insert_key = false

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', '2048']
    vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
  end

  config.vm.provider :vmware_fusion do |v|
    v.memory = 2048
    v.cpus = 2
  end

  # Configure Port Forwarding
  config.vm.network 'forwarded_port', guest: 80, host: 8000
  config.vm.network 'forwarded_port', guest: 3306, host: 33060
  config.vm.network 'forwarded_port', guest: 5432, host: 54320
  config.vm.network 'forwarded_port', guest: 35729, host: 35729

  config.vm.synced_folder './', '/vagrant', disabled: true

  # Run The Base Provisioning Script
  config.vm.provision 'shell', path: './scripts/provision.sh'
  
  config.push.define "atlas" do |push|
    push.app = "jason-chang/centstead-box"
  end
  
end
