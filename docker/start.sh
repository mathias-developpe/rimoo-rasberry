#!/bin/bash
# start.sh

# Créer les répertoires de logs si ils n'existent pas
mkdir -p /var/log

# Démarrer supervisord pour gérer les processus
echo "Démarrage de supervisord..."
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf

# Vérifier si supervisord a démarré correctement
if [ $? -eq 0 ]; then
    echo "Supervisord démarré avec succès"
else
    echo "Erreur lors du démarrage de supervisord"
    exit 1
fi

# Attendre que supervisord démarre et que les processus soient lancés
sleep 5

# Afficher le statut des processus
echo "Statut des processus:"
supervisorctl status

# Garder le conteneur en vie en attendant la terminaison de tous les processus gérés par supervisord
wait 