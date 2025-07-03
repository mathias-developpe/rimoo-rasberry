# 🚀 Système de Déploiement Automatique - Rimoo Raspberry

Ce système permet de gérer automatiquement la configuration complète de votre Raspberry Pi via Git et Ansible.

## ✨ Fonctionnalités

- **🔄 Déploiement automatique** : Mise à jour automatique depuis Git toutes les 5 minutes
- **📊 Monitoring système** : Surveillance continue des ressources et services
- **💾 Sauvegarde automatique** : Backup quotidien des configurations et données
- **🔒 Sécurité** : Configuration automatique du firewall et fail2ban
- **🌐 Proxy Web** : Configuration automatique de nginx
- **📝 Logging** : Logs centralisés et rotation automatique

## 🛠️ Installation

### 1. Prérequis

```bash
# Mettre à jour le système
sudo apt update && sudo apt upgrade -y

# Installer Git si nécessaire
sudo apt install -y git
```

### 2. Installation initiale

```bash
# Se placer dans le répertoire du projet
cd /home/mathias/Desktop/rimoo-rasberry

# Lancer l'installation
sudo ./system-config/deploy.sh install
```

### 3. Vérification

```bash
# Vérifier le statut des services
./system-config/deploy.sh status

# Voir les logs récents
./system-config/deploy.sh logs
```

## 🔧 Utilisation

### Commandes principales

```bash
# Installation complète
sudo ./system-config/deploy.sh install

# Mise à jour du système
sudo ./system-config/deploy.sh update

# Vérifier le statut
./system-config/deploy.sh status

# Voir les logs
./system-config/deploy.sh logs
```

### Services créés

Le système crée automatiquement ces services systemd :

- `rimoo-app` - Application principale
- `rimoo-service1` - Service 1
- `rimoo-service2` - Service 2
- `rimoo-autodeploy.timer` - Déploiement automatique

### Monitoring

Le système surveille automatiquement :

- **CPU** : Seuil d'alerte à 80%
- **Mémoire** : Seuil d'alerte à 80%
- **Disque** : Seuil d'alerte à 85%
- **Température** : Seuil d'alerte à 75°C
- **Services** : Vérification que tous les services sont actifs
- **Ports** : Vérification que les ports sont ouverts

### Logs

Les logs sont centralisés dans `/var/log/rimoo/` :

- `autodeploy.log` - Logs du déploiement automatique
- `monitor.log` - Logs du monitoring système
- `backup.log` - Logs des sauvegardes
- `alerts.log` - Logs des alertes système
- `status.json` - Statut système en temps réel (JSON)

## 🔄 Workflow de déploiement

1. **Détection** : Le timer vérifie Git toutes les 5 minutes
2. **Analyse** : Détecte les fichiers modifiés
3. **Sauvegarde** : Créé un backup avant déploiement
4. **Déploiement** : Met à jour le code et les configurations
5. **Redémarrage** : Redémarre uniquement les services impactés
6. **Vérification** : Vérifie que tout fonctionne correctement

## 📊 Endpoints de monitoring

Une fois installé, vous pouvez accéder à :

- `http://votre-ip/status` - Statut simple (texte)
- `http://votre-ip/api/system/status` - Statut détaillé (JSON)
- `http://votre-ip/` - Votre application principale

## 🔒 Sécurité

Le système configure automatiquement :

- **UFW** : Firewall avec règles par défaut
- **Fail2ban** : Protection contre les attaques par force brute
- **Permissions** : Isolation des processus et protection des fichiers
- **Logs** : Monitoring des tentatives d'intrusion

## 💾 Sauvegardes

Les sauvegardes sont automatiques :

- **Quotidienne** : Backup complet à 2h00
- **Avant déploiement** : Backup automatique avant chaque mise à jour
- **Rétention** : 30 jours de rétention
- **Emplacement** : `/opt/rimoo-backups/`

## 🛠️ Personnalisation

### Modifier les seuils de monitoring

Editez `system-config/templates/monitor.sh.j2` :

```bash
# Seuils d'alerte
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=85
TEMP_THRESHOLD=75
```

### Modifier la fréquence de déploiement

Editez `system-config/templates/rimoo-autodeploy.timer.j2` :

```ini
[Timer]
OnBootSec=2min
OnUnitActiveSec=5min  # Changez ici (5min = toutes les 5 minutes)
```

### Ajouter des services

Modifiez `system-config/playbook.yml` pour ajouter vos propres services.

## 🐛 Dépannage

### Vérifier les services

```bash
# Statut des services
systemctl status rimoo-app
systemctl status rimoo-service1
systemctl status rimoo-service2
systemctl status rimoo-autodeploy.timer

# Logs des services
journalctl -u rimoo-app -f
journalctl -u rimoo-autodeploy.service -f
```

### Logs de déploiement

```bash
# Logs du déploiement automatique
tail -f /var/log/rimoo/autodeploy.log

# Logs du monitoring
tail -f /var/log/rimoo/monitor.log
```

### Forcer un déploiement

```bash
# Déclencher manuellement
sudo systemctl start rimoo-autodeploy.service

# Voir les logs en temps réel
journalctl -u rimoo-autodeploy.service -f
```

### Désactiver temporairement

```bash
# Désactiver le déploiement automatique
sudo systemctl stop rimoo-autodeploy.timer
sudo systemctl disable rimoo-autodeploy.timer

# Réactiver
sudo systemctl enable rimoo-autodeploy.timer
sudo systemctl start rimoo-autodeploy.timer
```

## 📋 Structure des fichiers

```
system-config/
├── playbook.yml              # Playbook Ansible principal
├── inventory                 # Inventaire Ansible
├── deploy.sh                 # Script de déploiement
├── templates/                # Templates de configuration
│   ├── rimoo-app.service.j2
│   ├── rimoo-service1.service.j2
│   ├── rimoo-service2.service.j2
│   ├── rimoo-autodeploy.service.j2
│   ├── rimoo-autodeploy.timer.j2
│   ├── auto-deploy.sh.j2
│   ├── monitor.sh.j2
│   ├── backup.sh.j2
│   ├── nginx-rimoo.conf.j2
│   ├── system-limits.conf.j2
│   └── fail2ban-rimoo.conf.j2
└── README.md                 # Cette documentation
```

## 🆘 Support

En cas de problème :

1. Vérifiez les logs : `./system-config/deploy.sh logs`
2. Vérifiez le statut : `./system-config/deploy.sh status`
3. Consultez les logs systemd : `journalctl -u rimoo-app -f`

## 🎯 Prochaines étapes

Une fois installé, vous pouvez :

1. **Développer** : Modifier vos services directement dans le code
2. **Commiter** : Pousser vos changements sur Git
3. **Attendre** : Le système se met à jour automatiquement
4. **Surveiller** : Les logs vous informent de tout

Le système est maintenant complètement autonome ! 🚀 