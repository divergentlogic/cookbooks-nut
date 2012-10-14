# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.define :squeeze do |squeeze_config|
    squeeze_config.vm.box = "squeeze"
    squeeze_config.vm.box_url = "http://puppetlabs.s3.amazonaws.com/pub/squeeze64.box"
  end

  config.vm.define :precise do |precise_config|
    precise_config.vm.box = "precise"
    precise_config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  end

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks"]
    chef.add_recipe "nut"
    chef.json = {
    	"nut" => {
    	  "mode" => "standalone",

    	  "devices" => ["ttyS0"],

    	  "ups" => {
    	    'cyberpower' => {
    	      "driver" => "powerpanel",
            "port" => "/dev/ttyS0",
            "desc" => "Cyberpower CP1500AVR"
          }
        },

        "users" => {
          "vagrant" => {
            "password" => "vagrant",
            "upsmod master" => true
          }
        },

        "monitors" => {
          "cyberpower" => {
            "system" => "cyberpower@localhost",
            "power_value" => 1,

            "username" => "vagrant",
            "password" => "vagrant",
            "role" => "master"
          }
        }

      }
    }
   end
end
