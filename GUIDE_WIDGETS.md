# 📱 Guide d'Utilisation - Widgets Wassali

## 🎯 Guide Rapide

Ce guide vous montre comment utiliser les widgets personnalisés de l'application Wassali Mobile pour créer des interfaces cohérentes avec le design web.

---

## 🔘 Boutons

### Bouton Primaire
```dart
import '../widgets/custom_button.dart';

CustomButton(
  text: 'Se connecter',
  onPressed: () {
    // Action
  },
  width: double.infinity,  // Pleine largeur
)
```

### Bouton avec Chargement
```dart
CustomButton(
  text: 'Envoyer',
  isLoading: isLoading,  // true pour afficher le spinner
  onPressed: isLoading ? null : handleSubmit,
)
```

### Bouton Outlined
```dart
CustomButton(
  text: 'Annuler',
  isOutlined: true,
  onPressed: () => Navigator.pop(context),
)
```

### Bouton avec Icône
```dart
CustomButton(
  text: 'Ajouter',
  icon: Icons.add,
  onPressed: () {},
)
```

### Bouton Personnalisé
```dart
CustomButton(
  text: 'Supprimer',
  backgroundColor: AppColors.error,
  textColor: Colors.white,
  onPressed: () {},
)
```

---

## ✍️ Champs de Texte

### Champ Simple
```dart
import '../widgets/custom_text_field.dart';

CustomTextField(
  label: 'Email',
  controller: emailController,
  keyboardType: TextInputType.emailAddress,
)
```

### Avec Validation
```dart
CustomTextField(
  label: 'Mot de passe',
  controller: passwordController,
  obscureText: true,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Champ requis';
    }
    return null;
  },
)
```

### Avec Icônes
```dart
CustomTextField(
  label: 'Téléphone',
  prefixIcon: Icon(Icons.phone),
  suffixIcon: IconButton(
    icon: Icon(Icons.clear),
    onPressed: () => controller.clear(),
  ),
)
```

### Champ Multi-lignes
```dart
CustomTextField(
  label: 'Description',
  maxLines: 4,
  hint: 'Décrivez votre colis...',
)
```

### Champ Désactivé
```dart
CustomTextField(
  label: 'Statut',
  enabled: false,
  controller: statusController,
)
```

---

## 🃏 Cards

### Card Simple
```dart
import '../widgets/custom_card.dart';

CustomCard(
  child: Column(
    children: [
      Text('Titre'),
      SizedBox(height: 8),
      Text('Description'),
    ],
  ),
)
```

### Card Cliquable
```dart
CustomCard(
  onTap: () {
    // Navigation
    Navigator.push(...);
  },
  child: ListTile(
    title: Text('Option'),
    trailing: Icon(Icons.chevron_right),
  ),
)
```

### Card Personnalisée
```dart
CustomCard(
  color: AppColors.blue50,
  padding: EdgeInsets.all(20),
  borderRadius: BorderRadius.circular(20),
  elevation: 2,
  child: // Contenu
)
```

---

## 🏷️ Badges de Statut

### Badges Prédéfinis
```dart
import '../widgets/custom_card.dart';

// Succès (vert)
StatusBadge.success('Confirmé')

// Attention (orange)
StatusBadge.warning('En attente')

// Erreur (rouge)
StatusBadge.error('Annulé')

// Info (bleu)
StatusBadge.info('En cours')
```

### Badge Personnalisé
```dart
StatusBadge(
  text: 'Nouveau',
  color: Colors.purple,
  icon: Icons.new_releases,
)
```

---

## ⏳ Indicateurs de Chargement

### Indicateur Simple
```dart
import '../widgets/loading_indicator.dart';

LoadingIndicator()
```

### Indicateur Personnalisé
```dart
LoadingIndicator(
  size: 60,
  color: AppColors.success,
)
```

### Overlay de Chargement
```dart
if (isLoading)
  LoadingOverlay(
    message: 'Chargement en cours...',
  )
```

---

## 📭 États Vides

### État Vide Simple
```dart
import '../widgets/empty_state.dart';

EmptyState(
  icon: Icons.inbox,
  title: 'Aucune réservation',
  message: 'Vous n\'avez pas encore de réservations',
)
```

### Avec Action
```dart
EmptyState(
  icon: Icons.search_off,
  title: 'Aucun résultat',
  message: 'Essayez avec d\'autres critères',
  actionText: 'Nouvelle recherche',
  onAction: () {
    // Rediriger vers recherche
  },
)
```

---

## 📄 Bottom Sheets

### Bottom Sheet Simple
```dart
import '../widgets/custom_dialogs.dart';

CustomBottomSheet.show(
  context: context,
  title: 'Options',
  child: Column(
    children: [
      ListTile(
        leading: Icon(Icons.edit),
        title: Text('Modifier'),
        onTap: () {
          Navigator.pop(context);
          // Action
        },
      ),
      ListTile(
        leading: Icon(Icons.delete),
        title: Text('Supprimer'),
        onTap: () {
          Navigator.pop(context);
          // Action
        },
      ),
    ],
  ),
)
```

### Avec Actions
```dart
CustomBottomSheet.show(
  context: context,
  title: 'Filtres',
  child: Column(
    children: [
      // Formulaire de filtres
    ],
  ),
  actions: [
    CustomButton(
      text: 'Annuler',
      isOutlined: true,
      onPressed: () => Navigator.pop(context),
    ),
    CustomButton(
      text: 'Appliquer',
      onPressed: () {
        // Appliquer filtres
        Navigator.pop(context);
      },
    ),
  ],
)
```

---

## 💬 Dialogs

### Dialog Simple
```dart
import '../widgets/custom_dialogs.dart';

await CustomDialog.show(
  context: context,
  title: 'Information',
  message: 'Votre réservation a été créée',
  confirmText: 'OK',
  icon: Icons.check_circle,
  iconColor: AppColors.success,
)
```

### Dialog de Confirmation
```dart
final confirm = await CustomDialog.show(
  context: context,
  title: 'Confirmer la suppression',
  message: 'Voulez-vous vraiment supprimer cette réservation?',
  confirmText: 'Supprimer',
  cancelText: 'Annuler',
  icon: Icons.warning,
  iconColor: AppColors.warning,
);

if (confirm == true) {
  // Supprimer
}
```

---

## 🔔 Snackbars

### Snackbar de Succès
```dart
import '../widgets/custom_dialogs.dart';

CustomSnackBar.show(
  context: context,
  message: 'Réservation créée avec succès',
  type: SnackBarType.success,
)
```

### Snackbar d'Erreur
```dart
CustomSnackBar.show(
  context: context,
  message: 'Une erreur est survenue',
  type: SnackBarType.error,
  duration: Duration(seconds: 5),
)
```

### Avec Action
```dart
CustomSnackBar.show(
  context: context,
  message: 'Élément supprimé',
  type: SnackBarType.info,
  actionLabel: 'ANNULER',
  onAction: () {
    // Annuler la suppression
  },
)
```

---

## 👤 Avatars

### Avatar Simple
```dart
import '../widgets/common_widgets.dart';

UserAvatar(
  name: 'John Doe',
  size: 48,
)
```

### Avatar avec Image
```dart
UserAvatar(
  name: 'John Doe',
  imageUrl: 'https://example.com/avatar.jpg',
  size: 64,
)
```

### Avatar Cliquable
```dart
UserAvatar(
  name: user.name,
  imageUrl: user.avatar,
  onTap: () {
    Navigator.pushNamed(context, '/profile');
  },
)
```

---

## 📋 Listes d'Options

### Liste Simple
```dart
import '../widgets/common_widgets.dart';

OptionsList(
  items: [
    OptionItem(
      title: 'Paramètres',
      icon: Icons.settings,
      onTap: () => Navigator.pushNamed(context, '/settings'),
    ),
    OptionItem(
      title: 'Aide',
      icon: Icons.help,
      onTap: () => Navigator.pushNamed(context, '/help'),
    ),
    OptionItem(
      title: 'Déconnexion',
      icon: Icons.logout,
      iconColor: AppColors.error,
      textColor: AppColors.error,
      onTap: () => handleLogout(),
    ),
  ],
)
```

### Avec Sous-titres
```dart
OptionsList(
  items: [
    OptionItem(
      title: 'Notifications',
      subtitle: 'Gérer vos préférences',
      icon: Icons.notifications,
      trailing: Switch(value: true, onChanged: (v) {}),
    ),
  ],
)
```

---

## 📑 En-têtes de Section

### En-tête Simple
```dart
import '../widgets/common_widgets.dart';

SectionHeader(
  title: 'Réservations récentes',
)
```

### Avec Action
```dart
SectionHeader(
  title: 'Mes trajets',
  actionText: 'Voir tout',
  onAction: () {
    Navigator.pushNamed(context, '/trips');
  },
)
```

### Avec Icône
```dart
SectionHeader(
  title: 'Favoris',
  icon: Icons.star,
  actionText: 'Gérer',
  onAction: () {},
)
```

---

## 📱 Exemple d'Écran Complet

```dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_dialogs.dart';
import '../widgets/common_widgets.dart';

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  final _nameController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleSubmit() async {
    setState(() => _isLoading = true);
    
    // Simuler une requête API
    await Future.delayed(Duration(seconds: 2));
    
    setState(() => _isLoading = false);
    
    if (mounted) {
      CustomSnackBar.show(
        context: context,
        message: 'Enregistré avec succès',
        type: SnackBarType.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Exemple'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête
              SectionHeader(
                title: 'Informations',
                icon: Icons.info,
              ),
              
              SizedBox(height: 16),
              
              // Card avec formulaire
              CustomCard(
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Nom complet',
                      controller: _nameController,
                      prefixIcon: Icon(Icons.person),
                    ),
                    
                    SizedBox(height: 24),
                    
                    CustomButton(
                      text: 'Enregistrer',
                      isLoading: _isLoading,
                      onPressed: _handleSubmit,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 24),
              
              // Options
              OptionsList(
                items: [
                  OptionItem(
                    title: 'Paramètres',
                    icon: Icons.settings,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
```

---

## 💡 Conseils

### 1. Imports
Importez uniquement les widgets dont vous avez besoin :
```dart
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
```

### 2. Couleurs
Utilisez toujours `AppColors` :
```dart
color: AppColors.primary  // ✅ Bon
color: Color(0xFF0066FF)  // ❌ Éviter
```

### 3. Espacements
Utilisez des multiples de 4 :
```dart
SizedBox(height: 16)  // ✅ Bon
SizedBox(height: 15)  // ❌ Éviter
```

### 4. Feedback Utilisateur
Toujours donner un feedback :
```dart
// Après une action réussie
CustomSnackBar.show(
  context: context,
  message: 'Opération réussie',
  type: SnackBarType.success,
)
```

### 5. Gestion d'Erreurs
```dart
try {
  await action();
  CustomSnackBar.show(
    context: context,
    message: 'Succès',
    type: SnackBarType.success,
  );
} catch (e) {
  CustomSnackBar.show(
    context: context,
    message: 'Erreur: $e',
    type: SnackBarType.error,
  );
}
```

---

## 🔗 Ressources

- **Design System** : Voir `DESIGN_SYSTEM.md`
- **Widgets** : Dossier `/lib/widgets/`
- **Exemples** : Dossier `/lib/screens/`

---

**Dernière mise à jour** : 3 janvier 2026
