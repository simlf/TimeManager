#!/bin/sh
cd ./web_app
ls --all

# Assurez-vous que les dépendances sont à jour
npm install
# Démarrer le service Vite
npm run dev