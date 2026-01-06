# 🧪 Guide de Test de l'API Wassali

## ✅ Étape 1 : Ouvrir la Documentation

Le serveur est déjà lancé sur : http://localhost:8000

Ouvrez la documentation interactive : **http://localhost:8000/api/v1/docs**

## 📝 Étape 2 : Créer un Transporteur

1. Dans Swagger UI, trouvez la section **Authentication**
2. Cliquez sur `POST /api/v1/auth/register`
3. Cliquez sur "Try it out"
4. Remplissez les données :

```json
{
  "email": "ahmed@transport.ma",
  "password": "Ahmed123!",
  "first_name": "Ahmed",
  "last_name": "Benali",
  "phone": "+212612345678",
  "role": "transporter"
}
```

5. Cliquez sur "Execute"
6. **IMPORTANT** : Copiez le `access_token` retourné !

## 👤 Étape 3 : Créer un Client

Répétez l'opération avec ces données :

```json
{
  "email": "fatima@client.fr",
  "password": "Fatima123!",
  "first_name": "Fatima",
  "last_name": "Dubois",
  "phone": "+33612345678",
  "role": "client"
}
```

## 🔐 Étape 4 : S'Authentifier

1. En haut à droite de Swagger UI, cliquez sur le bouton **"Authorize"** (🔓)
2. Collez le `access_token` du transporteur
3. Cliquez sur "Authorize" puis "Close"

## 🚗 Étape 5 : Créer un Trajet

1. Trouvez `POST /api/v1/trips`
2. Cliquez sur "Try it out"
3. Remplissez :

```json
{
  "origin_city": "Casablanca",
  "origin_country": "Maroc",
  "destination_city": "Paris",
  "destination_country": "France",
  "departure_date": "2025-01-15T10:00:00",
  "arrival_date": "2025-01-16T08:00:00",
  "max_weight": 30,
  "available_weight": 30,
  "price_per_kg": 15,
  "description": "Trajet régulier Casablanca-Paris",
  "vehicle_info": "Voiture Citroën C5"
}
```

4. Cliquez sur "Execute"

## 📦 Étape 6 : Créer une Réservation

1. Déconnectez-vous (bouton "Authorize" → "Logout")
2. Reconnectez-vous avec le token du **client**
3. Trouvez `POST /api/v1/bookings`
4. Utilisez l'ID du trajet créé :

```json
{
  "trip_id": 1,
  "package_weight": 5,
  "package_description": "Vêtements et cadeaux",
  "pickup_address": "123 Rue de la Liberté, Paris",
  "delivery_address": "456 Boulevard Mohammed V, Casablanca"
}
```

## 🎉 Résultat

Vous avez maintenant :
- ✅ 2 utilisateurs (transporteur + client)
- ✅ 1 trajet
- ✅ 1 réservation

## 🔍 Autres Tests Disponibles

- `GET /api/v1/trips` - Voir tous les trajets
- `GET /api/v1/trips/search` - Rechercher des trajets
- `GET /api/v1/bookings/my` - Voir mes réservations
- `GET /api/v1/auth/profile` - Voir mon profil
- `PUT /api/v1/auth/profile` - Modifier mon profil

---

## 🐛 En cas d'erreur

Si vous voyez des erreurs 500, vérifiez :
1. Que la base de données PostgreSQL est bien lancée
2. Les logs du serveur dans le terminal
3. Que tous les champs requis sont bien remplis
