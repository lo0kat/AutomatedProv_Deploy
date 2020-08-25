# Déploiement automatique et provisionnement d'infrastructures virtuelles sur Proxmox


### Introduction
L'Infrastructure As Code (**_IAC_**) se présente comme une solution intéressante pour répondre aux besoins grandissants de ressources nécessaires au fonctionnement des applications. Ce projet se focalise essentiellement sur la génération d'une image machine ( template **Ubuntu 18-04 server**), le déploiement de machines virtuelles (clones du template) sur un hyperviseur, l'installation et la configuration de logiciels (**apache**, **mysql**, **phpmyadmin** ...) sur un ensemble de machines.


### Technologies utilisées 
Le projet s'appuie sur plusieurs technologies Open source :

* [**Proxmox**](https://proxmox.com/en/) - solution de virtualisation libre basée sur l'hyperviseur Linux KVM.
* [**Packer**](https://www.packer.io/) - outil de génération d'images machine.
* [**Terraform**](https://www.terraform.io/) - outil d'automatisation de construction de ressources.
* [**Ansible**](https://www.ansible.com/) - plate-forme logicielle libre pour la configuration et la gestion des machines.


### Installation

Voir [la documentation concernant l'installation et la configuration des serveurs](Docs/Installation_setup.md).

### Code
L'exécution du code d'un des outils (Packer | Terraform | Ansible) nécessite, au préalable, de se placer  dans le dossier correspondant. 
Le dépôt se présente sous la forme suivante :
> **Packer**
- config_var . json   (Fichier de variables)
 - ubuntu18-04-3tmp . json (Description du template)
- preseed_http (Dossier preseed pour le serveur http)


>**Terraform** 
- main . tf (Description des clones)
- var_cfg . tfvars (Fichier de variables)

>**Ansible**
- ssh_keysadd . yml (Déclaration d'un role pour l'ajout de la clé ssh publique du serveur Ansible )
- setup_main . yml (Déclaration des roles pour les logiciels à installer et à configurer )
- static_inv . ini (Inventaire des machines)
- roles (Dossier décrivant les rôles)

_**Important** : Les champs contenant "##" (ex : "##your_ip" se transforme en "192.168.1.90") sont à modifier pour correspondre à l'environnement de travail. Certains mots de passe et noms d'utilisateur étant cryptés (valeur commençant par !vault), il faudra suivre la [démarche suivante](Docs/Ansible_vault.md) pour en générer de nouveaux avec Ansible-Vault._
###  1] Packer 

##### Commandes (à effectuer dans le répertoire Packer)
- Valider la syntaxe du template :
```sh
$ packer validate -var-file="./config_var.json" ./ubuntu18-04-3tmp.json
```

- Construction du template :
```sh
$ packer build -var-file="./config_var.json" ./ubuntu18-04-3tmp.json
```

A la fin de la construction, une connection SSH au serveur Proxmox sera effectuée, il faudra donc renseigner le mot de passe root plusieurs fois pour que le serveur puisse effectuer les réglages nécessaires à **Cloud-Init** (allocation espace disque etc..).

### 2] Terraform

##### Commandes (à effectuer dans le répertoire Terraform)
- Initialiser le dossier de travail :
```sh
$ terraform init
```
- Afficher le plan des changements à appliquer :
```sh
$ terraform plan -var-file=”var_cfg.tfvars”
```
- Appliquer le plan de déploiement des ressources :
```sh
$ terraform apply -var-file=”var_cfg.tfvars” -parallelism=1
```

### 3] Ansible

##### Inventaire
Modifier les adresses IP dans l'inventaire (**static_inv.ini**) pour qu'elles puissent correspondre à l'environnement de travail.

##### Commandes (à effectuer dans le répertoire Ansible)
- Ajouter la clé publique ssh aux machines distantes :
```sh
$ ansible-playbook -i static_inv.ini ssh_keysadd.yml --ask-vault-pass --ask-pass
```
- Installation et configuration des logiciels (mysql, apache, phpmyadmin ... ) :
```sh
$  ansible-playbook -i static_inv.ini setup_main.yml --ask-vault-pass 
```

### Sources
- Template Ubuntu Server /Proxmox avec Packer : https://dev.to/aaronktberry/creating-proxmox-templates-with-packer-1b35

- Rôles Ansible : https://devopssec.fr/article/roles-ansible

- Documentation Ansible : https://docs.ansible.com/

### Auteur
Louis CHOMEL