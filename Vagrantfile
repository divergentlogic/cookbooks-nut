# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.cache.scope = :box if Vagrant.has_plugin?('vagrant-cachier')

  if Vagrant.has_plugin?('vagrant-omnibus')
    config.omnibus.chef_version = '12.3.0'
  end

  config.vm.provider :virtualbox do |virtualbox|
    virtualbox.gui = true
    virtualbox.memory = 1024
    virtualbox.cpus = 2
  end

  config.vm.provider :parallels do |parallels|
    parallels.guest_tools = true
    parallels.memory = 1024
    parallels.cpus = 2
  end

  config.vm.define :trusty do |trusty_config|
    trusty_config.vm.box = 'ubuntu/trusty64'
    trusty_config.vm.define :trusty do |_trusty_config|
      override.vm.box = 'parallels/ubuntu-14.04'
    end
  end

  config.vm.define :precise do |precise_config|
    precise_config.vm.box = 'ubuntu/precise64'
    precise_config.vm.provider :parallels do |_v, override|
      override.vm.box = 'puphpet/ubuntu1204-x64'
    end
  end

  config.vm.define :jessie do |jessie_config|
    jessie_config.vm.box = 'debian/jessie64'
    jessie_config.vm.provider :parallels do |_v, override|
      override.vm.box = 'ffuenf/debian-8.0.0-amd64'
    end
  end

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      'nut' => {
        'mode' => 'standalone',

        'devices' => ['ttyS0'],

        'ups' => {
          # 'cyberpower' => {
          #   "driver" => "powerpanel",
          #   "port" => "/dev/ttyS0",
          #   "desc" => "Cyberpower CP1500AVR"
          # }

          'apc' => {
            'driver' => 'usbhid-ups',
            'port' => 'auto',
            'desc' => 'Back-UPS XS 1500'
          }
        },

        'users' => {
          'vagrant' => {
            'password' => 'vagrant',
            'upsmod master' => true
          }
        },

        'monitors' => {
          # "cyberpower" => {
          #   "system" => "cyberpower@localhost",
          #   "power_value" => 1,

          #   "username" => "vagrant",
          #   "password" => "vagrant",
          #   "role" => "master"
          # }

          'apc' => {
            'system' => 'apc@localhost',
            'power_value' => 1,

            'username' => 'vagrant',
            'password' => 'vagrant',
            'role' => 'master'
          }
        }

      }
    }

    chef.run_list = ['nut::default']
  end
end
