class ApiConfig {
  // MODE DÉVELOPPEMENT - Mettre à false pour utiliser le vrai backend
  static const bool isDevelopmentMode = false;  // Backend réel activé
  
  // Base URL - Backend local ou serveur (FastAPI)
  static const String baseUrl = 'http://localhost:8000/api/v1';
  
  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String changePassword = '/auth/change-password';
  
  // User Endpoints
  static const String profile = '/users/profile';
  static const String updateProfile = '/users/profile';
  static const String uploadAvatar = '/users/avatar';
  
  // Booking Endpoints
  static const String bookings = '/bookings';
  static const String createBooking = '/bookings';
  static const String bookingDetails = '/bookings/{id}';
  static const String cancelBooking = '/bookings/{id}/cancel';
  static const String acceptBooking = '/bookings/{id}/accept';
  static const String completeBooking = '/bookings/{id}/complete';
  
  // Trip Endpoints
  static const String trips = '/trips';
  static const String createTrip = '/trips';
  static const String tripDetails = '/trips/{id}';
  static const String updateTrip = '/trips/{id}';
  static const String deleteTrip = '/trips/{id}';
  static const String searchTrips = '/trips/search';
  
  // Review Endpoints
  static const String reviews = '/reviews';
  static const String createReview = '/reviews';
  static const String userReviews = '/reviews/user/{userId}';
  
  // Payment Endpoints
  static const String paymentMethods = '/payment/methods';
  static const String addPaymentMethod = '/payment/methods';
  static const String processPayment = '/payment/process';
  
  // Chat Endpoints
  static const String conversations = '/chat/conversations';
  static const String messages = '/chat/messages';
  static const String sendMessage = '/chat/messages';
  
  // Notification Endpoints
  static const String notifications = '/notifications';
  static const String markAsRead = '/notifications/{id}/read';
  
  // Helper Methods
  static String getEndpoint(String endpoint, {Map<String, String>? params}) {
    String url = baseUrl + endpoint;
    if (params != null) {
      params.forEach((key, value) {
        url = url.replaceAll('{$key}', value);
      });
    }
    return url;
  }
}
