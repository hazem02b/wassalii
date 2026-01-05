#!/bin/bash
# Script de lancement complet - Wassali App (Linux/Mac)
# Lance le backend et le frontend automatiquement

echo "🚀 Démarrage de Wassali App..."
echo ""

# Vérifier si Python est installé
echo "📋 Vérification des prérequis..."
if command -v python3 &> /dev/null; then
    python_version=$(python3 --version)
    echo "✅ Python: $python_version"
else
    echo "❌ Python n'est pas installé!"
    echo "Installez Python: https://www.python.org/downloads/"
    exit 1
fi

# Vérifier si Flutter est installé
if command -v flutter &> /dev/null; then
    echo "✅ Flutter installé"
else
    echo "❌ Flutter n'est pas installé!"
    echo "Installez Flutter: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo ""
echo "🔧 Installation des dépendances..."

# Installer les dépendances backend
echo "📦 Installation des dépendances backend..."
cd web_src/backend
pip3 install -r requirements.txt --quiet
if [ $? -ne 0 ]; then
    echo "❌ Erreur lors de l'installation des dépendances backend"
    exit 1
fi
echo "✅ Dépendances backend installées"

# Retour à la racine
cd ../..

# Installer les dépendances frontend
echo "📦 Installation des dépendances frontend..."
flutter pub get
if [ $? -ne 0 ]; then
    echo "❌ Erreur lors de l'installation des dépendances frontend"
    exit 1
fi
echo "✅ Dépendances frontend installées"

echo ""
echo "🚀 Lancement des serveurs..."
echo ""

# Lancer le backend en arrière-plan
echo "🔌 Démarrage du backend sur http://localhost:8000..."
cd web_src/backend
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000 &
BACKEND_PID=$!
cd ../..

# Attendre que le backend démarre
echo "⏳ Attente du démarrage du backend..."
sleep 5

# Tester si le backend répond
backend_ready=false
max_attempts=10
attempt=0

while [ "$backend_ready" = false ] && [ $attempt -lt $max_attempts ]; do
    if curl -s http://localhost:8000/health > /dev/null; then
        backend_ready=true
        echo "✅ Backend démarré avec succès!"
    else
        attempt=$((attempt + 1))
        echo "⏳ Tentative $attempt/$max_attempts..."
        sleep 2
    fi
done

if [ "$backend_ready" = false ]; then
    echo "⚠️  Le backend met du temps à démarrer, mais on continue..."
fi

echo ""

# Lancer le frontend
echo "📱 Démarrage du frontend Flutter..."
flutter run -d chrome &
FRONTEND_PID=$!

echo ""
echo "✅ Tous les serveurs sont lancés!"
echo ""
echo "📍 URLs importantes:"
echo "   🔌 Backend API:     http://localhost:8000"
echo "   📚 Documentation:   http://localhost:8000/docs"
echo "   📱 Application:     Chrome (démarrage automatique)"
echo ""
echo "🔑 Comptes de test:"
echo "   Client:        client@test.com / password123"
echo "   Transporteur:  transporteur@test.com / password123"
echo ""
echo "💡 PIDs des processus:"
echo "   Backend:  $BACKEND_PID"
echo "   Frontend: $FRONTEND_PID"
echo ""
echo "Pour arrêter les serveurs:"
echo "   kill $BACKEND_PID $FRONTEND_PID"
echo ""

# Fonction de nettoyage
cleanup() {
    echo ""
    echo "🛑 Arrêt des serveurs..."
    kill $BACKEND_PID $FRONTEND_PID 2>/dev/null
    echo "✅ Serveurs arrêtés"
    exit 0
}

# Capturer Ctrl+C
trap cleanup SIGINT SIGTERM

# Attendre
echo "Appuyez sur Ctrl+C pour arrêter les serveurs..."
wait
