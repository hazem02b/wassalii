# 🤝 Guide de Contribution - Wassali

Merci de vouloir contribuer au projet Wassali ! Ce guide vous aidera à démarrer.

## 🚀 Démarrage Rapide

### 1. Cloner le Projet

```bash
git clone <URL_DU_REPO>
cd wassali_app
```

### 2. Lancer l'Application

**Méthode automatique (recommandée) :**
```powershell
# Windows
.\start_all.ps1

# Linux/Mac
chmod +x start_all.sh
./start_all.sh
```

**Méthode manuelle :**

Terminal 1 - Backend :
```bash
cd web_src/backend
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
```

Terminal 2 - Frontend :
```bash
flutter pub get
flutter run -d chrome
```

## 📁 Structure du Projet

```
wassali_app/
├── lib/                    # Code Flutter (Frontend)
│   ├── screens/           # Pages de l'application
│   ├── services/          # Services API
│   ├── providers/         # Gestion d'état
│   └── widgets/           # Composants réutilisables
│
└── web_src/backend/       # Code Python (Backend)
    ├── app/api/           # Endpoints API
    ├── app/models/        # Modèles de données
    └── app/schemas/       # Validation des données
```

## 🔧 Workflow de Développement

### 1. Créer une Branche

```bash
git checkout -b feature/ma-nouvelle-fonctionnalite
# OU
git checkout -b fix/correction-bug
```

**Convention de nommage :**
- `feature/` - Nouvelle fonctionnalité
- `fix/` - Correction de bug
- `docs/` - Documentation
- `refactor/` - Refactoring de code
- `test/` - Ajout de tests

### 2. Faire vos Modifications

#### Frontend (Flutter)

```bash
# Lancer en mode développement
flutter run -d chrome

# Hot reload automatique activé
# Modifiez le code et sauvegardez pour voir les changements
```

#### Backend (FastAPI)

```bash
# Lancer avec reload automatique
uvicorn app.main:app --reload --port 8000

# Tester l'API avec Swagger
# http://localhost:8000/docs
```

### 3. Tester vos Modifications

#### Tests Frontend
```bash
flutter test
flutter analyze
```

#### Tests Backend
```bash
cd web_src/backend
pytest
```

### 4. Commit et Push

```bash
# Ajouter les fichiers modifiés
git add .

# Commit avec un message descriptif
git commit -m "feat: ajout de la fonctionnalité X"

# Push vers votre branche
git push origin feature/ma-nouvelle-fonctionnalite
```

**Convention de messages de commit :**
- `feat:` - Nouvelle fonctionnalité
- `fix:` - Correction de bug
- `docs:` - Documentation
- `style:` - Formatage du code
- `refactor:` - Refactoring
- `test:` - Ajout de tests
- `chore:` - Maintenance

### 5. Créer une Pull Request

1. Allez sur GitHub
2. Cliquez sur "New Pull Request"
3. Sélectionnez votre branche
4. Décrivez vos changements
5. Attendez la review

## 📝 Standards de Code

### Flutter (Dart)

```dart
// ✅ BON - Noms descriptifs, camelCase
class UserProfileScreen extends StatefulWidget {
  final String userId;
  
  const UserProfileScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);
  
  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

// ❌ MAUVAIS - Noms courts, pas de const
class UPS extends StatefulWidget {
  String id;
  UPS({this.id});
}
```

**Bonnes pratiques :**
- Utiliser `const` quand possible
- Nommer les paramètres explicitement
- Commenter le code complexe
- Utiliser async/await pour l'asynchrone
- Gérer les erreurs avec try/catch

### Python (FastAPI)

```python
# ✅ BON - Type hints, docstrings, gestion d'erreurs
@router.post("/trips", response_model=TripResponse)
async def create_trip(
    trip: TripCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
) -> Trip:
    """
    Créer un nouveau trajet.
    
    Args:
        trip: Données du trajet
        current_user: Utilisateur connecté
        db: Session de base de données
        
    Returns:
        Trip: Le trajet créé
        
    Raises:
        HTTPException: Si l'utilisateur n'est pas transporteur
    """
    if current_user.user_type != "transporter":
        raise HTTPException(
            status_code=403,
            detail="Seuls les transporteurs peuvent créer des trajets"
        )
    
    return trip_service.create(db, trip, current_user.id)

# ❌ MAUVAIS - Pas de types, pas de doc
@router.post("/trips")
def create_trip(trip, user, db):
    return trip_service.create(db, trip, user.id)
```

**Bonnes pratiques :**
- Utiliser les type hints
- Ajouter des docstrings
- Valider avec Pydantic schemas
- Gérer les exceptions HTTP
- Logger les erreurs importantes

## 🎨 Standards UI/UX

### Couleurs

Utiliser les couleurs définies dans `app_colors.dart` :

```dart
// Couleurs principales
AppColors.primary      // #0066FF (Bleu)
AppColors.success      // #10B981 (Vert)
AppColors.error        // #EF4444 (Rouge)
AppColors.warning      // #F59E0B (Orange)

// Textes
AppColors.textPrimary  // Texte principal
AppColors.textSecondary // Texte secondaire
```

### Responsive Design

```dart
// ✅ BON - Adaptatif
Container(
  padding: EdgeInsets.symmetric(
    horizontal: MediaQuery.of(context).size.width * 0.05,
    vertical: 16,
  ),
  child: Text('Contenu'),
)

// ❌ MAUVAIS - Valeurs fixes
Container(
  padding: EdgeInsets.all(20),
  child: Text('Contenu'),
)
```

### Dark Mode

Toujours supporter le mode sombre :

```dart
// ✅ BON
Container(
  color: context.isDarkMode ? Colors.black : Colors.white,
  child: Text(
    'Texte',
    style: TextStyle(
      color: context.isDarkMode ? Colors.white : Colors.black,
    ),
  ),
)
```

## 🌍 Internationalisation

Ajouter des traductions pour chaque texte :

```dart
// lib/utils/app_localizations.dart

String get monNouveauTexte {
  switch (_locale.languageCode) {
    case 'fr':
      return 'Mon texte en français';
    case 'en':
      return 'My text in English';
    case 'ar':
      return 'النص بالعربية';
    default:
      return 'Mon texte en français';
  }
}
```

Utilisation :
```dart
Text(AppLocalizations.of(context).monNouveauTexte)
```

## 🐛 Déboguer

### Flutter Debug

```bash
# Lancer avec logs détaillés
flutter run -d chrome --verbose

# Observer les performances
flutter run --profile

# Analyser les builds
flutter run --analyze-size
```

### Backend Debug

```python
# Ajouter des logs
import logging
logger = logging.getLogger(__name__)

@router.get("/debug")
def debug_endpoint():
    logger.info("Point de debug atteint")
    logger.debug(f"Données: {data}")
    return {"status": "ok"}
```

```bash
# Lancer avec logs détaillés
uvicorn app.main:app --reload --log-level debug
```

## 📚 Ressources Utiles

### Documentation
- [Flutter Docs](https://flutter.dev/docs)
- [Dart Docs](https://dart.dev/guides)
- [FastAPI Docs](https://fastapi.tiangolo.com/)
- [SQLAlchemy Docs](https://docs.sqlalchemy.org/)

### Outils
- [Postman](https://www.postman.com/) - Tester l'API
- [DB Browser for SQLite](https://sqlitebrowser.org/) - Explorer la base de données
- [Flutter DevTools](https://flutter.dev/docs/development/tools/devtools/overview) - Déboguer Flutter

## ❓ Besoin d'Aide ?

1. **Consulter la documentation** dans le dossier `docs/`
2. **Vérifier les issues** existantes sur GitHub
3. **Créer une nouvelle issue** si nécessaire
4. **Demander sur Discord/Slack** (si applicable)

## 🎯 Fonctionnalités à Venir

Voici quelques idées de contributions :

### Frontend
- [ ] Notifications push
- [ ] Chat en temps réel (WebSocket)
- [ ] Système de rating amélioré
- [ ] Partage de localisation GPS
- [ ] Mode hors ligne
- [ ] Tests automatisés

### Backend
- [ ] Système de cache (Redis)
- [ ] Emails automatiques
- [ ] Export de données (PDF/Excel)
- [ ] Analytics avancées
- [ ] WebSocket pour chat temps réel
- [ ] Tests unitaires et d'intégration

### Documentation
- [ ] Tutoriels vidéo
- [ ] Guide d'architecture détaillé
- [ ] Documentation API complète
- [ ] Guide de déploiement production

## ✅ Checklist Avant Pull Request

- [ ] Le code compile sans erreurs
- [ ] Les tests passent (`flutter test` / `pytest`)
- [ ] Le code suit les standards du projet
- [ ] Les nouvelles fonctionnalités ont des tests
- [ ] La documentation est à jour
- [ ] Les commits ont des messages descriptifs
- [ ] Le code est commenté si nécessaire
- [ ] Pas de console.log() ou print() oubliés
- [ ] Les traductions sont ajoutées (FR/EN/AR)
- [ ] Le dark mode fonctionne

## 🏆 Reconnaissance

Les contributeurs seront ajoutés dans le fichier CONTRIBUTORS.md !

---

**Merci de contribuer à Wassali ! 🚚💙**
