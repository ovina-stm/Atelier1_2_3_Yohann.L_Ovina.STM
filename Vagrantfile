# -- mode: ruby --
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  config.vm.define "Mon_Vagrant" do |atelier1|
    atelier1.vm.box = "generic/ubuntu2204"
    atelier1.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = 2
    end
  
    atelier1.vm.network "public_network"
  

    atelier1.vm.provision "shell", inline: <<-SHELL
      sudo loadkeys fr
      sudo localectl set-keymap fr
      sudo apt-get update -y && sudo apt-get upgrade -y
      curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
      sudo apt-get install -y gitlab-ee
      # Installer les dépendances nécessaires
      sudo apt-get install -y curl openssh-server ca-certificates tzdata perl
      sudo sed -i "s|external_url 'http://gitlab.example.com'|external_url 'http://localhost'|" /etc/gitlab/gitlab.rb
      sudo sed -i "/# registry_external_url/c\\registry_external_url 'http://localhost:8081'" /etc/gitlab/gitlab.rb
      sudo gitlab-ctl reconfigure
    SHELL
  end
end