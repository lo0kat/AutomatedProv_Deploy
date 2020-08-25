# Installation et configuration des serveurs

### Proxmox
Le déploiement des machines virtuelles s'effectue sur un serveur physique sur lequel est installé Proxmox VE. Pour plus d'informations concernant l'installation de Proxmox, consulter le lien [suivant](https://pve.proxmox.com/wiki/Installation). L'adresse IP de ce serveur sera à renseigner dans les fichiers de configuration des outils.

##### Création d'un utilisateur pour l'API Proxmox
Il faut créer un utilisateur pour que Packer et Terraform puissent s’authentifier à l’API de Proxmox. 
Pour cela, en utilisant l’interface web, chercher dans **Datacenter -> Permissions**.
- Ajouter un nouveau rôle “**packer**” avec tous les droits. 
- Ajouter un utilisateur “**packer**” (type **pve**).
- Dans **Permissions** ajouter le role packer à l’utilisateur packer avec comme Path : “**/**”.

- Ne pas oublier de modifier le mot de passe (**Datacenter -> Permissions -> Users -> Password**) de l’utilisateur pour que l’authentification avec l’API puisse fonctionner.

**_Important_** : Le mot de passe devra être précieusement conservé car indispensable dans les fichiers de configuration.
### Serveurs
Le trio Packer/Terraform/Ansible est installé sur une ou plusieurs machines (physiques ou virtuelles) sous **Debian** et possédant un client **Git**.

### Packer
##### Installation
Remplacer "**${PACKER_RELEASE}**" et "**{PACKER_RELEASE}**" par le **numéro** de la dernière version que l'on peut trouver en visitant la [rubrique Download](https://www.packer.io/downloads) du site dédié à Packer (Ex: Current version : **1.6.1**).

```sh
$ cd /tmp/

$ wget https://releases.hashicorp.com/packer/{PACKER_RELEASE}/packer_${PACKER_RELEASE}_linux_amd64.zip

$ unzip packer_${PACKER_RELEASE}_linux_amd64.zip

$ sudo mv packer /usr/local/bin

```
Pour tester le bon fonctionnement de Packer :
```sh
$ packer --version
```

### Terraform
##### Installation
Similaire à celle de Packer : on télécharge le fichier zip puis on déplace le fichier binaire dézippé dans /**usr/local/bin**. Ensuite on rend le fichier binaire disponible dans le PATH. Pour plus d'information voir [ici](https://learn.hashicorp.com/terraform/getting-started/install.html).

##### Terraform proxmox provider
Proxmox n'étant pas un provider officiel, il est nécessaire d'installer manuellement l'implémentation maintenue par la communauté et disponible sur [https://github.com/Telmate/terraform-provider-proxmox](https://github.com/Telmate/terraform-provider-proxmox). Se référer à la documentation présente sur le dépôt pour son installation.  
### Ansible
##### Installation

S'assurer de la présence de Python sur la machine puis ajouter la ligne suivante à  **/etc/apt/sources.list** : 
``` sh
deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main 
```
Effectuer ensuite les commandes ci-dessous :
``` sh
$ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367

$ sudo apt update

$ sudo apt install ansible 
```