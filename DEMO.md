# 🎬 Démonstration - Système de Déploiement Automatique

## 🚀 Test du système

### 1. Installation initiale

```bash
# Installer le système (une seule fois)
sudo ./system-config/deploy.sh install

# Vérifier que tout fonctionne
./system-config/deploy.sh status
```

### 2. Démonstration du déploiement automatique

```bash
# Modifier un fichier pour déclencher un déploiement
echo "// Modification de test $(date)" >> app/service1/index.js

# Commiter et pousser
git add .
git commit -m "Test du déploiement automatique"
git push origin main

# Surveiller les logs en temps réel
echo "⏰ Surveillons le déploiement automatique..."
tail -f /var/log/rimoo/autodeploy.log
```

### 3. Vérification du monitoring

```bash
# Statut système
./system-config/deploy.sh status

# Logs de monitoring
tail -f /var/log/rimoo/monitor.log

# Statut via web
curl http://localhost/status
curl http://localhost/api/system/status
```

### 4. Test des services

```bash
# Vérifier que vos services tournent
systemctl status rimoo-app
systemctl status rimoo-service1
systemctl status rimoo-service2

# Vérifier les ports
netstat -tlnp | grep -E "(3000|3001|3002|80)"
```

## 🎯 Résultats attendus

Après installation, vous devriez voir :

```
✅ rimoo-app: ACTIF
✅ rimoo-service1: ACTIF  
✅ rimoo-service2: ACTIF
✅ rimoo-autodeploy.timer: ACTIF
✅ nginx: ACTIF
✅ Port 3000: OUVERT
✅ Port 80: OUVERT
✅ Port 22: OUVERT
```

## 🔧 Commandes utiles

```bash
# Forcer un déploiement
sudo systemctl start rimoo-autodeploy.service

# Voir les logs en temps réel
journalctl -u rimoo-autodeploy.service -f

# Arrêter temporairement l'auto-déploiement
sudo systemctl stop rimoo-autodeploy.timer

# Réactiver
sudo systemctl start rimoo-autodeploy.timer
```

## 📝 Workflow quotidien

Une fois installé, votre workflow devient :

1. **Développer** votre code normalement
2. **Commiter** vos changements
3. **Pousser** sur Git
4. **Attendre** 5 minutes maximum
5. **Vérifier** que tout fonctionne

C'est tout ! 🎉 