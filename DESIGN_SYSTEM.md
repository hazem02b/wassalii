# 🎨 DESIGN SYSTEM - Application Wassali Mobile

## 📋 Vue d'ensemble

L'application mobile Wassali utilise un design system **100% cohérent** avec l'application web. Tous les composants, couleurs, espacements et typographies sont identiques.

---

## 🎨 Couleurs

### Couleurs Primaires
```dart
// Bleu principal - identique au web
primary: Color(0xFF0066FF)
primaryDark: Color(0xFF0052CC)

// Secondaire
secondary: Color(0xFFF3F3F5)
accent: Color(0xFFE9EBEF)
```

### Couleurs de Background
```dart
background: Color(0xFFF9FAFB)    // bg-gray-50
backgroundDark: Color(0xFF111827) // bg-gray-900
surface: Colors.white
surfaceDark: Color(0xFF1F2937)    // bg-gray-800
```

### Couleurs de Texte
```dart
textPrimary: Color(0xFF030213)    // Noir web
textSecondary: Color(0xFF717182)  // Gris muted
textLight: Color(0xFF9CA3AF)      // gray-400
```

### Couleurs de Statut
```dart
success: Color(0xFF10B981)  // green-500
warning: Color(0xFFF59E0B)  // yellow-500
error: Color(0xFFD4183D)    // Destructive web
info: Color(0xFF0066FF)
```

### Couleurs de Bordure
```dart
border: Color(0xFFE5E7EB)       // gray-200
borderLight: Color(0xFFF3F4F6)  // gray-100
borderDark: Color(0xFF374151)   // gray-700
```

### Gradients
```dart
// Gradient primaire - identique au web
primaryGradient: LinearGradient(
  colors: [Color(0xFF0066FF), Color(0xFF0052CC)],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
)
```

---

## 📏 Espacements & Border Radius

### Border Radius (identiques au web)
```dart
radiusSmall: 8.0        // rounded-md
radiusMedium: 12.0      // rounded-xl (web)
radiusLarge: 16.0       // rounded-2xl
radiusExtraLarge: 24.0  // rounded-3xl (web)
```

### Espacements Standards
```dart
Padding: EdgeInsets.all(24)              // py-6 px-6
Button Padding: EdgeInsets.symmetric(
  horizontal: 16, 
  vertical: 16
)                                         // py-4
Input Padding: EdgeInsets.symmetric(
  horizontal: 16, 
  vertical: 12
)                                         // py-3 pl-12
```

---

## ✍️ Typographie

### Police
- **Google Fonts: Inter** (identique au web)

### Tailles de Texte (identiques au web)
```dart
displayLarge: 32px   // text-3xl
displayMedium: 24px  // text-2xl
displaySmall: 20px   // text-xl
headlineMedium: 18px // text-lg
titleLarge: 16px     // text-base
titleMedium: 14px    // text-sm
bodyLarge: 16px
bodyMedium: 14px
bodySmall: 12px      // text-xs
```

### Poids de Police
```dart
fontWeight: w400  // font-normal (web)
fontWeight: w500  // font-medium (web)
fontWeight: w600  // font-semibold (web)
fontWeight: w700  // font-bold (web)
```

---

## 🧩 Composants Personnalisés

### 1. **CustomButton**
Bouton identique au design web
```dart
CustomButton(
  text: 'Connexion',
  onPressed: () {},
  isLoading: false,
  isOutlined: false,  // Outlined button style
  backgroundColor: AppColors.primary,
  icon: Icons.login,
)
```

### 2. **CustomTextField**
Champ de texte avec label identique au web
```dart
CustomTextField(
  label: 'Email',
  hint: 'Entrez votre email',
  controller: emailController,
  keyboardType: TextInputType.emailAddress,
  prefixIcon: Icon(Icons.email),
  validator: (value) => ...,
)
```

### 3. **CustomCard**
Card avec bordure et ombre légère
```dart
CustomCard(
  padding: EdgeInsets.all(16),
  onTap: () {},
  child: Column(...),
)
```

### 4. **StatusBadge**
Badge de statut coloré
```dart
StatusBadge.success('Confirmé')
StatusBadge.warning('En attente')
StatusBadge.error('Annulé')
StatusBadge.info('En cours')
```

### 5. **LoadingIndicator**
Indicateur de chargement
```dart
LoadingIndicator(
  size: 40,
  color: AppColors.primary,
)
```

### 6. **EmptyState**
État vide avec icône et message
```dart
EmptyState(
  icon: Icons.inbox,
  title: 'Aucune réservation',
  message: 'Vous n\'avez pas encore de réservations',
  actionText: 'Créer une réservation',
  onAction: () {},
)
```

### 7. **CustomBottomSheet**
Bottom sheet moderne
```dart
CustomBottomSheet.show(
  context: context,
  title: 'Options',
  child: Column(...),
  actions: [
    CustomButton(...),
  ],
)
```

### 8. **CustomDialog**
Dialog personnalisé
```dart
CustomDialog.show(
  context: context,
  title: 'Confirmer',
  message: 'Voulez-vous continuer?',
  confirmText: 'Oui',
  cancelText: 'Non',
  icon: Icons.check_circle,
  iconColor: AppColors.success,
)
```

### 9. **CustomSnackBar**
Snackbar avec icône
```dart
CustomSnackBar.show(
  context: context,
  message: 'Opération réussie',
  type: SnackBarType.success,
  duration: Duration(seconds: 3),
)
```

### 10. **UserAvatar**
Avatar utilisateur avec initiales ou image
```dart
UserAvatar(
  name: 'John Doe',
  imageUrl: 'https://...',
  size: 48,
  onTap: () {},
)
```

### 11. **OptionsList**
Liste d'options stylisée
```dart
OptionsList(
  items: [
    OptionItem(
      title: 'Paramètres',
      subtitle: 'Gérer vos préférences',
      icon: Icons.settings,
      onTap: () {},
    ),
  ],
)
```

### 12. **SectionHeader**
En-tête de section
```dart
SectionHeader(
  title: 'Réservations récentes',
  actionText: 'Voir tout',
  onAction: () {},
  icon: Icons.bookmark,
)
```

---

## 📱 Patterns d'Écrans

### Structure Standard
```dart
Scaffold(
  backgroundColor: AppColors.background,
  appBar: AppBar(
    title: Text('Titre'),
    backgroundColor: Colors.transparent,
    elevation: 0,
  ),
  body: SafeArea(
    child: SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contenu
        ],
      ),
    ),
  ),
)
```

### Header avec Gradient (comme Home)
```dart
Container(
  decoration: BoxDecoration(
    gradient: AppColors.primaryGradient,
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(AppTheme.radiusExtraLarge),
      bottomRight: Radius.circular(AppTheme.radiusExtraLarge),
    ),
  ),
  padding: EdgeInsets.fromLTRB(24, 60, 24, 32),
  child: // Contenu header
)
```

### Input avec Label
```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('Label', style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
    )),
    SizedBox(height: 8),
    TextFormField(...),
  ],
)
```

---

## 🎯 Règles de Design

### 1. Cohérence avec le Web
- Tous les composants doivent ressembler au design web
- Mêmes couleurs, espacements, border radius
- Même typographie (Inter)

### 2. Espacements
- Utilisez des multiples de 4 (4, 8, 12, 16, 24, 32)
- Padding standard: 24px
- Espacement entre éléments: 16px

### 3. Couleurs
- Utilisez toujours `AppColors` pour les couleurs
- Pas de couleurs en dur (hardcoded)

### 4. Typographie
- Utilisez `TextStyle` du thème
- Pas de tailles de police personnalisées

### 5. Éléments Interactifs
- Tous les boutons ont `elevation: 0`
- Border radius: `AppTheme.radiusMedium` (12px)
- Feedback tactile avec `InkWell` ou `GestureDetector`

### 6. État de Chargement
- Utilisez `LoadingIndicator` ou `CustomButton(isLoading: true)`
- Désactiver les boutons pendant le chargement

### 7. Feedback Utilisateur
- Utilisez `CustomSnackBar` pour les messages
- Utilisez `CustomDialog` pour les confirmations
- Utilisez `CustomBottomSheet` pour les options

---

## 📦 Widgets Disponibles

### Fichiers de Widgets
```
lib/widgets/
├── custom_button.dart       # Boutons personnalisés
├── custom_text_field.dart   # Champs de texte
├── custom_card.dart         # Cards et badges
├── loading_indicator.dart   # Indicateurs de chargement
├── empty_state.dart         # États vides
├── custom_dialogs.dart      # Dialogs et bottom sheets
└── common_widgets.dart      # Avatar, listes, headers
```

### Import Rapide
```dart
// Importer tous les widgets
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_card.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/empty_state.dart';
import '../widgets/custom_dialogs.dart';
import '../widgets/common_widgets.dart';
```

---

## ✅ Checklist d'Implémentation

Lors de la création d'un nouvel écran :

- [ ] Utiliser `AppColors` pour toutes les couleurs
- [ ] Utiliser `AppTheme.radius*` pour les border radius
- [ ] Utiliser les widgets personnalisés (`CustomButton`, `CustomTextField`, etc.)
- [ ] Respecter les espacements standards (multiples de 4)
- [ ] Ajouter `SafeArea` autour du contenu
- [ ] Utiliser `SingleChildScrollView` pour le scroll
- [ ] Tester sur différentes tailles d'écran
- [ ] Ajouter les états de chargement
- [ ] Gérer les états vides
- [ ] Ajouter le feedback utilisateur approprié

---

## 🎨 Exemples Visuels

### Bouton Primaire
```dart
CustomButton(
  text: 'Se connecter',
  onPressed: () {},
  width: double.infinity,
)
// ┌─────────────────────────┐
// │     SE CONNECTER        │  ← Bleu #0066FF, texte blanc
// └─────────────────────────┘
```

### Bouton Outlined
```dart
CustomButton(
  text: 'Annuler',
  isOutlined: true,
  onPressed: () {},
)
// ┌─────────────────────────┐
// │       ANNULER           │  ← Bordure bleue, texte bleu
// └─────────────────────────┘
```

### Champ de Texte
```dart
CustomTextField(
  label: 'Email',
  prefixIcon: Icon(Icons.email),
)
// Email                        ← Label en gras
// ┌─────────────────────────┐
// │ 📧 email@example.com    │  ← Fond blanc, bordure grise
// └─────────────────────────┘
```

### Card
```dart
CustomCard(
  child: Column(
    children: [
      Text('Titre'),
      Text('Description'),
    ],
  ),
)
// ┌─────────────────────────┐
// │  Titre                  │
// │  Description            │  ← Fond blanc, bordure, coins arrondis
// └─────────────────────────┘
```

---

## 📚 Ressources

- **Palette de couleurs** : `/lib/constants/app_colors.dart`
- **Thème** : `/lib/config/app_theme.dart`
- **Widgets** : `/lib/widgets/`
- **Exemples d'écrans** : `/lib/screens/`

---

**Dernière mise à jour** : 3 janvier 2026
**Version** : 1.0.0
