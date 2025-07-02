# 🚀 Guide de démarrage rapide - Rimoo Raspberry

## 🎯 **Deux modes au choix**

| Mode | Commande | Avantages |
|------|----------|-----------|
| **🐳 Docker** | `docker\dev-helper.bat start` | Rapide, portable, isolé |
| **🍓 Remote SSH** | VS Code + SSH + `npm run dev` | Hardware réel, développement natif |

---

## 🐳 **Option 1: Développement Docker (Prototypage)**

```bash
# Démarrer
docker\dev-helper.bat start

# Se connecter
docker\dev-helper.bat shell

# Voir les logs
docker\dev-helper.bat logs

# Application sur : http://localhost:3001
```

**✅ Parfait pour :** Développement rapide, tests, apprentissage

---

## 🍓 **Option 2: Développement Remote SSH (Recommandé)**

### **Sur le Raspberry Pi :**
```bash
# 1. Cloner le projet
git clone VOTRE_REPO_URL
cd rimoo-rasberry

# 2. Installation des dépendances
npm install

# 3. Mode développement (tous les services avec auto-reload)
npm run dev

# Application sur : http://192.168.119.77:3000
```

### **Sur Windows :**
```bash
# 1. Installer l'extension VS Code "Remote - SSH"
# 2. Ctrl+Shift+P → "Remote-SSH: Connect to Host"
# 3. Entrer: mathias@192.168.119.77
# 4. Ouvrir le dossier: ~/rimoo-rasberry
# 5. Développer comme si c'était local !
```

**✅ Parfait pour :** Développement avec GPIO, capteurs, hardware réel

---

## 📊 **Voir les logs en temps réel**

| Mode | Commande |
|------|----------|
| **Docker** | `docker\dev-helper.bat logs` |
| **Remote SSH** | Terminal intégré VS Code (logs directement visibles) |

---

## 🔧 **Commandes utiles**

### Scripts npm disponibles
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

### Basculer entre les modes
```bash
# Docker → Remote SSH
docker\dev-helper.bat stop
# Puis connecter VS Code en Remote SSH

# Remote SSH → Docker  
# Fermer VS Code Remote
docker\dev-helper.bat start
```

---

## 🆘 **Dépannage rapide**

### Container Docker ne démarre pas
```bash
docker\dev-helper.bat clean
docker\dev-helper.bat start
```

### Remote SSH ne fonctionne pas
```bash
# Vérifier la connexion
ssh mathias@192.168.119.77

# Configurer les clés SSH (optionnel)
ssh-keygen -t rsa -b 4096
ssh-copy-id mathias@192.168.119.77
```

### Services Raspberry Pi ne démarrent pas
```bash
# Dans VS Code Terminal (Remote SSH)
cd ~/rimoo-rasberry
npm install              # Réinstaller les dépendances
npm run dev              # Redémarrer en mode développement
```

---

## 🎯 **Workflow recommandé**

### **Pour débuter :**
1. **Tester avec Docker** pour comprendre l'application
2. **Passer au Remote SSH** pour le développement réel

### **Développement quotidien :**
1. **Ouvrir VS Code** sur Windows
2. **Se connecter en Remote SSH** au Raspberry Pi
3. **Lancer `npm run dev`** - tous les services démarrent avec auto-reload
4. **Développer normalement** - tout est transparent !
5. **Voir les changements** en temps réel sur http://192.168.119.77:3000

### **Production :**
1. **Arrêter le mode dev** : Ctrl+C dans le terminal
2. **Démarrer en production** : `npm start` ou services individuels

---

## 🌟 **Avantages du Remote SSH**

- ✅ **Pas de synchronisation** - développement direct
- ✅ **Performance native** du Raspberry Pi
- ✅ **Accès GPIO** et hardware réel
- ✅ **Extensions VS Code** fonctionnent
- ✅ **Terminal intégré** dans VS Code
- ✅ **Debugging complet** avec breakpoints
- ✅ **Auto-reload** avec nodemon

---

## 📚 **Documentation complète**

- [`README.md`](README.md) - Documentation complète
- [`GUIDE-WINDOWS.md`](GUIDE-WINDOWS.md) - Guide spécifique Windows
- [`package.json`](package.json) - Scripts npm disponibles

---

## 🎯 **Choix recommandé selon votre usage**

- **🎓 Apprentissage / Tests rapides** → Docker
- **🔧 Développement réel** → Remote SSH + npm
- **🚀 Production** → npm start
- **👥 Équipe mixte** → Les deux modes supportés ! 