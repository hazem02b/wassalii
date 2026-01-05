import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/api_service.dart';
import '../utils/theme_extension.dart';

class TransporterReviewsScreen extends StatefulWidget {
  final String transporterId;
  
  const TransporterReviewsScreen({super.key, required this.transporterId});

  @override
  State<TransporterReviewsScreen> createState() => _TransporterReviewsScreenState();
}

class _TransporterReviewsScreenState extends State<TransporterReviewsScreen> {
  List<dynamic> _reviews = [];
  bool _isLoading = true;
  double _averageRating = 0.0;
  int _totalReviews = 0;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiService().get('/reviews/transporter/${widget.transporterId}');
      setState(() {
        _reviews = response.data['reviews'] ?? [];
        _averageRating = (response.data['average_rating'] ?? 0.0).toDouble();
        _totalReviews = response.data['total_reviews'] ?? 0;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 16,
                    left: 20,
                    right: 20,
                    bottom: 24,
                  ),
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Expanded(
                            child: Text(
                              'Avis',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 40),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _averageRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return Icon(
                            index < _averageRating.floor() ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 28,
                          );
                        }),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Basé sur $_totalReviews avis',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: _reviews.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: context.surfaceColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.rate_review_outlined, size: 64, color: context.textTertiary),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Aucun avis',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Les avis apparaîtront ici',
                                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadReviews,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(20),
                            itemCount: _reviews.length,
                            itemBuilder: (context, index) {
                              final review = _reviews[index];
                              return _ReviewCard(review: review);
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;
  
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.04 * 255).round()),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white,
                  child: Text(
                    (review['reviewer_name'] ?? 'U')[0].toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['reviewer_name'] ?? 'Utilisateur',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < (review['rating'] ?? 0) ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          if (review['comment'] != null && review['comment'].toString().isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              review['comment'],
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
