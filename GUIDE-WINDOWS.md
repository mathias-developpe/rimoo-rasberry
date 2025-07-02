# 🪟 Guide Windows - Rimoo Raspberry Docker

Guide spécifique pour utiliser le projet sur **Windows avec Docker Desktop**.

## 📋 Prérequis Windows

1. **Docker Desktop** installé et démarré
2. **WSL2** activé (recommandé pour de meilleures performances)
3. **Git Bash** ou **PowerShell** (pour les commandes)

## 🚀 Démarrage rapide sur Windows

### Option 1: Scripts unifiés (Nouveauté !)

```bash
# Démarrage avec détection automatique (dans Git Bash)
./scripts/deploy.sh auto start

# Ou forcer l'environnement Docker
./scripts/deploy.sh docker start
./scripts/deploy.sh docker logs
```

### Option 2: Script batch Windows (Compatible)

```batch
REM Démarrer le container
docker\dev-helper.bat start

REM Se connecter au container
docker\dev-helper.bat shell

REM Voir les logs
docker\dev-helper.bat logs

REM Aide complète
docker\dev-helper.bat help
```

### Option 2: Commandes PowerShell directes

```powershell
# Démarrer
docker-compose up -d

# Se connecter au container
docker exec -it rimoo-rasberry-dev /bin/bash

# Arrêter
docker-compose down
```

### Option 3: Dans WSL2 (Ubuntu)

Si vous avez WSL2 avec Ubuntu installé :

```bash
# Ouvrir WSL Ubuntu
wsl

# Naviguer vers le projet
cd /mnt/c/Users/VOTRE_USER/Desktop/rimoo-rasberry

# Utiliser le script Linux
./docker/dev-helper.sh start
./docker/dev-helper.sh shell
```

## 🛠️ Commandes du script batch

Le script `docker\dev-helper.bat` propose les mêmes fonctionnalités que la version Linux :

| Commande | Description |
|----------|-------------|
| `start` | Démarre le container de développement |
| `stop` | Arrête le container |
| `restart` | Redémarre le container |
| `shell` | Ouvre un shell dans le container |
| `logs` | Affiche les logs en temps réel |
| `build` | Rebuild l'image Docker |
| `status` | Statut des services |
| `clean` | Nettoie containers et images |
| `prod` | Lance en mode production |

## 🔧 Développement sur Windows

### Workflow recommandé

1. **Ouvrir PowerShell** dans le dossier du projet
2. **Démarrer l'environnement** :
   ```batch
   docker\dev-helper.bat start
   ```
3. **Développer** : Éditez vos fichiers dans VS Code Windows
4. **Tester** : Connectez-vous au container pour tester
   ```batch
   docker\dev-helper.bat shell
   ```

### VS Code sur Windows

#### Option A: Édition locale + Container pour tests

1. Éditez vos fichiers dans VS Code Windows
2. Les changements sont automatiquement synchronisés dans le container
3. Testez dans le container via `docker\dev-helper.bat shell`

#### Option B: VS Code Remote-Containers

1. Installer l'extension **Remote-Containers** dans VS Code
2. `Ctrl+Shift+P` → `Remote-Containers: Open Folder in Container`
3. Développer directement dans l'environnement du container

## 🐛 Dépannage Windows

### Docker Desktop ne démarre pas
- Vérifiez que la virtualisation est activée dans le BIOS
- Redémarrez Docker Desktop
- Vérifiez que WSL2 est bien installé

### Erreurs de permissions
```powershell
# Si problème avec les scripts batch
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Volumes ne se montent pas correctement
- Vérifiez que Docker Desktop a accès au lecteur C:
- Settings → Resources → File Sharing → Ajouter le lecteur

### Ports déjà utilisés
```powershell
# Vérifier quels ports sont utilisés
netstat -an | findstr :3000

# Changer les ports dans docker-compose.yml si nécessaire
```

## 📂 Chemins Windows vs Container

| Windows | Container |
|---------|-----------|
| `C:\Users\...\rimoo-rasberry\app` | `/app/app` |
| `C:\Users\...\rimoo-rasberry\logs` | `/var/log` |
| `C:\Users\...\rimoo-rasberry\config` | `/app/config` |

## 🔗 URLs importantes

- **Application** : http://localhost:3000
- **Docker Desktop** : Interface graphique pour gérer les containers
- **Logs du container** : Visibles via `docker\dev-helper.bat logs`

## ⚡ Optimisations Windows

### Utiliser WSL2 backend
Dans Docker Desktop → Settings → General → ✅ Use WSL 2 based engine

### Améliorer les performances
- Placer le projet dans WSL2 plutôt que sur le lecteur Windows
- Utiliser le terminal WSL Ubuntu pour de meilleures performances

### Scripts rapides
Créer des raccourcis sur le bureau :
```batch
REM start-dev.bat
@echo off
cd /d "C:\Users\VOTRE_USER\Desktop\rimoo-rasberry"
docker\dev-helper.bat start
pause
```

## 🚀 Déploiement depuis Windows

Pour déployer sur le Raspberry Pi depuis Windows :

```powershell
# Avec SCP (si installé)
scp -r . pi@IP_RASPBERRY:/home/pi/rimoo-rasberry/

# Ou avec WinSCP (interface graphique)
# Ou copier via un dossier partagé réseau
```

---

## 🔄 **Déploiement vers Raspberry Pi depuis Windows**

### Déploiement automatique

```bash
# Dans Git Bash ou PowerShell
./scripts/deploy.sh raspberry 192.168.1.100

# Cela va :
# 1. Synchroniser vos fichiers
# 2. Installer les services sur le Raspberry Pi  
# 3. Démarrer l'application
```

### Gestion hybride

```bash
# Développer sur Windows
./scripts/deploy.sh docker start

# Tester sur Raspberry Pi  
./scripts/deploy.sh raspberry 192.168.1.100 start

# Mode développement synchronisé (NOUVEAU !)
scripts\sync-to-raspberry.bat setup 192.168.1.100
scripts\sync-to-raspberry.bat dev 192.168.1.100

# Basculer entre les trois modes selon vos besoins
```

## 🔄 **Mode développement synchronisé (Nouveauté !)**

### ✨ **Édition Windows + Exécution Raspberry Pi**

Ce mode vous permet de :
- **Éditer dans VS Code Windows** (confortable)
- **Exécuter sur Raspberry Pi réel** (GPIO, hardware)
- **Synchronisation automatique** de vos fichiers
- **Auto-reload** des services (nodemon)

### 🚀 **Setup rapide**

```batch
REM 1. Configuration initiale (une seule fois)
scripts\sync-to-raspberry.bat setup 192.168.1.100

REM 2. Lancer le mode développement
scripts\sync-to-raspberry.bat dev 192.168.1.100

REM 3. (Optionnel) Surveillance automatique
scripts\sync-to-raspberry.bat watch 192.168.1.100
```

### 📋 **Workflow quotidien**

1. **Démarrer la synchronisation** :
   ```batch
   scripts\sync-to-raspberry.bat dev 192.168.1.100
   ```

2. **Ouvrir VS Code** et éditer votre code normalement

3. **Voir les changements en temps réel** sur http://192.168.1.100:3000

4. **Consulter les logs** :
   ```batch
   ssh pi@192.168.1.100 "cd rimoo-rasberry && ./scripts/dev-mode-raspberry.sh logs"
   ```

**💡 Conseil** : Pour une expérience optimale, utilisez WSL2 + Docker Desktop. Vous pouvez maintenant développer sur Windows et déployer automatiquement sur Raspberry Pi ! 