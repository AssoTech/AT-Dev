# ACT-Dev



ACT-Dev est un environnement de développement construit à partir de conteneurs Docker, comprenant les serveurs Apache2 et MariaDB, un interpréteur PHP et phpMyAdmin pour l'administration des base MariaDB. D'autres applications sont mises à disposition, comme composer.

Il est conçu pour être installé sur MacOS, Linux ou Windows, en offrant les mêmes fonctionnalités pour chacune des trois plateformes, à la manière d'un serveur Ubuntu. Ainsi, la structure de base s'inspire d'une arborescence standard Unix/Linux :
- les répertoires courants : `/bin`, `/etc`, `/sbin` et `/var`, pour les exécutables, la configuration, les bases de données, logs, et sites,
- le répertoire `/home`, pour les fichiers de configuration d'un utilisateur, répertoire pouvant être monté dans les conteneurs Docker,
- le répertoire `/docs`, pour diverses documentations,
- le répertoire `/src`, pour la configuration des conteneurs Docker.

Cet environnement a été prévu pour être utilisé dans le cadre de cours sur les bases de données et plus généralement le développement web, ce qui conduit à des choix de normalisation de l'installation afin de garantir une homogénéité sur un groupe d'étudiants. Par contre, la configuration des différents serveurs, Apache, PHP… est totalement modifiable comme dans sur un vrai serveur Ubuntu physique ou virtualisé. Cette configuration est simplement simplifiée, car seuls les répertoires utiles sont reproduits dans `/etc`.



