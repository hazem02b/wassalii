import 'api_service.dart';

class UserService {
  final ApiService _apiService = ApiService();

  // Récupérer le profil de l'utilisateur connecté
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _apiService.get('/users/me');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour le profil
  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? phone,
    String? email,
    String? address,
    String? city,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (name != null) data['name'] = name;
      if (phone != null) data['phone'] = phone;
      if (email != null) data['email'] = email;
      if (address != null) data['address'] = address;
      if (city != null) data['city'] = city;

      final response = await _apiService.put('/users/me', data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Changer le mot de passe
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await _apiService.put(
        '/auth/change-password',
        data: {
          'current_password': oldPassword,
          'new_password': newPassword,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  // Uploader une photo de profil
  Future<Map<String, dynamic>> uploadProfilePhoto(String filePath) async {
    try {
      final response = await _apiService.uploadFile(
        '/users/upload-photo',
        filePath,
        fieldName: 'file',
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour la photo de profil (base64)
  Future<Map<String, dynamic>> updateProfilePicture(String base64Image) async {
    try {
      final response = await _apiService.put(
        '/users/me/profile-picture',
        data: {'profile_picture': base64Image},
      );
      return {'success': true, 'message': 'Photo mise à jour'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Récupérer le profil d'un autre utilisateur
  Future<Map<String, dynamic>> getUserProfile(int userId) async {
    try {
      final response = await _apiService.get('/users/$userId');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer les statistiques du transporteur
  Future<Map<String, dynamic>> getTransporterStats() async {
    try {
      final response = await _apiService.get('/users/transporter-stats');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer les statistiques de l'utilisateur
  Future<Map<String, dynamic>> getUserStats() async {
    try {
      final response = await _apiService.get('/users/me/stats');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
