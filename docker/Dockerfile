# Utilisation de l'image Debian ARM (ou Raspberry Pi OS si nécessaire)
# Pour les tests locaux, utilisez: FROM debian:latest
# Pour Raspberry Pi, utilisez: FROM arm32v7/debian:latest
FROM debian:latest

# Mettre à jour les dépôts et installer les dépendances de base
RUN apt-get update && apt-get install -y --no-install-recommends \
  curl \
  wget \
  python3 \
  python3-pip \
  nodejs \
  npm \
  git \
  build-essential \
  supervisor \
  vim \
  nano \
  htop \
  procps \
  net-tools \
  && rm -rf /var/lib/apt/lists/*

# Installer la dernière version de Node.js (optionnel, pour versions plus récentes)
# RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
#     apt-get install -y nodejs

# Créer le répertoire de travail
WORKDIR /app

# Copier package.json en premier pour optimiser le cache Docker
COPY package.json /app/
RUN npm install

# Copier le reste du code de l'application
COPY . /app/

# Copier la configuration Supervisor
COPY docker/supervisord.conf /etc/supervisor/supervisord.conf

# Copier le fichier de démarrage et le rendre exécutable
COPY docker/start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Créer les répertoires de logs
RUN mkdir -p /var/log

# Exposer les ports utilisés par votre application
EXPOSE 3000 3001

# Utiliser le script d'entrée pour démarrer l'application
ENTRYPOINT ["/usr/local/bin/start.sh"] 