import '../models/user.dart';
import '../config/api_config.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  
  User? _currentUser;
  
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  
  // Login
  Future<User> login(String email, String password, {UserType? userType}) async {
    // MODE DÉVELOPPEMENT - Connexion simulée
    if (ApiConfig.isDevelopmentMode) {
      await Future.delayed(const Duration(seconds: 1)); // Simuler latence réseau
      
      // Valider les identifiants (accepter n'importe quel email/password pour le dev)
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email et mot de passe requis');
      }
      
      // Déterminer le type d'utilisateur basé sur l'email
        // If a userType is provided (from the UI), use it in dev-mode.
        final resolvedType = userType ?? (email.contains('transport')
          ? UserType.transporter
          : UserType.client);
      
      // Créer un utilisateur mock
      final mockUser = User(
        id: 'dev-user-${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        firstName: 'Utilisateur',
        lastName: 'Test',
        phone: '+33612345678',
        userType: resolvedType,
        createdAt: DateTime.now(),
      );
      
      // Sauvegarder le token et l'utilisateur
      await _storageService.saveToken('dev-token-${DateTime.now().millisecondsSinceEpoch}');
      _currentUser = mockUser;
      await _storageService.saveUser(_currentUser!);
      
      return _currentUser!;
    }
    
    // MODE PRODUCTION - API réelle
    try {
      print('🔐 Tentative de connexion à: ${ApiConfig.baseUrl}${ApiConfig.login}');
      print('📧 Email: $email, Role: ${userType == UserType.transporter ? 'transporter' : 'client'}');
      
      final response = await _apiService.post(
        ApiConfig.login,
        data: {
          'email': email,
          'password': password,
          'role': userType == UserType.transporter ? 'transporter' : 'client',
        },
      );
      
      print('✅ Réponse reçue: ${response.statusCode}');
      
      final data = response.data;
      // Le backend peut renvoyer 'token' ou 'access_token'
      final token = data['access_token'] ?? data['token'];
      final userData = data['user'];
      
      // Save token
      await _storageService.saveToken(token);
      _apiService.setAuthToken(token);
      
      // Save user
      _currentUser = User.fromJson(userData);
      await _storageService.saveUser(_currentUser!);
      
      print('✅ Utilisateur connecté: ${_currentUser!.email}');
      return _currentUser!;
    } catch (e) {
      print('❌ Erreur de connexion: $e');
      throw Exception('Erreur de connexion: ${e.toString()}');
    }
  }
  
  // Register
  Future<User> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required UserType userType,
    String? phone,
  }) async {
    // MODE DÉVELOPPEMENT - Inscription simulée
    if (ApiConfig.isDevelopmentMode) {
      await Future.delayed(const Duration(seconds: 1));
      
      if (email.isEmpty || password.isEmpty || firstName.isEmpty || lastName.isEmpty) {
        throw Exception('Tous les champs sont requis');
      }
      
      // Créer un utilisateur mock
      final mockUser = User(
        id: 'dev-user-${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        userType: userType,
        createdAt: DateTime.now(),
      );
      
      // Sauvegarder
      await _storageService.saveToken('dev-token-${DateTime.now().millisecondsSinceEpoch}');
      _currentUser = mockUser;
      await _storageService.saveUser(_currentUser!);
      
      return _currentUser!;
    }
    
    // MODE PRODUCTION - API réelle
    try {
      // Le backend attend 'name' (nom complet) au lieu de firstName/lastName séparés
      final fullName = '$firstName $lastName';
      
      // Déterminer l'endpoint selon le type d'utilisateur
      final endpoint = userType == UserType.client 
          ? '/auth/register/client'
          : '/auth/register/transporter';
      
      final response = await _apiService.post(
        endpoint,
        data: {
          'email': email,
          'password': password,
          'name': fullName,  // Backend attend 'name' pas 'firstName'/'lastName'
          'phone': phone,
        },
      );
      
      final data = response.data;
      // Le backend peut renvoyer 'token' ou 'access_token'
      final token = data['access_token'] ?? data['token'];
      final userData = data['user'];
      
      // Save token
      await _storageService.saveToken(token);
      _apiService.setAuthToken(token);
      
      // Save user
      _currentUser = User.fromJson(userData);
      await _storageService.saveUser(_currentUser!);
      
      return _currentUser!;
    } catch (e) {
      throw Exception('Erreur d\'inscription: ${e.toString()}');
    }
  }
  
  // Logout
  Future<void> logout() async {
    // Note: Backend doesn't have logout endpoint, so we just clear local data
    await _storageService.clearToken();
    await _storageService.clearUser();
    _apiService.clearAuthToken();
    _currentUser = null;
  }
  
  // Forgot Password
  Future<void> forgotPassword(String email) async {
    try {
      await _apiService.post(
        ApiConfig.forgotPassword,
        data: {'email': email},
      );
    } catch (e) {
      throw Exception('Erreur: ${e.toString()}');
    }
  }
  
  // Reset Password
  Future<void> resetPassword(String token, String newPassword) async {
    try {
      await _apiService.post(
        ApiConfig.resetPassword,
        data: {
          'token': token,
          'password': newPassword,
        },
      );
    } catch (e) {
      throw Exception('Erreur: ${e.toString()}');
    }
  }
  
  // Change Password
  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      await _apiService.post(
        ApiConfig.changePassword,
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      );
    } catch (e) {
      throw Exception('Erreur: ${e.toString()}');
    }
  }
  
  // Load saved session
  Future<bool> loadSavedSession() async {
    try {
      final token = await _storageService.getToken();
      final userData = await _storageService.getUser();
      
      if (token != null && userData != null) {
        _apiService.setAuthToken(token);
        _currentUser = userData;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  // Update Profile
  Future<User> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.put(ApiConfig.updateProfile, data: data);
      _currentUser = User.fromJson(response.data);
      await _storageService.saveUser(_currentUser!);
      return _currentUser!;
    } catch (e) {
      throw Exception('Erreur: ${e.toString()}');
    }
  }
  
  // Get Current User from API
  Future<User?> getCurrentUser({bool forceRefresh = false}) async {
    try {
      // Si forceRefresh, aller directement sur l'API
      if (!forceRefresh) {
        // Essayer d'abord de charger depuis le cache
        final cachedUser = await _storageService.getUser();
        if (cachedUser != null) {
          _currentUser = cachedUser;
          return _currentUser;
        }
      }
      
      // Charger depuis l'API
      final response = await _apiService.get('/auth/me');
      if (response.data != null) {
        _currentUser = User.fromJson(response.data);
        await _storageService.saveUser(_currentUser!);
        return _currentUser;
      }
      return null;
    } catch (e) {
      // Si l'API échoue, retourner l'utilisateur en cache ou actuel
      return _currentUser ?? await _storageService.getUser();
    }
  }
}
