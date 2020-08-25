# Utilisation d'Ansible-Vault
##### Ansible-Vault
Ansible-Vault est une fonctionnalité d'Ansible permettant de crypter des fichiers ou des chaines de caractères. Pour plus d'informations, voir  [la documentation officielle d'Ansible-Vault](https://docs.ansible.com/ansible/latest/user_guide/vault.html).
##### Cryptage d'une variable dans un fichier

Pour crypter une chaine de caractères (toto64) : 
```sh
$ ansible-vault encrypt_string toto64
```

Un mot de passe de cryptage vous sera demandé. Il est **essentiel** de le retenir car celui-ci vous sera demandé à chaque exécution du playbook concerné. Le résultat obtenu est de la forme suivante : 
``` sh
!vault |
          $ANSIBLE_VAULT;1.1;AES256
          31353961643764393666343461383463666531376335396330303562633932316436323636353231
          3035656333613132393165346239346434313439336433320a323734363661663766313464343838
          33353262613838303931636635343235313733313335623134336438316232643637623864393961
          6664353034653936370a383934613930663031303164663938303463343332646433316664396231
          6164

````

Copier le contenu du résultat (ci-dessus) et coller dans la variable que vous souhaitez crypter. Le decryptage se fera uniquement en mémoire lors de l'exécution d'un playbook lorsque l'on renseigne l'option **--ask-vault-pass** . Il est possible de gérer plusieurs mots de passe pour plusieurs variables cryptées mais le plus simple est d'utiliser le meme mot de passe de cryptage pour toutes les variables.