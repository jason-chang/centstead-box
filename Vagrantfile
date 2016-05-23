VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Configure The Box
  config.vm.box = 'bento/centos-7.2'
  config.vm.hostname = 'centstead-box'

  # Don't Replace The Default Key https://github.com/mitchellh/vagrant/pull/4707
  config.ssh.insert_key = false

  config.vm.provider :vmware_fusion do |v|
    v.memory = 2048
    v.cpus = 2
  end

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', '2048']
    vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
  end

  # Configure Port Forwarding
  config.vm.network 'forwarded_port', guest: 80, host: 8000
  config.vm.network 'forwarded_port', guest: 3306, host: 33060
  config.vm.network 'forwarded_port', guest: 5432, host: 54320
  config.vm.network 'forwarded_port', guest: 35729, host: 35729

  config.vm.synced_folder './', '/vagrant', disabled: true

  # Run The Provision Scripts
  config.vm.provision 'shell', path: './scripts/before.sh'
  config.vm.provision 'shell', path: './scripts/repos.sh'
  config.vm.provision 'shell', path: './scripts/nginx.sh'

  if File.exists? File.expand_path('./avant')
    config.vm.provision 'shell', path: './scripts/php/php70.sh'
    config.vm.provision 'shell', path: './scripts/mysql/mysql57.sh'
  else
    config.vm.provision 'shell', path: './scripts/php/php56.sh'
    config.vm.provision 'shell', path: './scripts/mysql/mysql56.sh'
  end

  config.vm.provision 'shell', path: './scripts/orthers.sh'
  config.vm.provision 'shell', path: './scripts/clean.sh'

end