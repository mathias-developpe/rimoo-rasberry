#!/bin/bash

# Script d'aide pour le développement avec Docker
# dev-helper.sh

set -e

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction pour afficher les messages colorés
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_section() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

# Fonction d'aide
show_help() {
    echo "🐳 Rimoo Raspberry - Helper de développement Docker"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  start       Démarre le container de développement"
    echo "  stop        Arrête le container de développement"
    echo "  restart     Redémarre le container de développement"
    echo "  shell       Ouvre un shell dans le container"
    echo "  logs        Affiche les logs du container"
    echo "  build       Rebuild l'image Docker"
    echo "  status      Affiche le statut des services"
    echo "  clean       Nettoie les containers et images"
    echo "  prod        Lance en mode production"
    echo "  help        Affiche cette aide"
    echo ""
    echo "Exemples:"
    echo "  $0 start    # Démarre le container"
    echo "  $0 shell    # Se connecte au container"
    echo "  $0 logs     # Voir les logs"
}

# Créer le dossier logs s'il n'existe pas
create_logs_dir() {
    if [ ! -d "./logs" ]; then
        print_status "Création du dossier logs..."
        mkdir -p ./logs
    fi
}

# Démarre le container de développement
start_dev() {
    print_section "Démarrage du container de développement"
    create_logs_dir
    
    print_status "Démarrage avec docker-compose..."
    docker-compose up -d
    
    print_status "Attente du démarrage complet..."
    sleep 3
    
    print_status "Container démarré ! 🚀"
    echo ""
    echo "📋 Commandes utiles :"
    echo "  - Se connecter au container : docker exec -it rimoo-rasberry-dev /bin/bash"
    echo "  - Ou utilisez : $0 shell"
    echo "  - Voir les logs : $0 logs"
    echo "  - App disponible sur : http://localhost:3000"
}

# Arrête le container
stop_dev() {
    print_section "Arrêt du container de développement"
    docker-compose down
    print_status "Container arrêté !"
}

# Redémarre le container
restart_dev() {
    print_section "Redémarrage du container"
    docker-compose restart
    print_status "Container redémarré !"
}

# Ouvre un shell dans le container
shell_dev() {
    print_section "Ouverture d'un shell dans le container"
    if [ ! "$(docker ps -q -f name=rimoo-rasberry-dev)" ]; then
        print_warning "Container non démarré. Démarrage en cours..."
        start_dev
        sleep 2
    fi
    
    print_status "Connexion au container..."
    docker exec -it rimoo-rasberry-dev /bin/bash
}

# Affiche les logs
logs_dev() {
    print_section "Logs du container"
    docker-compose logs -f
}

# Rebuild l'image
build_dev() {
    print_section "Reconstruction de l'image Docker"
    docker-compose build --no-cache
    print_status "Image reconstruite !"
}

# Affiche le statut
status_dev() {
    print_section "Statut des services"
    docker-compose ps
    
    if [ "$(docker ps -q -f name=rimoo-rasberry-dev)" ]; then
        print_status "Services dans le container :"
        docker exec rimoo-rasberry-dev supervisorctl status 2>/dev/null || print_warning "Supervisor pas encore démarré"
    fi
}

# Nettoie les containers et images
clean_dev() {
    print_section "Nettoyage des containers et images"
    print_warning "Ceci va arrêter et supprimer les containers..."
    read -p "Êtes-vous sûr ? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker-compose down --rmi local --volumes
        print_status "Nettoyage terminé !"
    else
        print_status "Nettoyage annulé."
    fi
}

# Lance en mode production
prod_dev() {
    print_section "Lancement en mode production"
    create_logs_dir
    docker-compose --profile production up -d app-prod
    print_status "Mode production lancé !"
}

# Script principal
case "$1" in
    start)
        start_dev
        ;;
    stop)
        stop_dev
        ;;
    restart)
        restart_dev
        ;;
    shell)
        shell_dev
        ;;
    logs)
        logs_dev
        ;;
    build)
        build_dev
        ;;
    status)
        status_dev
        ;;
    clean)
        clean_dev
        ;;
    prod)
        prod_dev
        ;;
    help|--help|-h)
        show_help
        ;;
    "")
        show_help
        ;;
    *)
        print_error "Commande inconnue: $1"
        show_help
        exit 1
        ;;
esac 