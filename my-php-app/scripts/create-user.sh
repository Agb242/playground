#!/bin/bash

# Variables
GRAFANA_URL="http://127.0.0.1:3000"
ADMIN_USER="admin"
ADMIN_PASSWORD="admin"

# Générer un nom d'utilisateur aléatoire
USERNAME="user$(date +%s)"
PASSWORD="password"

# Création de l'utilisateur via l'API Grafana
RESPONSE=$(curl -s -X POST -H "Content-Type: application/json" -d '{
  "name": "'$USERNAME'",
  "email": "'$USERNAME'@example.com",
  "login": "'$USERNAME'",
  "password": "'$PASSWORD'",
  "OrgId": 1
}' $GRAFANA_URL/api/admin/users -u $ADMIN_USER:$ADMIN_PASSWORD)

# Vérifier la réponse de l'API
if [[ $RESPONSE == *"\"id\":"* ]]; then
  echo "Utilisateur créé avec succès : $USERNAME"
  echo "Mot de passe créé avec succès : $PASSWORD"
else
  echo "Erreur lors de la création de l'utilisateur : $RESPONSE"
fi

