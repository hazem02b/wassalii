import 'api_service.dart';

class BookingService {
  final ApiService _apiService = ApiService();

  // Créer une réservation
  Future<Map<String, dynamic>> createBooking({
    required int tripId,
    required double weight,
    required String itemType,
    required String pickupAddress,
    required String pickupCity,
    required String deliveryAddress,
    required String deliveryCity,
    required String recipientName,
    required String recipientPhone,
    String? description,
    String? notes,
  }) async {
    try {
      final response = await _apiService.post(
        '/bookings/',
        data: {
          'trip_id': tripId,
          'weight': weight,
          'item_type': itemType,
          'pickup_address': pickupAddress,
          'pickup_city': pickupCity,
          'delivery_address': deliveryAddress,
          'delivery_city': deliveryCity,
          'recipient_name': recipientName,
          'recipient_phone': recipientPhone,
          if (description != null && description.isNotEmpty) 'description': description,
          if (notes != null && notes.isNotEmpty) 'notes': notes,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer les réservations du client
  Future<List<dynamic>> getMyBookings() async {
    try {
      final response = await _apiService.get('/bookings/my');
      return response.data as List<dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer toutes les réservations (pour transporteur - inclut toutes les réservations de ses trajets)
  Future<List<dynamic>> getAllBookings() async {
    try {
      final response = await _apiService.get('/bookings/');
      return response.data as List<dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer les réservations d'un trajet (pour transporteur)
  Future<List<dynamic>> getTripBookings(int tripId) async {
    try {
      final response = await _apiService.get('/bookings/trip/$tripId');
      return response.data as List<dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour une réservation (statut, paiement, etc.)
  Future<Map<String, dynamic>> updateBooking(int bookingId, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.put(
        '/bookings/$bookingId',
        data: data,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Accepter une réservation (transporteur)
  Future<Map<String, dynamic>> acceptBooking(int bookingId) async {
    return updateBooking(bookingId, {'status': 'confirmed'});
  }

  // Refuser une réservation (transporteur)
  Future<Map<String, dynamic>> rejectBooking(int bookingId) async {
    return updateBooking(bookingId, {'status': 'cancelled'});
  }

  // Démarrer la livraison (transporteur)
  Future<Map<String, dynamic>> startDelivery(int bookingId) async {
    return updateBooking(bookingId, {'status': 'in_transit'});
  }

  // Marquer comme livré (transporteur)
  Future<Map<String, dynamic>> markAsDelivered(int bookingId) async {
    return updateBooking(bookingId, {'status': 'delivered'});
  }

  // Mettre à jour le paiement (client)
  Future<Map<String, dynamic>> updatePayment(int bookingId, bool isPaid, String paymentMethod) async {
    return updateBooking(bookingId, {
      'is_paid': isPaid,
      'payment_method': paymentMethod,
    });
  }

  // Annuler une réservation (client - seulement si pending)
  Future<void> cancelBooking(int bookingId) async {
    try {
      await _apiService.delete('/bookings/$bookingId');
    } catch (e) {
      rethrow;
    }
  }
}
