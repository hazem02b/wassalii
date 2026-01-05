import 'api_service.dart';

class MessageService {
  final ApiService _apiService = ApiService();

  // Envoyer un message
  Future<Map<String, dynamic>> sendMessage({
    required int receiverId,
    required String content,
  }) async {
    try {
      final response = await _apiService.post(
        '/messages/',
        data: {
          'receiver_id': receiverId,
          'content': content,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer toutes les conversations
  Future<List<dynamic>> getConversations() async {
    try {
      final response = await _apiService.get('/messages/conversations');
      return response.data as List<dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer les messages d'une conversation
  Future<List<dynamic>> getConversationMessages(int otherUserId) async {
    try {
      final response = await _apiService.get('/messages/conversation/$otherUserId');
      return response.data as List<dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  // Marquer un message comme lu
  Future<void> markAsRead(int messageId) async {
    try {
      await _apiService.put('/messages/$messageId/read');
    } catch (e) {
      rethrow;
    }
  }

  // Marquer tous les messages d'une conversation comme lus
  Future<void> markConversationAsRead(int otherUserId) async {
    try {
      await _apiService.put('/messages/conversation/$otherUserId/read');
    } catch (e) {
      rethrow;
    }
  }
}
