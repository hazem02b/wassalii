import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'fr': {
      // Navigation
      'home': 'Accueil',
      'search': 'Rechercher',
      'bookings': 'Réservations',
      'messages': 'Messages',
      'profile': 'Profil',
      
      // Home Screen
      'welcome': 'Bienvenue',
      'recent_searches': 'Recherches récentes',
      'from': 'Départ',
      'to': 'Arrivée',
      'search_trips': 'Rechercher des trajets',
      'no_recent_searches': 'Aucune recherche récente',
      
      // Bookings
      'my_bookings': 'Mes réservations',
      'active': 'Actives',
      'history': 'Historique',
      'booking_number': 'Réservation #',
      'departure': 'Départ',
      'arrival': 'Arrivée',
      'date': 'Date',
      'weight': 'Poids',
      'price': 'Prix',
      'payment': 'Paiement',
      'paid': 'Payé',
      'pending': 'En attente',
      'confirmed': 'Confirmée',
      'delivered': 'Livrée',
      'in_transit': 'En transit',
      'cancelled': 'Annulée',
      
      // Profile
      'my_profile': 'Mon Profil',
      'information': 'Informations',
      'statistics': 'Statistiques',
      'security': 'Sécurité',
      'edit_profile': 'Modifier le profil',
      'change_password': 'Changer le mot de passe',
      'settings': 'Paramètres',
      'help_support': 'Aide et support',
      'logout': 'Déconnexion',
      
      // Settings
      'appearance': 'Apparence',
      'language': 'Langue',
      'dark_mode': 'Mode sombre',
      'light_mode': 'Mode clair',
      'enable_dark_theme': 'Activer le thème sombre',
      'account': 'Compte',
      'help': 'Aide & Support',
      'about': 'À propos',
      'version': 'Version',
      
      // Common
      'save': 'Enregistrer',
      'cancel': 'Annuler',
      'ok': 'OK',
      'yes': 'Oui',
      'no': 'Non',
      'loading': 'Chargement...',
      'error': 'Erreur',
      'success': 'Succès',
      
      // Home Screen - Additional
      'hello': 'Bonjour',
      'where_to_send': 'Où envoyer aujourd\'hui ?',
      'search_transporters': 'Rechercher des transporters',
      'today': 'Aujourd\'hui',
      
      // Settings Page
      'app_language': 'Langue de l\'application',
      'enable_dark_mode': 'Activer le thème sombre',
      'edit_information': 'Modifier vos informations',
      'account_security': 'Sécurité du compte',
      'help_center': 'Centre d\'aide',
      'faq_guides': 'FAQ et guides',
      'disconnect': 'Déconnexion',
      'app_description': 'Application de livraison de colis entre la Tunisie et la France.',
      
      // Profile Screen
      'my_profile': 'Mon Profil',
      'edit_profile_button': 'Modifier le profil',
      'my_bookings_button': 'Mes réservations',
      'total_bookings': 'Réservations totales',
      'active_trips': 'Trajets actifs',
      'completed_deliveries': 'Livraisons complétées',
      'full_address': 'Votre adresse complète',
      'first_name': 'Prénom',
      'last_name': 'Nom',
      'email': 'Email',
      'phone': 'Téléphone',
      'address': 'Adresse',
      'city': 'Ville',
      'postal_code': 'Code postal',
      'current_password': 'Mot de passe actuel',
      'new_password': 'Nouveau mot de passe',
      'confirm_password': 'Confirmer le mot de passe',
      
      // Statistics
      'my_statistics': 'Mes Statistiques',
      'activity_overview': 'Aperçu de votre activité',
      'total_reservations': 'Total Réservations',
      'active_reservations': 'Réservations Actives',
      'completed_reservations': 'Réservations Complétées',
      'total_spent': 'Total Dépensé',
      'total_trips': 'Total Trajets',
      'total_revenue': 'Revenu Total',
      'active_trips_stat': 'Trajets Actifs',
      'loading_statistics': 'Chargement des statistiques...',
      
      // Tab labels
      'information_tab': 'Informations',
      'statistics_tab': 'Statistiques',
      'security_tab': 'Sécurité',
      
      // Form labels
      'full_name': 'Nom complet',
      'your_full_name': 'Votre nom complet',
      'your_phone_number': 'Votre numéro de téléphone',
      'your_full_address': 'Votre adresse complète',
      'cancel': 'Annuler',
      'save': 'Sauvegarder',
      'please_enter_new_password': 'Veuillez entrer un nouveau mot de passe',
      
      // Messages Screen
      'new_message': 'Nouveau message',
      'no_conversations': 'Aucune conversation',
      'start_conversation': 'Commencez une conversation',
      'send': 'Envoyer',
      'type_message': 'Tapez un message...',
      
      // Bookings Screen
      'no_bookings': 'Aucune réservation',
      'my_bookings': 'Mes réservations',
      'active_tab': 'Actives',
      'history_tab': 'Historique',
      'no_history': 'Aucun historique',
      'active_bookings_appear_here': 'Vos réservations actives apparaîtront ici',
      'history_appear_here': 'Votre historique de réservations apparaîtra ici',
      'filter_all': 'Toutes',
      'filter_pending': 'En attente',
      'filter_confirmed': 'Confirmées',
      'filter_completed': 'Terminées',
      'status_confirmed': 'Confirmée',
      'status_pending': 'En attente',
      'status_delivered': 'Livrée',
      'status_in_transit': 'En transit',
      'status_cancelled': 'Annulée',
      'payment_status': 'Paiement',
      'paid': 'Payé',
      'awaiting_payment': 'En attente',
      'awaiting_approval': '⏳ En attente d\'approbation',
      'package_in_delivery': '🚚 Colis en cours de livraison',
      'view_details': 'Voir détails',
      
      // Common Actions
      'edit': 'Modifier',
      'delete': 'Supprimer',
      'confirm': 'Confirmer',
      'back': 'Retour',
      'close': 'Fermer',
      'search': 'Rechercher',
      
      // Transporter Dashboard
      'ready_to_transport': 'Prêt à transporter aujourd\'hui ?',
      'pending_reservations': 'Réservations en attente',
      'monthly_revenue': 'Revenus ce mois',
      'no_pending_reservations': 'Aucune réservation en attente',
      'confirmed_paid': 'Confirmées & Payées - Prêt à livrer',
      'no_confirmed_paid': 'Aucune réservation confirmée et payée',
      'in_delivery': 'Livraisons en cours',
      'no_in_delivery': 'Aucune livraison en cours',
      'publish_new_trip': 'Publier un nouveau trajet',
      'my_reviews': 'Mes avis',
      'accept': 'Accepter',
      'refuse': 'Refuser',
      'start_delivery': 'Démarrer la livraison',
      'mark_delivered': 'Marquer comme livré',
      'reservation_accepted': '✅ Réservation acceptée! Le client sera notifié.',
      'reservation_refused': '❌ Réservation refusée. Le client sera notifié.',
      'delivery_started': '🚚 Livraison démarrée!',
      'delivery_completed': '✅ Livraison confirmée! Le client peut maintenant laisser un avis.',
      
      // My Trips Screen
      'my_trips': 'Mes trajets',
      'past': 'Passés',
      'no_trips': 'Aucun trajet',
      'dashboard': 'Dashboard',
      'trips': 'Trips',
      'create': 'Create',
      
      // Create Trip Screen
      'create_new_trip': 'Publier un nouveau trajet',
      'trip_details': 'Détails du trajet',
      'departure': 'Départ',
      'arrival': 'Arrivée',
      'departure_city': 'Ville de départ',
      'arrival_city': 'Ville d\'arrivée',
      'departure_date': 'Date de départ',
      'departure_time': 'Heure de départ',
      'select_date': 'Sélectionner une date',
      'select_time': 'Sélectionner une heure',
      'vehicle_info': 'Informations du véhicule',
      'vehicle_type': 'Type de véhicule',
      'car': 'Voiture',
      'van': 'Camionnette',
      'truck': 'Camion',
      'motorcycle': 'Moto',
      'pricing': 'Tarification',
      'price_per_kg': 'Prix par kg (€)',
      'available_space': 'Espace disponible (kg)',
      'price_negotiable': 'Prix négociable',
      'trip_type': 'Type de trajet',
      'one_time': 'Ponctuel',
      'regular': 'Régulier',
      'weekly': 'Hebdomadaire',
      'monthly': 'Mensuel',
      'accepted_items': 'Articles acceptés',
      'documents': 'Documents',
      'clothing': 'Vêtements',
      'electronics': 'Électronique',
      'food': 'Alimentation',
      'books': 'Livres',
      'furniture': 'Meubles',
      'additional_info': 'Informations additionnelles',
      'trip_description': 'Description du trajet',
      'optional': 'Optionnel',
      'offer_insurance': 'Offrir une couverture d\'assurance',
      'publish_trip': 'Publier le trajet',
      'trip_created_success': 'Trajet créé avec succès',
      'error': 'Erreur',
      'route_information': 'Informations sur l\'itinéraire',
      'from_example': 'De (ex: Casablanca)',
      'to_example': 'À (ex: Marrakech)',
      'schedule': 'Horaire',
      'capacity_pricing': 'Capacité et tarification',
      'total_capacity': 'Capacité totale (kg)',
      'select_vehicle_type': 'Sélectionner le type de véhicule',
      'motorcycle': 'Moto',
      'weekly': 'Hebdomadaire',
      'monthly': 'Mensuel',
      'additional_information': 'Informations supplémentaires',
      'description_optional': 'Description (optionnelle)',
      'required': 'Requis',
      
      // Transporter Profile Screen
      'transporter_profile': 'Mon Profil',
      'rating': 'Note',
      'total_revenue': 'Revenus totaux',
      'information': 'Informations',
      'modify_profile': 'Modifier le profil',
      'help_and_support': 'Aide & Support',
      'logout_confirmation': 'Déconnexion',
      'logout_message': 'Êtes-vous sûr de vouloir vous déconnecter ?',
      'help_page_coming': 'Page d\'aide à venir',
    },
    'en': {
      // Navigation
      'home': 'Home',
      'search': 'Search',
      'bookings': 'Bookings',
      'messages': 'Messages',
      'profile': 'Profile',
      
      // Home Screen
      'welcome': 'Welcome',
      'recent_searches': 'Recent searches',
      'from': 'From',
      'to': 'To',
      'search_trips': 'Search trips',
      'no_recent_searches': 'No recent searches',
      
      // Bookings
      'my_bookings': 'My bookings',
      'active': 'Active',
      'history': 'History',
      'booking_number': 'Booking #',
      'departure': 'Departure',
      'arrival': 'Arrival',
      'date': 'Date',
      'weight': 'Weight',
      'price': 'Price',
      'payment': 'Payment',
      'paid': 'Paid',
      'pending': 'Pending',
      'confirmed': 'Confirmed',
      'delivered': 'Delivered',
      'in_transit': 'In transit',
      'cancelled': 'Cancelled',
      
      // Profile
      'my_profile': 'My Profile',
      'information': 'Information',
      'statistics': 'Statistics',
      'security': 'Security',
      'edit_profile': 'Edit profile',
      'change_password': 'Change password',
      'settings': 'Settings',
      'help_support': 'Help & Support',
      'logout': 'Logout',
      
      // Settings
      'appearance': 'Appearance',
      'language': 'Language',
      'dark_mode': 'Dark mode',
      'light_mode': 'Light mode',
      'enable_dark_theme': 'Enable dark theme',
      'account': 'Account',
      'help': 'Help & Support',
      'about': 'About',
      'version': 'Version',
      
      // Common
      'save': 'Save',
      'cancel': 'Cancel',
      'ok': 'OK',
      'yes': 'Yes',
      'no': 'No',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      
      // Home Screen - Additional
      'hello': 'Hello',
      'where_to_send': 'Where to send today?',
      'search_transporters': 'Search transporters',
      'today': 'Today',
      
      // Settings Page
      'app_language': 'Application language',
      'enable_dark_mode': 'Enable dark theme',
      'edit_information': 'Edit your information',
      'account_security': 'Account security',
      'help_center': 'Help center',
      'faq_guides': 'FAQ and guides',
      'disconnect': 'Logout',
      'app_description': 'Parcel delivery application between Tunisia and France.',
      
      // Profile Screen
      'my_profile': 'My Profile',
      'edit_profile_button': 'Edit profile',
      'my_bookings_button': 'My bookings',
      'total_bookings': 'Total bookings',
      'active_trips': 'Active trips',
      'completed_deliveries': 'Completed deliveries',
      'full_address': 'Your full address',
      'first_name': 'First name',
      'last_name': 'Last name',
      'email': 'Email',
      'phone': 'Phone',
      'address': 'Address',
      'city': 'City',
      'postal_code': 'Postal code',
      'current_password': 'Current password',
      'new_password': 'New password',
      'confirm_password': 'Confirm password',
      
      // Statistics
      'my_statistics': 'My Statistics',
      'activity_overview': 'Overview of your activity',
      'total_reservations': 'Total Bookings',
      'active_reservations': 'Active Bookings',
      'completed_reservations': 'Completed Bookings',
      'total_spent': 'Total Spent',
      'total_trips': 'Total Trips',
      'total_revenue': 'Total Revenue',
      'active_trips_stat': 'Active Trips',
      'loading_statistics': 'Loading statistics...',
      
      // Tab labels
      'information_tab': 'Information',
      'statistics_tab': 'Statistics',
      'security_tab': 'Security',
      
      // Form labels
      'full_name': 'Full name',
      'your_full_name': 'Your full name',
      'your_phone_number': 'Your phone number',
      'your_full_address': 'Your full address',
      'cancel': 'Cancel',
      'save': 'Save',
      'please_enter_new_password': 'Please enter a new password',
      
      // Messages Screen
      'new_message': 'New message',
      'no_conversations': 'No conversations',
      'start_conversation': 'Start a conversation',
      'send': 'Send',
      'type_message': 'Type a message...',
      
      // Bookings Screen
      'no_bookings': 'No bookings',
      'my_bookings': 'My bookings',
      'active_tab': 'Active',
      'history_tab': 'History',
      'no_history': 'No history',
      'active_bookings_appear_here': 'Your active bookings will appear here',
      'history_appear_here': 'Your booking history will appear here',
      'filter_all': 'All',
      'filter_pending': 'Pending',
      'filter_confirmed': 'Confirmed',
      'filter_completed': 'Completed',
      'status_confirmed': 'Confirmed',
      'status_pending': 'Pending',
      'status_delivered': 'Delivered',
      'status_in_transit': 'In transit',
      'status_cancelled': 'Cancelled',
      'payment_status': 'Payment',
      'paid': 'Paid',
      'awaiting_payment': 'Awaiting',
      'awaiting_approval': '⏳ Awaiting approval',
      'package_in_delivery': '🚚 Package in delivery',
      'view_details': 'View details',
      
      // Common Actions
      'edit': 'Edit',
      'delete': 'Delete',
      'confirm': 'Confirm',
      'back': 'Back',
      'close': 'Close',
      'search': 'Search',
      
      // Transporter Dashboard
      'ready_to_transport': 'Ready to transport today?',
      'pending_reservations': 'Pending reservations',
      'monthly_revenue': 'Monthly revenue',
      'no_pending_reservations': 'No pending reservations',
      'confirmed_paid': 'Confirmed & Paid - Ready to deliver',
      'no_confirmed_paid': 'No confirmed and paid reservations',
      'in_delivery': 'In delivery',
      'no_in_delivery': 'No deliveries in progress',
      'publish_new_trip': 'Publish a new trip',
      'my_reviews': 'My reviews',
      'accept': 'Accept',
      'refuse': 'Refuse',
      'start_delivery': 'Start delivery',
      'mark_delivered': 'Mark as delivered',
      'reservation_accepted': '✅ Reservation accepted! Client will be notified.',
      'reservation_refused': '❌ Reservation refused. Client will be notified.',
      'delivery_started': '🚚 Delivery started!',
      'delivery_completed': '✅ Delivery confirmed! Client can now leave a review.',
      
      // My Trips Screen
      'my_trips': 'My trips',
      'past': 'Past',
      'no_trips': 'No trips',
      'dashboard': 'Dashboard',
      'trips': 'Trips',
      'create': 'Create',
      
      // Create Trip Screen
      'create_new_trip': 'Publish a new trip',
      'trip_details': 'Trip details',
      'departure': 'Departure',
      'arrival': 'Arrival',
      'departure_city': 'Departure city',
      'arrival_city': 'Arrival city',
      'departure_date': 'Departure date',
      'departure_time': 'Departure time',
      'select_date': 'Select date',
      'select_time': 'Select time',
      'vehicle_info': 'Vehicle information',
      'vehicle_type': 'Vehicle type',
      'car': 'Car',
      'van': 'Van',
      'truck': 'Truck',
      'pricing': 'Pricing',
      'price_per_kg': 'Price per kg (€)',
      'available_space': 'Available space (kg)',
      'price_negotiable': 'Negotiable price',
      'trip_type': 'Trip type',
      'one_time': 'One-time',
      'regular': 'Regular',
      'weekly': 'Weekly',
      'monthly': 'Monthly',
      'motorcycle': 'Motorcycle',
      'accepted_items': 'Accepted items',
      'documents': 'Documents',
      'clothing': 'Clothing',
      'electronics': 'Electronics',
      'food': 'Food',
      'books': 'Books',
      'furniture': 'Furniture',
      'additional_info': 'Additional information',
      'trip_description': 'Trip description',
      'optional': 'Optional',
      'offer_insurance': 'Offer insurance coverage',
      'publish_trip': 'Publish trip',
      'trip_created_success': 'Trip created successfully',
      'error': 'Error',
      'route_information': 'Route information',
      'from_example': 'From (e.g.: Casablanca)',
      'to_example': 'To (e.g.: Marrakech)',
      'schedule': 'Schedule',
      'capacity_pricing': 'Capacity and pricing',
      'total_capacity': 'Total capacity (kg)',
      'select_vehicle_type': 'Select vehicle type',
      'additional_information': 'Additional information',
      'description_optional': 'Description (optional)',
      'required': 'Required',
      
      // Transporter Profile Screen
      'transporter_profile': 'My Profile',
      'rating': 'Rating',
      'total_revenue': 'Total Revenue',
      'information': 'Information',
      'modify_profile': 'Edit profile',
      'help_and_support': 'Help & Support',
      'logout_confirmation': 'Logout',
      'logout_message': 'Are you sure you want to log out?',
      'help_page_coming': 'Help page coming soon',
      'profile_not_found': 'Profile not found',
    },
    'ar': {
      // Navigation
      'home': 'الرئيسية',
      'search': 'بحث',
      'bookings': 'الحجوزات',
      'messages': 'الرسائل',
      'profile': 'الملف الشخصي',
      
      // Home Screen
      'welcome': 'مرحباً',
      'recent_searches': 'عمليات البحث الأخيرة',
      'from': 'من',
      'to': 'إلى',
      'search_trips': 'البحث عن رحلات',
      'no_recent_searches': 'لا توجد عمليات بحث حديثة',
      
      // Bookings
      'my_bookings': 'حجوزاتي',
      'active': 'نشطة',
      'history': 'السجل',
      'booking_number': 'الحجز #',
      'departure': 'المغادرة',
      'arrival': 'الوصول',
      'date': 'التاريخ',
      'weight': 'الوزن',
      'price': 'السعر',
      'payment': 'الدفع',
      'paid': 'مدفوع',
      'pending': 'قيد الانتظار',
      'confirmed': 'مؤكد',
      'delivered': 'تم التسليم',
      'in_transit': 'في الطريق',
      'cancelled': 'ملغى',
      
      // Profile
      'my_profile': 'ملفي الشخصي',
      'information': 'المعلومات',
      'statistics': 'الإحصائيات',
      'security': 'الأمان',
      'edit_profile': 'تعديل الملف',
      'change_password': 'تغيير كلمة المرور',
      'settings': 'الإعدادات',
      'help_support': 'المساعدة والدعم',
      'logout': 'تسجيل الخروج',
      
      // Settings
      'appearance': 'المظهر',
      'language': 'اللغة',
      'dark_mode': 'الوضع الداكن',
      'light_mode': 'الوضع الفاتح',
      'enable_dark_theme': 'تفعيل الوضع الداكن',
      'account': 'الحساب',
      'help': 'المساعدة والدعم',
      'about': 'حول',
      'version': 'الإصدار',
      
      // Common
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'ok': 'موافق',
      'yes': 'نعم',
      'no': 'لا',
      'loading': 'جاري التحميل...',
      'error': 'خطأ',
      'success': 'نجح',
      
      // Home Screen - Additional
      'hello': 'مرحباً',
      'where_to_send': 'أين تريد الإرسال اليوم؟',
      'search_transporters': 'البحث عن ناقلين',
      'today': 'اليوم',
      
      // Settings Page
      'app_language': 'لغة التطبيق',
      'enable_dark_mode': 'تفعيل الوضع الداكن',
      'edit_information': 'تعديل معلوماتك',
      'account_security': 'أمان الحساب',
      'help_center': 'مركز المساعدة',
      'faq_guides': 'الأسئلة الشائعة والأدلة',
      'disconnect': 'تسجيل الخروج',
      'app_description': 'تطبيق توصيل الطرود بين تونس وفرنسا.',
      
      // Profile Screen
      'my_profile': 'ملفي الشخصي',
      'edit_profile_button': 'تعديل الملف',
      'my_bookings_button': 'حجوزاتي',
      'total_bookings': 'إجمالي الحجوزات',
      'active_trips': 'الرحلات النشطة',
      'completed_deliveries': 'التوصيلات المكتملة',
      'full_address': 'عنوانك الكامل',
      'first_name': 'الاسم الأول',
      'last_name': 'اسم العائلة',
      'email': 'البريد الإلكتروني',
      'phone': 'الهاتف',
      'address': 'العنوان',
      'city': 'المدينة',
      'postal_code': 'الرمز البريدي',
      'current_password': 'كلمة المرور الحالية',
      'new_password': 'كلمة المرور الجديدة',
      'confirm_password': 'تأكيد كلمة المرور',
      
      // Statistics
      'my_statistics': 'إحصائياتي',
      'activity_overview': 'نظرة عامة على نشاطك',
      'total_reservations': 'إجمالي الحجوزات',
      'active_reservations': 'الحجوزات النشطة',
      'completed_reservations': 'الحجوزات المكتملة',
      'total_spent': 'إجمالي الإنفاق',
      'total_trips': 'إجمالي الرحلات',
      'total_revenue': 'إجمالي الإيرادات',
      'active_trips_stat': 'الرحلات النشطة',
      'loading_statistics': 'جاري تحميل الإحصائيات...',
      
      // Tab labels
      'information_tab': 'المعلومات',
      'statistics_tab': 'الإحصائيات',
      'security_tab': 'الأمان',
      
      // Form labels
      'full_name': 'الاسم الكامل',
      'your_full_name': 'اسمك الكامل',
      'your_phone_number': 'رقم هاتفك',
      'your_full_address': 'عنوانك الكامل',
      'cancel': 'إلغاء',
      'save': 'حفظ',
      'please_enter_new_password': 'يرجى إدخال كلمة مرور جديدة',
      
      // Messages Screen
      'new_message': 'رسالة جديدة',
      'no_conversations': 'لا توجد محادثات',
      'start_conversation': 'ابدأ محادثة',
      'send': 'إرسال',
      'type_message': 'اكتب رسالة...',
      
      // Bookings Screen
      'no_bookings': 'لا توجد حجوزات',
      'my_bookings': 'حجوزاتي',
      'active_tab': 'النشطة',
      'history_tab': 'السجل',
      'no_history': 'لا يوجد سجل',
      'active_bookings_appear_here': 'ستظهر حجوزاتك النشطة هنا',
      'history_appear_here': 'سيظهر سجل حجوزاتك هنا',
      'filter_all': 'الكل',
      'filter_pending': 'قيد الانتظار',
      'filter_confirmed': 'مؤكدة',
      'filter_completed': 'مكتملة',
      'status_confirmed': 'مؤكد',
      'status_pending': 'قيد الانتظار',
      'status_delivered': 'تم التسليم',
      'status_in_transit': 'في الطريق',
      'status_cancelled': 'ملغى',
      'payment_status': 'الدفع',
      'paid': 'مدفوع',
      'awaiting_payment': 'في الانتظار',
      'awaiting_approval': '⏳ في انتظار الموافقة',
      'package_in_delivery': '🚚 الطرد في التوصيل',
      'view_details': 'عرض التفاصيل',
      
      // Common Actions
      'edit': 'تعديل',
      'delete': 'حذف',
      'confirm': 'تأكيد',
      'back': 'رجوع',
      'close': 'إغلاق',
      'search': 'بحث',
      
      // Transporter Dashboard
      'ready_to_transport': 'هل أنت مستعد للنقل اليوم؟',
      'pending_reservations': 'الحجوزات قيد الانتظار',
      'monthly_revenue': 'الإيرادات هذا الشهر',
      'no_pending_reservations': 'لا توجد حجوزات في الانتظار',
      'confirmed_paid': 'مؤكدة ومدفوعة - جاهزة للتسليم',
      'no_confirmed_paid': 'لا توجد حجوزات مؤكدة ومدفوعة',
      'in_delivery': 'التسليمات الجارية',
      'no_in_delivery': 'لا توجد تسليمات جارية',
      'publish_new_trip': 'نشر رحلة جديدة',
      'my_reviews': 'تقييماتي',
      'accept': 'قبول',
      'refuse': 'رفض',
      'start_delivery': 'بدء التسليم',
      'mark_delivered': 'تعليم كمُسلَّم',
      'reservation_accepted': '✅ تم قبول الحجز! سيتم إشعار العميل.',
      'reservation_refused': '❌ تم رفض الحجز. سيتم إشعار العميل.',
      'delivery_started': '🚚 بدأ التسليم!',
      'delivery_completed': '✅ تم تأكيد التسليم! يمكن للعميل الآن ترك تقييم.',
      
      // My Trips Screen
      'my_trips': 'رحلاتي',
      'past': 'السابقة',
      'no_trips': 'لا توجد رحلات',
      'dashboard': 'لوحة القيادة',
      'trips': 'الرحلات',
      'create': 'إنشاء',
      
      // Create Trip Screen
      'create_new_trip': 'نشر رحلة جديدة',
      'trip_details': 'تفاصيل الرحلة',
      'departure': 'المغادرة',
      'arrival': 'الوصول',
      'departure_city': 'مدينة المغادرة',
      'arrival_city': 'مدينة الوصول',
      'departure_date': 'تاريخ المغادرة',
      'departure_time': 'وقت المغادرة',
      'select_date': 'اختر التاريخ',
      'select_time': 'اختر الوقت',
      'vehicle_info': 'معلومات المركبة',
      'vehicle_type': 'نوع المركبة',
      'car': 'سيارة',
      'van': 'شاحنة صغيرة',
      'truck': 'شاحنة',
      'motorcycle': 'دراجة نارية',
      'pricing': 'التسعير',
      'price_per_kg': 'السعر لكل كجم (€)',
      'available_space': 'المساحة المتاحة (كجم)',
      'price_negotiable': 'السعر قابل للتفاوض',
      'trip_type': 'نوع الرحلة',
      'one_time': 'مرة واحدة',
      'regular': 'منتظمة',
      'weekly': 'أسبوعية',
      'monthly': 'شهرية',
      'accepted_items': 'العناصر المقبولة',
      'documents': 'وثائق',
      'clothing': 'ملابس',
      'electronics': 'إلكترونيات',
      'food': 'طعام',
      'books': 'كتب',
      'furniture': 'أثاث',
      'additional_info': 'معلومات إضافية',
      'trip_description': 'وصف الرحلة',
      'optional': 'اختياري',
      'offer_insurance': 'تقديم تغطية تأمينية',
      'publish_trip': 'نشر الرحلة',
      'trip_created_success': 'تم إنشاء الرحلة بنجاح',
      'error': 'خطأ',
      'route_information': 'معلومات المسار',
      'from_example': 'من (مثال: الدار البيضاء)',
      'to_example': 'إلى (مثال: مراكش)',
      'schedule': 'الجدول الزمني',
      'capacity_pricing': 'السعة والتسعير',
      'total_capacity': 'السعة الإجمالية (كجم)',
      'select_vehicle_type': 'اختر نوع المركبة',
      'additional_information': 'معلومات إضافية',
      'description_optional': 'الوصف (اختياري)',
      'required': 'مطلوب',
      
      // Transporter Profile Screen
      'transporter_profile': 'ملفي الشخصي',
      'rating': 'التقييم',
      'total_revenue': 'إجمالي الإيرادات',
      'information': 'المعلومات',
      'modify_profile': 'تعديل الملف',
      'help_and_support': 'المساعدة والدعم',
      'logout_confirmation': 'تسجيل الخروج',
      'logout_message': 'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
      'help_page_coming': 'صفحة المساعدة قادمة قريبًا',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  String get home => translate('home');
  String get search => translate('search');
  String get bookings => translate('bookings');
  String get messages => translate('messages');
  String get profile => translate('profile');
  String get welcome => translate('welcome');
  String get recentSearches => translate('recent_searches');
  String get from => translate('from');
  String get to => translate('to');
  String get searchTrips => translate('search_trips');
  String get myBookings => translate('my_bookings');
  String get active => translate('active');
  String get history => translate('history');
  String get myProfile => translate('my_profile');
  String get settings => translate('settings');
  String get darkMode => translate('dark_mode');
  String get lightMode => translate('light_mode');
  String get language => translate('language');
  String get appearance => translate('appearance');
  String get account => translate('account');
  String get logout => translate('logout');
  String get changePassword => translate('change_password');
  String get helpSupport => translate('help_support');
  String get about => translate('about');
  String get hello => translate('hello');
  String get whereToSend => translate('where_to_send');
  String get searchTransporters => translate('search_transporters');
  String get today => translate('today');
  String get appLanguage => translate('app_language');
  String get enableDarkMode => translate('enable_dark_mode');
  String get editInformation => translate('edit_information');
  String get accountSecurity => translate('account_security');
  String get helpCenter => translate('help_center');
  String get faqGuides => translate('faq_guides');
  String get disconnect => translate('disconnect');
  String get appDescription => translate('app_description');
  String get editProfileButton => translate('edit_profile_button');
  String get myBookingsButton => translate('my_bookings_button');
  String get totalBookings => translate('total_bookings');
  String get activeTrips => translate('active_trips');
  String get completedDeliveries => translate('completed_deliveries');
  String get fullAddress => translate('full_address');
  String get firstName => translate('first_name');
  String get lastName => translate('last_name');
  String get email => translate('email');
  String get phone => translate('phone');
  String get address => translate('address');
  String get city => translate('city');
  String get postalCode => translate('postal_code');
  String get currentPassword => translate('current_password');
  String get newPassword => translate('new_password');
  String get confirmPassword => translate('confirm_password');
  String get newMessage => translate('new_message');
  String get noConversations => translate('no_conversations');
  String get startConversation => translate('start_conversation');
  String get send => translate('send');
  String get typeMessage => translate('type_message');
  String get noBookings => translate('no_bookings');
  String get filterAll => translate('filter_all');
  String get filterPending => translate('filter_pending');
  String get filterConfirmed => translate('filter_confirmed');
  String get filterCompleted => translate('filter_completed');
  String get viewDetails => translate('view_details');
  String get edit => translate('edit');
  String get delete => translate('delete');
  String get confirm => translate('confirm');
  String get back => translate('back');
  String get close => translate('close');
  
  // Statistics getters
  String get myStatistics => translate('my_statistics');
  String get activityOverview => translate('activity_overview');
  String get totalReservations => translate('total_reservations');
  String get activeReservations => translate('active_reservations');
  String get completedReservations => translate('completed_reservations');
  String get totalSpent => translate('total_spent');
  String get totalTrips => translate('total_trips');
  String get totalRevenue => translate('total_revenue');
  String get activeTripsStats => translate('active_trips_stat');
  String get loadingStatistics => translate('loading_statistics');
  
  // Tab labels getters
  String get informationTab => translate('information_tab');
  String get statisticsTab => translate('statistics_tab');
  String get securityTab => translate('security_tab');
  
  // Form labels getters
  String get fullName => translate('full_name');
  String get yourFullName => translate('your_full_name');
  String get yourPhoneNumber => translate('your_phone_number');
  String get yourFullAddress => translate('your_full_address');
  String get cancel => translate('cancel');
  String get save => translate('save');
  String get pleaseEnterNewPassword => translate('please_enter_new_password');
  
  // Bookings screen getters
  String get myBookingsTitle => translate('my_bookings');
  String get activeTab => translate('active_tab');
  String get historyTab => translate('history_tab');
  String get noHistory => translate('no_history');
  String get activeBookingsAppearHere => translate('active_bookings_appear_here');
  String get historyAppearHere => translate('history_appear_here');
  String get statusConfirmed => translate('status_confirmed');
  String get statusPending => translate('status_pending');
  String get statusDelivered => translate('status_delivered');
  String get statusInTransit => translate('status_in_transit');
  String get statusCancelled => translate('status_cancelled');
  String get paymentStatus => translate('payment_status');
  String get paid => translate('paid');
  String get awaitingPayment => translate('awaiting_payment');
  String get awaitingApproval => translate('awaiting_approval');
  String get packageInDelivery => translate('package_in_delivery');
  
  // Transporter Dashboard getters
  String get readyToTransport => translate('ready_to_transport');
  String get pendingReservations => translate('pending_reservations');
  String get monthlyRevenue => translate('monthly_revenue');
  String get noPendingReservations => translate('no_pending_reservations');
  String get confirmedPaid => translate('confirmed_paid');
  String get noConfirmedPaid => translate('no_confirmed_paid');
  String get inDelivery => translate('in_delivery');
  String get noInDelivery => translate('no_in_delivery');
  String get publishNewTrip => translate('publish_new_trip');
  String get myReviews => translate('my_reviews');
  String get accept => translate('accept');
  String get refuse => translate('refuse');
  String get startDelivery => translate('start_delivery');
  String get markDelivered => translate('mark_delivered');
  String get reservationAccepted => translate('reservation_accepted');
  String get reservationRefused => translate('reservation_refused');
  String get deliveryStarted => translate('delivery_started');
  String get deliveryCompleted => translate('delivery_completed');
  
  // My Trips Screen getters
  String get myTrips => translate('my_trips');
  String get past => translate('past');
  String get noTrips => translate('no_trips');
  String get dashboard => translate('dashboard');
  String get trips => translate('trips');
  String get create => translate('create');
  
  // Create Trip Screen getters
  String get createNewTrip => translate('create_new_trip');
  String get tripDetails => translate('trip_details');
  String get departure => translate('departure');
  String get arrival => translate('arrival');
  String get departureCity => translate('departure_city');
  String get arrivalCity => translate('arrival_city');
  String get departureDate => translate('departure_date');
  String get departureTime => translate('departure_time');
  String get selectDate => translate('select_date');
  String get selectTime => translate('select_time');
  String get vehicleInfo => translate('vehicle_info');
  String get vehicleType => translate('vehicle_type');
  String get car => translate('car');
  String get van => translate('van');
  String get truck => translate('truck');
  String get pricing => translate('pricing');
  String get pricePerKg => translate('price_per_kg');
  String get availableSpace => translate('available_space');
  String get priceNegotiable => translate('price_negotiable');
  String get tripType => translate('trip_type');
  String get oneTime => translate('one_time');
  String get regular => translate('regular');
  String get acceptedItems => translate('accepted_items');
  String get documents => translate('documents');
  String get clothing => translate('clothing');
  String get electronics => translate('electronics');
  String get food => translate('food');
  String get books => translate('books');
  String get furniture => translate('furniture');
  String get additionalInfo => translate('additional_info');
  String get tripDescription => translate('trip_description');
  String get optional => translate('optional');
  String get offerInsurance => translate('offer_insurance');
  String get publishTrip => translate('publish_trip');
  String get tripCreatedSuccess => translate('trip_created_success');
  String get error => translate('error');
  String get routeInformation => translate('route_information');
  String get fromExample => translate('from_example');
  String get toExample => translate('to_example');
  String get schedule => translate('schedule');
  String get capacityPricing => translate('capacity_pricing');
  String get totalCapacity => translate('total_capacity');
  String get selectVehicleType => translate('select_vehicle_type');
  String get motorcycle => translate('motorcycle');
  String get weekly => translate('weekly');
  String get monthly => translate('monthly');
  String get additionalInformation => translate('additional_information');
  String get descriptionOptional => translate('description_optional');
  String get required => translate('required');
  
  // Transporter Profile getters
  String get transporterProfile => translate('transporter_profile');
  String get rating => translate('rating');
  String get information => translate('information');
  String get modifyProfile => translate('modify_profile');
  String get helpAndSupport => translate('help_and_support');
  String get logoutConfirmation => translate('logout_confirmation');
  String get logoutMessage => translate('logout_message');
  String get helpPageComing => translate('help_page_coming');
  String get profileNotFound => translate('profile_not_found');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['fr', 'en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => true;
}
