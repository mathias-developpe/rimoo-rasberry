#!/bin/bash

# ==============================================================================
# RIMOO RASPBERRY - SCRIPT DE DÉPLOIEMENT SYSTÈME
# ==============================================================================

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LOG_FILE="/var/log/rimoo/deploy.log"

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# ==============================================================================
# FONCTIONS UTILITAIRES
# ==============================================================================

log() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log_info() {
    log "${BLUE}[INFO]${NC} $1"
}

log_success() {
    log "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    log "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    log "${RED}[ERROR]${NC} $1"
}

# Vérifier les prérequis
check_prerequisites() {
    log_info "Vérification des prérequis..."
    
    # Vérifier qu'on est root ou qu'on a sudo
    if [[ $EUID -ne 0 ]] && ! sudo -n true 2>/dev/null; then
        log_error "Ce script doit être exécuté avec les privilèges root ou sudo"
        exit 1
    fi
    
    # Vérifier qu'Ansible est installé
    if ! command -v ansible-playbook &> /dev/null; then
        log_warning "Ansible n'est pas installé, installation..."
        sudo apt update
        sudo apt install -y ansible
    fi
    
    # Vérifier qu'on est dans le bon répertoire
    if [[ ! -f "$SCRIPT_DIR/playbook.yml" ]]; then
        log_error "Le playbook Ansible n'a pas été trouvé dans $SCRIPT_DIR"
        exit 1
    fi
    
    log_success "Prérequis OK"
}

# Installation initiale
initial_setup() {
    log_info "=== INSTALLATION INITIALE ==="
    
    cd "$SCRIPT_DIR"
    
    # Lancer le playbook Ansible
    log_info "Exécution du playbook Ansible..."
    ansible-playbook -i inventory playbook.yml --ask-become-pass
    
    log_success "Installation initiale terminée"
}

# Mise à jour du système
update_system() {
    log_info "=== MISE À JOUR DU SYSTÈME ==="
    
    cd "$SCRIPT_DIR"
    
    # Lancer seulement les tâches de mise à jour
    log_info "Exécution des tâches de mise à jour..."
    ansible-playbook -i inventory playbook.yml --ask-become-pass --tags "update"
    
    log_success "Mise à jour terminée"
}

# Vérifier le statut du système
check_status() {
    log_info "=== VÉRIFICATION DU STATUT ==="
    
    # Vérifier les services
    local services=("rimoo-app" "rimoo-service1" "rimoo-service2" "rimoo-autodeploy.timer" "nginx")
    
    for service in "${services[@]}"; do
        if systemctl is-active "$service" &> /dev/null; then
            log_success "✓ $service: ACTIF"
        else
            log_error "✗ $service: INACTIF"
        fi
    done
    
    # Vérifier les ports
    local ports=("3000" "80" "22")
    
    for port in "${ports[@]}"; do
        if netstat -tlnp | grep -q ":$port "; then
            log_success "✓ Port $port: OUVERT"
        else
            log_warning "⚠ Port $port: FERMÉ"
        fi
    done
    
    # Afficher les logs récents
    log_info "Logs récents du déploiement automatique:"
    if [[ -f /var/log/rimoo/autodeploy.log ]]; then
        tail -5 /var/log/rimoo/autodeploy.log | while read line; do
            log_info "  $line"
        done
    fi
    
    log_success "Vérification terminée"
}

# Afficher l'aide
show_help() {
    cat << EOF
Usage: $0 [OPTION]

Options:
  install    Installation initiale complète du système
  update     Mise à jour du système existant
  status     Vérifier le statut des services
  logs       Afficher les logs récents
  help       Afficher cette aide

Exemples:
  $0 install    # Installation complète
  $0 update     # Mise à jour du système
  $0 status     # Vérifier le statut

EOF
}

# Afficher les logs
show_logs() {
    log_info "=== LOGS RÉCENTS ==="
    
    local log_files=(
        "/var/log/rimoo/autodeploy.log"
        "/var/log/rimoo/monitor.log"
        "/var/log/rimoo/backup.log"
    )
    
    for log_file in "${log_files[@]}"; do
        if [[ -f "$log_file" ]]; then
            log_info "--- $(basename "$log_file") ---"
            tail -10 "$log_file" | while read line; do
                echo "  $line"
            done
            echo
        fi
    done
}

# ==============================================================================
# FONCTION PRINCIPALE
# ==============================================================================

main() {
    # Créer le répertoire de logs
    sudo mkdir -p "$(dirname "$LOG_FILE")"
    
    case "${1:-help}" in
        install)
            log_info "=== DÉBUT DE L'INSTALLATION ==="
            check_prerequisites
            initial_setup
            check_status
            log_success "=== INSTALLATION TERMINÉE ==="
            ;;
        update)
            log_info "=== DÉBUT DE LA MISE À JOUR ==="
            check_prerequisites
            update_system
            check_status
            log_success "=== MISE À JOUR TERMINÉE ==="
            ;;
        status)
            check_status
            ;;
        logs)
            show_logs
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            log_error "Option inconnue: $1"
            show_help
            exit 1
            ;;
    esac
}

# ==============================================================================
# EXÉCUTION
# ==============================================================================

main "$@" 