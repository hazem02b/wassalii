import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;
  bool get isClient => _currentUser?.userType == UserType.client;
  bool get isTransporter => _currentUser?.userType == UserType.transporter;
  
  AuthProvider() {
    _loadSavedSession();
  }
  
  Future<void> _loadSavedSession() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final success = await _authService.loadSavedSession();
      if (success) {
        _currentUser = _authService.currentUser;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> login(String email, String password, {UserType? userType}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _currentUser = await _authService.login(email, password, userType: userType);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required UserType userType,
    String? phone,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _currentUser = await _authService.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        userType: userType,
        phone: phone,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _authService.logout();
      _currentUser = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> forgotPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      await _authService.forgotPassword(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> resetPassword(String token, String newPassword) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      await _authService.resetPassword(token, newPassword);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      await _authService.changePassword(oldPassword, newPassword);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _currentUser = await _authService.updateProfile(data);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<void> refreshCurrentUser() async {
    try {
      final user = await _authService.getCurrentUser(forceRefresh: true);
      if (user != null) {
        _currentUser = user;
        notifyListeners();
      }
    } catch (e) {
      // Ignorer les erreurs de rafraîchissement
    }
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
