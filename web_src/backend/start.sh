#!/bin/bash

echo "============================================"
echo "   Wassali Backend - Lancement Rapide"
echo "============================================"
echo ""

# Activer l'environnement virtuel
if [ -f "venv/bin/activate" ]; then
    echo "Activation de l'environnement virtuel..."
    source venv/bin/activate
else
    echo "ERREUR: Environnement virtuel non trouvé!"
    echo "Veuillez exécuter: python -m venv venv"
    exit 1
fi

# Vérifier si .env existe
if [ ! -f ".env" ]; then
    echo "ATTENTION: Fichier .env non trouvé!"
    echo "Copie de .env.example vers .env..."
    cp .env.example .env
    echo ""
    echo "IMPORTANT: Éditez le fichier .env avec vos paramètres!"
    echo "Notamment DATABASE_URL et SECRET_KEY"
    read -p "Appuyez sur Entrée pour continuer..."
fi

echo ""
echo "Démarrage du serveur FastAPI..."
echo "API: http://localhost:8000"
echo "Docs: http://localhost:8000/api/v1/docs"
echo ""

python main.py
