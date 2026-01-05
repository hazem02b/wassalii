import 'api_service.dart';

class TripService {
  final ApiService _apiService = ApiService();

  // Créer un nouveau trajet
  Future<Map<String, dynamic>> createTrip(Map<String, dynamic> tripData) async {
    try {
      final response = await _apiService.post('/trips/', data: tripData);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer les trajets du transporteur
  Future<List<dynamic>> getMyTrips() async {
    try {
      final response = await _apiService.get('/trips/my');
      return response.data as List<dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  // Rechercher des trajets
  Future<List<dynamic>> searchTrips({
    String? originCity,
    String? destinationCity,
    String? minDepartureDate,
    String? maxDepartureDate,
    double? minWeight,
    double? maxPricePerKg,
  }) async {
    try {
      Map<String, dynamic> queryParams = {};
      if (originCity != null) queryParams['origin_city'] = originCity;
      if (destinationCity != null) queryParams['destination_city'] = destinationCity;
      if (minDepartureDate != null) queryParams['min_departure_date'] = minDepartureDate;
      if (maxDepartureDate != null) queryParams['max_departure_date'] = maxDepartureDate;
      if (minWeight != null) queryParams['min_weight'] = minWeight;
      if (maxPricePerKg != null) queryParams['max_price_per_kg'] = maxPricePerKg;

      final response = await _apiService.get('/trips/', queryParameters: queryParams);
      return response.data as List<dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer un trajet par ID
  Future<Map<String, dynamic>> getTripById(int tripId) async {
    try {
      final response = await _apiService.get('/trips/$tripId');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour un trajet
  Future<Map<String, dynamic>> updateTrip(int tripId, Map<String, dynamic> tripData) async {
    try {
      final response = await _apiService.put('/trips/$tripId', data: tripData);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Supprimer un trajet
  Future<void> deleteTrip(int tripId) async {
    try {
      await _apiService.delete('/trips/$tripId');
    } catch (e) {
      rethrow;
    }
  }

  // Publier/Dépublier un trajet
  Future<Map<String, dynamic>> toggleTripStatus(int tripId, bool isActive) async {
    try {
      final response = await _apiService.put(
        '/trips/$tripId',
        data: {'is_active': isActive},
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
