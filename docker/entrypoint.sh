#!/bin/bash

echo "Démarrage de supervisord..."
supervisord -c /etc/supervisord.conf &
wait 