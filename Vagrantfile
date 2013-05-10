# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.provision :chef_solo do |chef|
    chef.json = {
      apache: {
        default_site_enabled: true,
        default_modules: ["mod_deflate", "mod_headers", "mod_php5", "mod_rewrite"],
      },
      mysql: {
        server_root_password: "password",
        server_repl_password: "password",
        server_debian_password: "password",
      },
    }
    chef.cookbooks_path = "cookbooks"
    chef.add_recipe "apt"
    chef.add_recipe "apache2"
    chef.add_recipe "build-essential"
    chef.add_recipe "git"
    chef.add_recipe "mysql"
    chef.add_recipe "mysql::server"
    chef.add_recipe "php"
    chef.add_recipe "php-modules"
    chef.add_recipe "vim"
  end
  config.vm.provision :shell, :path => "bootstrap-sugarcrm.sh"
end
