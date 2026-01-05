import 'api_service.dart';

class ReviewService {
  final ApiService _apiService = ApiService();

  /// Get all reviews for a specific transporter
  Future<List<dynamic>> getTransporterReviews(int transporterId) async {
    try {
      final response = await _apiService.get('/reviews/transporter/$transporterId');
      return response.data as List<dynamic>;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des avis: $e');
    }
  }

  /// Get reviews for current user (transporter: received, client: given)
  Future<List<dynamic>> getMyReviews() async {
    try {
      final response = await _apiService.get('/reviews/my-reviews');
      return response.data as List<dynamic>;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des avis: $e');
    }
  }

  /// Get review for a specific booking
  Future<dynamic> getBookingReview(int bookingId) async {
    try {
      final response = await _apiService.get('/reviews/booking/$bookingId');
      return response.data;
    } catch (e) {
      // Return null if no review found (404)
      if (e.toString().contains('404')) {
        return null;
      }
      throw Exception('Erreur lors de la récupération de l\'avis: $e');
    }
  }
}
