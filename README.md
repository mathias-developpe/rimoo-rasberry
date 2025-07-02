# 🍓 Rimoo Raspberry - Environnement de développement hybride

Application Raspberry Pi avec **environnement de développement hybride** : développez sur **Windows avec Docker** OU directement sur **Raspberry Pi via VS Code Remote SSH**.

## 🎯 **Deux modes de développement**

| Mode | Avantages | Quand l'utiliser |
|------|-----------|------------------|
| **🐳 Docker** | Rapide, isolé, portable | Développement rapide, tests, prototypage |
| **🍓 Remote SSH** | Hardware réel, GPIO, environnement natif | Développement avec matériel, production |

## 🚀 Démarrage rapide

### **Option 1: Développement Docker (Windows)**

```bash
# Démarrer l'environnement Docker
docker\dev-helper.bat start

# Se connecter au container
docker\dev-helper.bat shell

# Application disponible sur http://localhost:3001
```

### **Option 2: Développement Remote SSH (Recommandé)**

```bash
# 1. Sur le Raspberry Pi - Cloner le projet
git clone VOTRE_REPO_URL
cd rimoo-rasberry

# 2. Installation des dépendances
npm install

# 3. Démarrer en mode développement
npm run dev

# 4. Sur Windows - VS Code Remote SSH
# Installer l'extension "Remote - SSH"
# Se connecter à votre Raspberry Pi (mathias@192.168.119.77)
# Ouvrir le dossier ~/rimoo-rasberry
```

## 🔄 **Workflows disponibles**

### 1. 🔧 **Développement rapide (Docker)**
```bash
# Démarrer Docker
docker\dev-helper.bat start

# Développer dans VS Code Windows
# Les changements sont instantanés dans le container
```

### 2. 🍓 **Développement sur Raspberry Pi (Remote SSH)**
```bash
# Sur le Raspberry Pi
git clone VOTRE_REPO_URL
cd rimoo-rasberry
npm install
npm run dev

# Sur Windows dans VS Code
# 1. Installer l'extension "Remote - SSH"
# 2. Ctrl+Shift+P → "Remote-SSH: Connect to Host"
# 3. mathias@192.168.119.77
# 4. Ouvrir le dossier ~/rimoo-rasberry
# 5. Développer comme si c'était local !
```

### 3. 🚀 **Production sur Raspberry Pi**
```bash
# Démarrer en production
npm start

# Ou démarrer les services individuellement
npm run service1  # Dans un terminal
npm run service2  # Dans un autre terminal
```

## 🎯 **VS Code Remote SSH - Setup**

### **1. Installation de l'extension**
1. Ouvrir VS Code sur Windows
2. Aller dans Extensions (Ctrl+Shift+X)
3. Chercher "Remote - SSH"
4. Installer l'extension Microsoft

### **2. Configuration SSH**
```bash
# Dans PowerShell Windows
# Générer une clé SSH si pas déjà fait
ssh-keygen -t rsa -b 4096

# Copier la clé sur le Raspberry Pi (optionnel mais recommandé)
ssh-copy-id mathias@192.168.119.77
```

### **3. Connexion**
1. **Ctrl+Shift+P** → "Remote-SSH: Connect to Host"
2. Entrer `mathias@192.168.119.77`
3. Choisir le type de plateforme (Linux)
4. Ouvrir le dossier `~/rimoo-rasberry`
5. **Développer comme si c'était local !**

## 📋 **Commandes essentielles**

| Action | Docker | Remote SSH |
|--------|--------|------------|
| **Démarrer** | `docker\dev-helper.bat start` | `npm run dev` |
| **Logs** | `docker\dev-helper.bat logs` | VS Code Terminal intégré |
| **Status** | `docker\dev-helper.bat status` | VS Code Terminal intégré |
| **Shell** | `docker\dev-helper.bat shell` | VS Code Terminal intégré |
| **Redémarrer** | `docker\dev-helper.bat restart` | Code auto-reload avec nodemon |

## 🚀 **Commandes disponibles**

### Scripts npm
```bash
# Développement (tous les services avec auto-reload)
npm run dev

# Services individuels en développement
npm run dev:app        # App principale uniquement
npm run dev:service1   # Service 1 uniquement  
npm run dev:service2   # Service 2 uniquement

# Production
npm start              # App principale
npm run service1       # Service 1
npm run service2       # Service 2
```

### Scripts Docker
- `docker/dev-helper.bat` - Helper Windows
- `docker/dev-helper.sh` - Helper Linux/macOS
- `docker/Dockerfile` - Image de développement
- `docker/supervisord.conf` - Gestionnaire de processus

## 💡 **Conseils d'utilisation**

- **Prototypage rapide** : Docker sur Windows
- **Développement avec hardware** : Remote SSH vers Raspberry Pi
- **Production** : Services systemd sur Raspberry Pi
- **Debugging** : Logs en temps réel dans les deux environnements

## 🔄 **Avantages du Remote SSH**

- ✅ **Édition native** dans VS Code Windows
- ✅ **Exécution directe** sur Raspberry Pi
- ✅ **Accès GPIO** et hardware réel
- ✅ **Terminal intégré** dans VS Code
- ✅ **Extensions VS Code** fonctionnent normalement
- ✅ **Pas de synchronisation** - tout est direct !
- ✅ **Performance native** du Raspberry Pi

## 🆘 **Dépannage**

### Remote SSH ne fonctionne pas
```bash
# Vérifier SSH
ssh mathias@192.168.119.77

# Vérifier les clés
ssh-keygen -t rsa -b 4096
ssh-copy-id mathias@192.168.119.77
```

### Services ne démarrent pas
```bash
# Sur le Raspberry Pi via Remote SSH
cd ~/rimoo-rasberry
npm install              # Réinstaller les dépendances
npm run dev              # Redémarrer en mode développement
```

## 🎯 Prochaines étapes possibles

- 🔌 **Intégration GPIO** - Ajouter des capteurs/actionneurs
- 📊 **Monitoring** - Métriques système et applicatives  
- 🔄 **CI/CD** - Pipeline de déploiement automatique
- 🌐 **API REST** - Interface web pour contrôler l'application
- 📱 **Interface mobile** - App React Native/Flutter 