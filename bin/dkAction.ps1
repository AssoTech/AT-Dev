##########################################################################################
# Script de gestion d'actions diverses avec docker
#
#                                                                     MD 12-20-2021 23:29
##########################################################################################
# À voir
#   -> configuration php-fpm
#   -> fichier secrets sous Windows
##########################################################################################


function usage($cmdArgs) {	
    if ( $cmdArgs[0] -eq "-h" ) {
		echo "Usage: $PSCommandPath"
        echo "          up | start | stop | down |"
        echo "          contPhpJumpIn | contMariaDBJumpIn | contApacheJumpIn | contPhpMyAdminJumpIn |"
        echo "          install | clean | purge |"
        echo "          bye"
        echo "Au revoir..."
        exit 1
	}
}

function testCmdeValide($cmd) {
	$cmds = @('up','down','start','stop',
	          'contPhpJumpIn','contMariaDBJumpIn',
			  'contApacheJumpIn','contPhpMyAdminJumpIn',
			  'install','clean','purge',
			  'bye')

	return $cmds.Contains($cmd)
}






# bibliothèque de fonctions
###############################



##########################################################################################
# Partie principale
##########################################################################################

usage($args)
if ( (testCmdeValide($args[0])) -eq $false ) {
	echo "Veuillez choisir quelle action lancer :"
    echo "    1  - Regénérer les conteneurs principaux              -> up"
    echo "    2  - Démarrer les conteneurs principaux               -> start"
    echo "    3  - Arrêter les conteneurs principaux                -> stop"
    echo "    4  - Down pour les conteneurs principaux              -> down"
    echo "   10  - Rentrer dans cci-dev_php-fpm                     -> contPhpJumpIn"
    echo "   11  - Rentrer dans cci-dev_mariadb                     -> contMariaDBJumpIn"
    echo "   12  - Rentrer dans cci-dev_httpd                       -> contApacheJumpIn"
    echo "   13  - Rentrer dans cci-dev_phpmyadmin                  -> contPhpMyAdminJumpIn"
    echo "   50  - Première configuration                           -> install"
    echo "   51  - Nettoyage de l'inutile dans docker               -> clean"
    echo "   52  - Purger totalement docker                         -> purge"
    echo "    0  - Rien !"
    $choix = Read-Host("Votre choix : ")
	Switch ( $choix ) { 
		1 { $cmde = "up" }
         2 { $cmde = "start" }
         3 { $cmde = "stop" }
         4 { $cmde = "down" }
        10 { $cmde = "contPhpJumpIn" }  
        11 { $cmde = "contMariaDBJumpIn" }
        12 { $cmde = "contApacheJumpIn" }
        13 { $cmde = "contPhpMyAdminJumpIn" }
        50 { $cmde = "install" }
        51 { $cmde = "clean" }
        52 { $cmde = "purge" }
		Default { $cmde = "bye" } } 
		}
else {
	$cmde = $args[0]
	$null, $args = $args 
}

if ( $cmde -eq "install" ) 
{
	echo "Mise en place des variables d'environnement…"
	$cheminBin = $pwd.Path
	if ( $cheminBin.EndsWith('bin') ) {
		$cheminBase = $cheminBin.Substring(0, $cheminBin.Length - 4)
        $env:CCI_dev_BASE = $cheminBase
        [Environment]::SetEnvironmentVariable("CCI_dev_BASE", $cheminBin, [System.EnvironmentVariableTarget]::User) 
        $OLDPATH = [System.Environment]::GetEnvironmentVariable('PATH','machine')
        $PATH = "$OLDPATH;$cheminBase"
        [Environment]::SetEnvironmentVariable("PATH", "$PATH", "User")
        echo "Veuillez démarrer avec $PSCommandPath up"
	}
    else
    {
		echo "CCI-dev n'a pas pu être installé, car la commande dkAction install n'a pas été lancée à partir du répertoire cci-dev/bin"
	}
} 
elseif ( -Not (Test-Path $env:CCI_dev_BASE)) {
	echo "Il faut d'abord lancer dkAction install à partir du répertoire cci-dev/bin, avant de pouvoir utiliser CCI-dev…" 
} 
else {
	Switch  ( $cmde ) { 
		"up" { 
            echo "Regénération des conteneurs"
            docker-compose -f "$Env:CCI_dev_BASE/src/docker-compose.yml" build --pull
            docker-compose -f "$Env:CCI_dev_BASE/src/docker-compose.yml" up -d
        }
		"start" { 
            echo "Lancement des conteneurs docker"
            docker start cci-dev_mariadb cci-dev_httpd cci-dev_php-fpm
        }
		"stop" { 
            echo "Arrêt des conteneurs docker"
            docker stop cci-dev_mariadb cci-dev_httpd cci-dev_php-fpm
        }
		"down" { 
            echo "Down pour les conteneurs"
            docker-compose -f "$Env:CCI_dev_BASE/src/docker-compose.yml" down
        }
		"contPhpJumpIn" { 
			docker exec -it cci-dev_php-fpm /bin/bash 
		}
		"contMariaDBJumpIn" {
			docker exec -it cci-dev_mariadb /bin/bash
		}
		"contApacheJumpIn" { 
			docker exec -it cci-dev_httpd /bin/bash
		}
		"contPhpMyAdminJumpIn" {
			docker exec -it cci-dev_phpmyadmin /bin/bash
		}
		"clean" { # Nettoyage de l'inutile dans docker
			echo "Nettoyage de Docker…"
            docker container prune -f
            docker image prune -f
            docker volume prune -f
            docker network prune -f
		}
		"purge" { # Supprimer tout dans docker
			echo "Faut-il vraiment tout supprimer dans docker ?"
			$confirmation = Read-Host( "O pour confirmer, Ov pour confirmer avec suppression des volumes : ")
			if ( $confirmation.StartsWith('O')) {
                docker ps -aq | foreach {docker stop $_}
                docker ps -aq | foreach {docker rm -f $_} 
                docker images -q | foreach {docker rmi -f $_} 
                docker network ls -f type=custom -q  | foreach { docker network rm $_ }  
                if ( $confirmation -eq "Ov" ) {
                    docker volume ls -q | foreach { docker volume rm $_ }  
                }
                echo "Docker est totalement vide, maintenant…"
            }
            else {
                echo "Ouf…"
            }
		

		}
		"bye" { echo "Au revoir..." }
		Default { echo "--> Attention : je ne sais pas quoi faire avec $cmde,"
		          echo "      donc je m'en vais !" }
		
	}
}