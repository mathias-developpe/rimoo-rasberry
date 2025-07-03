# 🚀 Guide de Déploiement Automatique - Rimoo Raspberry

## 🎯 Objectif

Ce système transforme votre Raspberry Pi en une plateforme **complètement autonome** qui :
- 📥 **Se met à jour automatiquement** depuis Git toutes les 5 minutes
- 🔄 **Redémarre les services** uniquement si nécessaire
- 📊 **Surveille** les ressources système en continu
- 💾 **Sauvegarde** automatiquement vos configurations
- 🔒 **Sécurise** votre système avec firewall et fail2ban
- 🌐 **Expose** vos services via nginx

## ⚡ Installation Ultra-Rapide

```bash
# 1. Aller dans votre projet
cd /home/mathias/Desktop/rimoo-rasberry

# 2. Lancer l'installation (une seule fois)
sudo ./system-config/deploy.sh install

# 3. Vérifier que tout fonctionne
./system-config/deploy.sh status
```

**C'est tout !** Votre système est maintenant **100% autonome** 🎉

## 🔄 Comment ça marche

### Workflow automatique

1. **Toutes les 5 minutes** : Le système vérifie Git
2. **Si changements** : Sauvegarde → Déploiement → Redémarrage → Vérification
3. **Si erreur** : Logs détaillés + alertes
4. **Si tout OK** : Système opérationnel

### Exemple concret

```bash
# Vous modifiez votre code
git add .
git commit -m "Amélioration du service 1"
git push origin main

# ⏰ Dans les 5 minutes qui suivent :
# ✅ Le Raspberry Pi détecte le changement
# ✅ Créé un backup automatique
# ✅ Télécharge le nouveau code
# ✅ Redémarre uniquement "rimoo-service1"
# ✅ Vérifie que tout fonctionne
# ✅ Logs tout le processus
```

## 📊 Monitoring en temps réel

### Endpoints web

Une fois installé, vous pouvez surveiller votre système :

```bash
# Statut simple
curl http://192.168.119.77/status

# Statut détaillé (JSON)
curl http://192.168.119.77/api/system/status

# Votre application
curl http://192.168.119.77/
```

### Commandes de monitoring

```bash
# Statut complet
./system-config/deploy.sh status

# Logs en temps réel
./system-config/deploy.sh logs

# Logs spécifiques
tail -f /var/log/rimoo/autodeploy.log
tail -f /var/log/rimoo/monitor.log
```

## 🔧 Gestion des services

### Services créés automatiquement

- `rimoo-app` → Votre application principale (port 3000)
- `rimoo-service1` → Service 1 (port 3001)
- `rimoo-service2` → Service 2 (port 3002)
- `rimoo-autodeploy.timer` → Déploiement automatique

### Contrôle manuel

```bash
# Vérifier les services
systemctl status rimoo-app
systemctl status rimoo-service1
systemctl status rimoo-service2

# Redémarrer manuellement
sudo systemctl restart rimoo-app

# Logs des services
journalctl -u rimoo-app -f
journalctl -u rimoo-autodeploy.service -f
```

## 🛠️ Personnalisation

### Modifier la fréquence de déploiement

```bash
# Editer le timer (par défaut: 5 minutes)
sudo vim /etc/systemd/system/rimoo-autodeploy.timer

# Changer cette ligne:
OnUnitActiveSec=5min    # 1min, 10min, 30min, etc.

# Recharger
sudo systemctl daemon-reload
sudo systemctl restart rimoo-autodeploy.timer
```

### Ajouter des services

Modifiez `system-config/playbook.yml` et ajoutez vos services suivant le modèle existant.

## 🐛 Dépannage

### Problèmes courants

**Service qui ne démarre pas :**
```bash
# Vérifier les logs
journalctl -u rimoo-app -n 50

# Vérifier le code
cd /home/mathias/Desktop/rimoo-rasberry
npm install
node app/index.js  # Test manuel
```

**Déploiement qui échoue :**
```bash
# Logs détaillés
tail -f /var/log/rimoo/autodeploy.log

# Forcer un déploiement
sudo systemctl start rimoo-autodeploy.service
```

**Monitoring qui alerte :**
```bash
# Vérifier les ressources
htop
df -h
free -h
```

### Désactiver temporairement

```bash
# Arrêter le déploiement automatique
sudo systemctl stop rimoo-autodeploy.timer

# Réactiver
sudo systemctl start rimoo-autodeploy.timer
```

## 📋 Checklist post-installation

- [ ] ✅ `./system-config/deploy.sh status` affiche tout en vert
- [ ] ✅ `http://192.168.119.77/status` répond "OK"
- [ ] ✅ `http://192.168.119.77/` affiche votre application
- [ ] ✅ `tail -f /var/log/rimoo/autodeploy.log` montre les vérifications
- [ ] ✅ Les services redémarrent après un push Git

## 🎯 Avantages

### Avant (développement classique)
```bash
# Sur chaque changement :
git push
ssh mathias@192.168.119.77
cd rimoo-rasberry
git pull
npm install
sudo systemctl restart rimoo-app
sudo systemctl restart rimoo-service1
# etc...
```

### Maintenant (système autonome)
```bash
# Sur chaque changement :
git push
# ⏰ Attendre 5 minutes maximum
# ✅ Tout est automatique !
```

## 🚀 Résultat final

Votre Raspberry Pi est maintenant **une plateforme de production autonome** qui :

- 🔄 **Se met à jour seul** depuis Git
- 📊 **Se surveille** automatiquement  
- 💾 **Se sauvegarde** quotidiennement
- 🔒 **Se protège** avec firewall et fail2ban
- 🌐 **Expose** vos services proprement
- 📝 **Documente** tout dans les logs

**Vous n'avez plus qu'à développer et commiter !** 🎉

---

*Pour plus de détails, consultez [system-config/README.md](system-config/README.md)* 