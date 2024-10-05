## PRÉREQUIS :

- VirtualBox 7.0 ou versions en dessous.
- Vagrant version 2.4.1


## INITIALISATION DE LA BOX UBUNTU :

Pour commencer nous avons ouvert le cmd et avons utilisé la commande `vagrant init generic /ubuntu2204` pour initialiser le répertoire courant en générant la création du fichier vagrantfile.

Ensuite nous avons ajouté cette ligne `config.vm.box = "generic/ubuntu2204"` : 
Cette ligne indique à Vagrant d'utiliser l'image (ou "box") nommée `"generic/ubuntu2204"`, qui correspond à une machine virtuelle Ubuntu 22.04. Cela permet d'installer et de configurer cette version d'Ubuntu comme environnement de développement.


## CONFIGURATION DU SCRIPT pour configurer la VM SUR VAGRANTFILE :

`Vagrant.configure("2") do |config|` : Démarre la configuration de Vagrant avec la version 2 de l'API.

`config.vm.define "Mon_Vagrant" do |atelier1|` : Crée une nouvelle machine virtuelle nommée Mon_Vagrant. atelier1 est utilisé pour la configurer.

`atelier1.vm.box = "generic/ubuntu2204"` : Utilise l'image Ubuntu 22.04 pour créer la machine virtuelle.

`'atelier1.vm.provider "virtualbox" do |vb|` : Spécifie que VirtualBox est le fournisseur de virtualisation à utiliser (virtualbox est le fournisseur utilisé par défaut).

`vb.memory = "4096"` : Alloue 4 Go de RAM à la machine virtuelle.

`vb.cpus = 2` : Assigne 2 cœurs de processeur à la machine virtuelle.

`end` : pour fermer le bloc de configuration de vagrant.

`atelier1.vm.network "public_network",` : configure la vm pour utiliser un réseau public.


## CONFIGURATION DU SCRIPT POUR TÉLÉCHARGER ET CONFIGURER GITLAB :

Ici, on ne fait que configurer avec vagrant un objet `config`qui utilise une image `ubuntu`

`atelier1.vm.provision "shell", inline: <<-SHELL` : permet d’exécuter le script shell qui correspond aux lignes suivantes :

`sudo loadkeys fr` : cette commande configure de la machine virtuelle en Azerty car elle est e Qwerty par défaut

`sudo localectl set-keymap fr` : Cette commande  ajuste la configuration locale du clavier de manière à ce qu’elle soit défini en Français sur localectl. Cela permettra au clavier de rester en Français même après le redémarrage.

`sudo apt-get update -y && sudo apt-get upgrade -y`: permet de mettre à jour la liste de paquets disponible (apt-get update) et met à jour tous les paquets installés vers leur dernières versions (apt-get upgrade). L’option -y permet une confirmation automatique ce qui signifie que la présence de l’utilisateur n’est pas requise pour finaliser l’installation.

`curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash` : télécharge et exécute un script de configuration pour installer GitLab EE depuis les dépôts GitLab officiels. La partie sudo  bash est permet d’exécuter le script en bash avec les privilèges administrateurs.

`sudo apt-get install -y gitlab-ee` : permet d’installer gitlab-ee, sans demander de confirmation à l’utilisateur (grâce à l’option -y).

`sudo apt-get install -y curl openssh-server ca-certificates tzdata perl` : installe des outils supplémentaires comme SSH, certificats SSL, fuseaux horaires, et le langage Perl.

`sudo sed -i "s|external_url 'http://gitlab.example.com'|external_url 'http://localhost'|" /etc/gitlab/gitlab.rb` : modifie le fichier de configuration gitlab.rb, pour rendre Gitlab accessible via http://localhost au lieu de http://gitlab/example.com sur la machine virtuelle

`sudo sed -i "/# registry_external_url/c\\registry_external_url 'http://localhost:8081'" /etc/gitlab/gitlab.rb` : Cette commande décommente et modifie la ligne dans le fichier de configuration pour activer le **GitLab Container Registry** et le configurer pour être accessible via `http://localhost:8081`. Le port **8081** est utilisé pour le registre de conteneurs.

`sudo gitlab-ctl reconfigure` : Permet de reconfigurer GitLab et applique toutes les modifications apportées dans le fichier gitlab.rb et démarre ou redémarre les services de Gitlab nécessaires.

`end` : Permet de fermer le bloc de configuration de vagrant.

Après avoir effectué la modification de vagranfile avec les lignes de scripts rédigés ci-dessus, nous avons utilisé la commande `vagrant up` dans le terminal, cette commande permet de créer et configurer la machine virtuelle en fonction de notre fichier vagrantfile.


## COMMANDES DU TERMINAL POUR GÉRER L'ÉTAT DE LA MACHINE :
 
 `vagrant up` : démarre la machine virtuelle.
 `vagrant  reload` : redémarre la machine en appliquand les nouvelles configurations du vagrantfile.
 `vagrant hault` : arrêtre la machine virtuelle.
 `vagrant destroy` : supprime la machine virtuelle.


## COMMANDE DE VERIFICATION A UTILISER DANS LE TERMINAL :

Dans le but de vérifier le bon fonctionnement de Gitlab et que nos installations se sont déroulés sans encombre avons effectué des tests dans le terminal de notre machine virtuelle avec les commandes suivantes :

`sudo gitlab-ctl status` : affiche l'état des services GitLab sur une instance auto-hébergée.

`sudo curl -I http://localhost:8081` : permet de vérifier si le serveur sur le port 8081 est actif et ses informations.

`sudo gitlab-rake gitlab:env:info` : affiche des informations détaillées sur l'environnement et la configuration de GitLab.


## VÉRIFICATION ET CONNEXION VIA L'INTERFACE WEB :

Pour pouvoir se connecter à gitlab via un navigateur web il faut rentrer l'adresse IP de la machine virtuelle dans un navigateur de recherche de la machine hôte (google chrome par exemple).
Cela nous redirigera vers le serveur Gitlab de la VM. Il faut ensuite entrer les informations de connexions : le nom d'utilisateur est **root** et le mot de passe est **l2D8LQ3VoHgFLK3IMNUlvME8PEArINM=** (on le trouve dans le fichier de la machine virtuelle qui est situé dans  /etc/gitlab/init_password_root, il faut donc utiliser la commande `nano /etc/gitlab/init_password_root` en ligne de commande dans le vm pour pouvoir ouvrir ce fichier).


## CONCLUSION :


En conclusion, ce script Vagrant permet de créer et configurer de manière entièrement automatisée une machine virtuelle Ubuntu 22.04 avec GitLab EE préinstallé et fonctionnel. 
Grâce à un fichier Vagrantfile bien structuré, nous avons pu automatiser la configuration réseau, l’installation des dépendances, et la personnalisation de GitLab.
