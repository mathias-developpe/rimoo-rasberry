@echo off
REM Script d'aide pour le développement avec Docker sur Windows
REM dev-helper.bat

setlocal EnableDelayedExpansion

REM Fonction pour afficher l'aide
if "%1"=="" goto :help
if "%1"=="help" goto :help
if "%1"=="--help" goto :help
if "%1"=="-h" goto :help

REM Créer le dossier logs si nécessaire
if not exist "logs" (
    echo [INFO] Création du dossier logs...
    mkdir logs
)

REM Commands
if "%1"=="start" goto :start
if "%1"=="stop" goto :stop  
if "%1"=="restart" goto :restart
if "%1"=="shell" goto :shell
if "%1"=="logs" goto :logs
if "%1"=="build" goto :build
if "%1"=="status" goto :status
if "%1"=="clean" goto :clean
if "%1"=="prod" goto :prod

echo [ERROR] Commande inconnue: %1
goto :help

:help
echo.
echo 🐳 Rimoo Raspberry - Helper de développement Docker (Windows)
echo.
echo Usage: %0 [COMMAND]
echo.
echo Commands:
echo   start       Démarre le container de développement
echo   stop        Arrête le container de développement  
echo   restart     Redémarre le container de développement
echo   shell       Ouvre un shell dans le container
echo   logs        Affiche les logs du container
echo   build       Rebuild l'image Docker
echo   status      Affiche le statut des services
echo   clean       Nettoie les containers et images
echo   prod        Lance en mode production
echo   help        Affiche cette aide
echo.
echo Exemples:
echo   %0 start    # Démarre le container
echo   %0 shell    # Se connecte au container
echo   %0 logs     # Voir les logs
echo.
goto :end

:start
echo [INFO] === Démarrage du container de développement ===
echo [INFO] Démarrage avec docker-compose...
docker-compose up -d
if !errorlevel! equ 0 (
    echo [INFO] Attente du démarrage complet...
    timeout /t 3 >nul
    echo [INFO] Container démarré ! 🚀
    echo.
    echo 📋 Commandes utiles :
    echo   - Se connecter au container : docker exec -it rimoo-rasberry-dev /bin/bash
    echo   - Ou utilisez : %0 shell
    echo   - Voir les logs : %0 logs
    echo   - App disponible sur : http://localhost:3000
) else (
    echo [ERROR] Erreur lors du démarrage
)
goto :end

:stop
echo [INFO] === Arrêt du container de développement ===
docker-compose down
echo [INFO] Container arrêté !
goto :end

:restart
echo [INFO] === Redémarrage du container ===
docker-compose restart
echo [INFO] Container redémarré !
goto :end

:shell
echo [INFO] === Ouverture d'un shell dans le container ===
REM Vérifier si le container est en cours d'exécution
docker ps -q -f name=rimoo-rasberry-dev >nul 2>&1
if !errorlevel! neq 0 (
    echo [WARNING] Container non démarré. Démarrage en cours...
    call :start
    timeout /t 2 >nul
)
echo [INFO] Connexion au container...
docker exec -it rimoo-rasberry-dev /bin/bash
goto :end

:logs
echo [INFO] === Logs du container ===
docker-compose logs -f
goto :end

:build
echo [INFO] === Reconstruction de l'image Docker ===
docker-compose build --no-cache
echo [INFO] Image reconstruite !
goto :end

:status
echo [INFO] === Statut des services ===
docker-compose ps
echo.
REM Vérifier le statut des services dans le container
docker ps -q -f name=rimoo-rasberry-dev >nul 2>&1
if !errorlevel! equ 0 (
    echo [INFO] Services dans le container :
    docker exec rimoo-rasberry-dev supervisorctl status 2>nul || echo [WARNING] Supervisor pas encore démarré
)
goto :end

:clean
echo [INFO] === Nettoyage des containers et images ===
echo [WARNING] Ceci va arrêter et supprimer les containers...
set /p confirm="Êtes-vous sûr ? (y/N) "
if /i "!confirm!"=="y" (
    docker-compose down --rmi local --volumes
    echo [INFO] Nettoyage terminé !
) else (
    echo [INFO] Nettoyage annulé.
)
goto :end

:prod
echo [INFO] === Lancement en mode production ===
docker-compose --profile production up -d app-prod
echo [INFO] Mode production lancé !
goto :end

:end
endlocal 