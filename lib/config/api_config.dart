class ApiConfig {
  // MODE DÉVELOPPEMENT - Mettre à false pour utiliser le vrai backend
  static const bool isDevelopmentMode = false;  // Backend réel activé
  
  // Base URL - Render (production)
  static const String baseUrl = 'https://wassali-backend.onrender.com/api/v1';
  
  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String changePassword = '/auth/change-password';