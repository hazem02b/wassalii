import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/booking_service.dart';
import '../services/review_service.dart';
import '../utils/theme_extension.dart';

class TripDetailsScreen extends StatefulWidget {
  final dynamic trip;

  const TripDetailsScreen({super.key, required this.trip});

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  final BookingService _bookingService = BookingService();
  final ReviewService _reviewService = ReviewService();
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _itemDescriptionController = TextEditingController();
  final _pickupAddressController = TextEditingController();
  final _deliveryAddressController = TextEditingController();
  final _recipientNameController = TextEditingController();
  final _recipientPhoneController = TextEditingController();
  
  bool _isSubmitting = false;
  List<dynamic> _reviews = [];
  bool _isLoadingReviews = true;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    if (widget.trip['transporter']?['id'] == null) {
      setState(() => _isLoadingReviews = false);
      return;
    }

    try {
      final reviews = await _reviewService.getTransporterReviews(widget.trip['transporter']['id']);
      setState(() {
        _reviews = reviews;
        _isLoadingReviews = false;
      });
    } catch (e) {
      setState(() => _isLoadingReviews = false);
    }
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return 'Date inconnue';
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('EEEE dd MMMM yyyy à HH:mm', 'fr_FR').format(date);
    } catch (e) {
      return 'Date inconnue';
    }
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      await _bookingService.createBooking(
        tripId: widget.trip['id'],
        weight: double.parse(_weightController.text),
        itemType: 'Colis', // Valeur par défaut
        description: _itemDescriptionController.text,
        pickupAddress: _pickupAddressController.text,
        pickupCity: 'Ville', // Valeur par défaut - à améliorer avec un champ
        deliveryAddress: _deliveryAddressController.text,
        deliveryCity: 'Ville', // Valeur par défaut - à améliorer avec un champ
        recipientName: _recipientNameController.text,
        recipientPhone: _recipientPhoneController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Réservation créée avec succès !'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _itemDescriptionController.dispose();
    _pickupAddressController.dispose();
    _deliveryAddressController.dispose();
    _recipientNameController.dispose();
    _recipientPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.surfaceColor,
        iconTheme: IconThemeData(color: context.textPrimary),
        title: Text(
          'Détails du trajet',
          style: TextStyle(
            color: context.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip info card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: context.surfaceColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Route
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFF2196F3),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Départ',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              widget.trip['origin_city'] ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(
                        Icons.flag,
                        color: Color(0xFFFF9800),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Destination',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              widget.trip['destination_city'] ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),

                  // Details
                  _buildInfoRow(
                    Icons.calendar_today,
                    'Date de départ',
                    _formatDate(widget.trip['departure_date']),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.scale,
                    'Poids disponible',
                    '${widget.trip['available_weight'] ?? 0} kg',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.attach_money,
                    'Prix',
                    '${widget.trip['price_per_kg'] ?? 0} DT/kg',
                    valueColor: const Color(0xFF2196F3),
                    valueBold: true,
                  ),
                  if (widget.trip['transporter_name'] != null) ...[
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      Icons.person,
                      'Transporteur',
                      widget.trip['transporter_name'],
                    ),
                  ],
                  if (widget.trip['description'] != null &&
                      widget.trip['description'].toString().isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.trip['description'],
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ],
              ),
            ),

            // Reviews Section
            if (_reviews.isNotEmpty)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'Avis (${_reviews.length})',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ..._reviews.take(3).map((review) => _buildReviewItem(review)),
                    if (_reviews.length > 3)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          'Et ${_reviews.length - 3} autres avis...',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

            // Booking form
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informations de réservation',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Weight
                    TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Poids (kg) *',
                        prefixIcon: const Icon(Icons.scale),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: context.surfaceColor,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer le poids';
                        }
                        final weight = double.tryParse(value);
                        if (weight == null || weight <= 0) {
                          return 'Poids invalide';
                        }
                        final available =
                            widget.trip['available_weight'] ?? 0;
                        if (weight > available) {
                          return 'Poids supérieur au disponible ($available kg)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Item description
                    TextFormField(
                      controller: _itemDescriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Description des articles *',
                        prefixIcon: const Icon(Icons.inventory_2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: context.surfaceColor,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez décrire les articles';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Pickup address
                    TextFormField(
                      controller: _pickupAddressController,
                      decoration: InputDecoration(
                        labelText: 'Adresse de collecte *',
                        prefixIcon: const Icon(Icons.location_on),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: context.surfaceColor,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer l\'adresse de collecte';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Delivery address
                    TextFormField(
                      controller: _deliveryAddressController,
                      decoration: InputDecoration(
                        labelText: 'Adresse de livraison *',
                        prefixIcon: const Icon(Icons.place),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: context.surfaceColor,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer l\'adresse de livraison';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Recipient name
                    TextFormField(
                      controller: _recipientNameController,
                      decoration: InputDecoration(
                        labelText: 'Nom du destinataire *',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: context.surfaceColor,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer le nom du destinataire';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Recipient phone
                    TextFormField(
                      controller: _recipientPhoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Téléphone du destinataire *',
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: context.surfaceColor,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer le téléphone';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Calculate price
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2196F3).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Prix estimé:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            _weightController.text.isNotEmpty &&
                                    double.tryParse(_weightController.text) !=
                                        null
                                ? '${(double.parse(_weightController.text) * (widget.trip['price_per_kg'] ?? 0)).toStringAsFixed(2)} DT'
                                : '0.00 DT',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2196F3),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitBooking,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2196F3),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Confirmer la réservation',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
    bool valueBold = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: context.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: valueBold ? FontWeight.bold : FontWeight.normal,
                  color: valueColor ?? context.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewItem(dynamic review) {
    final rating = review['rating'] ?? 0;
    final comment = review['comment'] ?? '';
    final clientName = review['client']?['name'] ?? 'Client';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.inputBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFF2196F3).withOpacity(0.2),
                child: Text(
                  clientName[0].toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFF2196F3),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  clientName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  );
                }),
              ),
            ],
          ),
          if (comment.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              comment,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
