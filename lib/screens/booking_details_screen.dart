import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/booking_service.dart';
import 'chat_screen.dart';

class BookingDetailsScreen extends StatefulWidget {
  final int bookingId;

  const BookingDetailsScreen({
    super.key,
    required this.bookingId,
  });

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  final BookingService _bookingService = BookingService();
  
  Map<String, dynamic>? _booking;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBookingDetails();
  }

  Future<void> _loadBookingDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final bookings = await _bookingService.getMyBookings();
      final booking = bookings.firstWhere(
        (b) => b['id'] == widget.bookingId,
        orElse: () => throw Exception('Réservation non trouvée'),
      );
      
      setState(() {
        _booking = booking;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Color _getStatusColor(String status) {
    final statusLower = status.toLowerCase();
    switch (statusLower) {
      case 'confirmed':
        return const Color(0xFF1D4ED8);
      case 'pending':
        return const Color(0xFFA16207);
      case 'delivered':
        return const Color(0xFF15803D);
      case 'in_transit':
        return const Color(0xFF7C3AED);
      case 'cancelled':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _getStatusText(String status) {
    final statusLower = status.toLowerCase();
    switch (statusLower) {
      case 'confirmed':
        return 'Confirmée';
      case 'pending':
        return 'En attente';
      case 'delivered':
        return 'Livrée';
      case 'in_transit':
        return 'En transit';
      case 'cancelled':
        return 'Annulée';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0066FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Détails de la réservation'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Color(0xFFDC2626),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Color(0xFF6B7280)),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _loadBookingDetails,
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Icon(
                              _booking!['status'] == 'delivered'
                                  ? Icons.check_circle
                                  : _booking!['status'] == 'cancelled'
                                      ? Icons.cancel
                                      : _booking!['status'] == 'in_transit'
                                          ? Icons.local_shipping
                                          : Icons.hourglass_empty,
                              size: 64,
                              color: _getStatusColor(_booking!['status']),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _getStatusText(_booking!['status']),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: _getStatusColor(_booking!['status']),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Réservation #${_booking!['id']}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Trip details
                      _buildSectionTitle('Trajet'),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            _buildDetailRow(
                              Icons.trip_origin,
                              'Départ',
                              _booking!['trip']?['origin_city'] ?? 'N/A',
                              const Color(0xFF0066FF),
                            ),
                            const SizedBox(height: 16),
                            _buildDetailRow(
                              Icons.location_on,
                              'Arrivée',
                              _booking!['trip']?['destination_city'] ?? 'N/A',
                              const Color(0xFFDC2626),
                            ),
                            if (_booking!['trip']?['departure_date'] != null) ...[
                              const SizedBox(height: 16),
                              _buildDetailRow(
                                Icons.calendar_today,
                                'Date de départ',
                                DateFormat('dd MMMM yyyy').format(
                                  DateTime.parse(_booking!['trip']['departure_date']),
                                ),
                                const Color(0xFF6B7280),
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Package details
                      _buildSectionTitle('Détails du colis'),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow(
                              Icons.inventory_2,
                              'Type',
                              _booking!['item_type'] ?? 'N/A',
                              const Color(0xFF6B7280),
                            ),
                            const SizedBox(height: 16),
                            _buildDetailRow(
                              Icons.scale,
                              'Poids',
                              '${_booking!['weight']} kg',
                              const Color(0xFF6B7280),
                            ),
                            if (_booking!['description'] != null &&
                                _booking!['description'].toString().isNotEmpty) ...[
                              const SizedBox(height: 16),
                              const Text(
                                'Description',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6B7280),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _booking!['description'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF111827),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Pickup and delivery addresses
                      _buildSectionTitle('Adresses'),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Adresse de ramassage',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _booking!['pickup_address'] ?? 'N/A',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Adresse de livraison',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _booking!['delivery_address'] ?? 'N/A',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Recipient details
                      _buildSectionTitle('Destinataire'),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            _buildDetailRow(
                              Icons.person,
                              'Nom',
                              _booking!['recipient_name'] ?? 'N/A',
                              const Color(0xFF6B7280),
                            ),
                            const SizedBox(height: 16),
                            _buildDetailRow(
                              Icons.phone,
                              'Téléphone',
                              _booking!['recipient_phone'] ?? 'N/A',
                              const Color(0xFF6B7280),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Payment info
                      _buildSectionTitle('Paiement'),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            _buildDetailRow(
                              Icons.attach_money,
                              'Montant total',
                              '${_booking!['total_price']?.toStringAsFixed(2) ?? '0.00'}€',
                              const Color(0xFF0066FF),
                            ),
                            const SizedBox(height: 16),
                            _buildDetailRow(
                              _booking!['is_paid'] == true
                                  ? Icons.check_circle
                                  : Icons.pending,
                              'Statut du paiement',
                              _booking!['is_paid'] == true ? 'Payé' : 'En attente',
                              _booking!['is_paid'] == true
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFA16207),
                            ),
                            if (_booking!['payment_method'] != null) ...[
                              const SizedBox(height: 16),
                              _buildDetailRow(
                                Icons.payment,
                                'Méthode de paiement',
                                _booking!['payment_method'],
                                const Color(0xFF6B7280),
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Tracking number
                      if (_booking!['tracking_number'] != null) ...[
                        _buildSectionTitle('Suivi'),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0066FF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF0066FF)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.qr_code,
                                color: Color(0xFF0066FF),
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Numéro de suivi',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF0066FF),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _booking!['tracking_number'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0066FF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Transporter info
                      if (_booking!['trip']?['transporter'] != null) ...[
                        _buildSectionTitle('Transporteur'),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0066FF).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      color: Color(0xFF0066FF),
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _booking!['trip']['transporter']['name'] ?? 'N/A',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF111827),
                                          ),
                                        ),
                                        if (_booking!['trip']['transporter']['phone'] != null) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            _booking!['trip']['transporter']['phone'],
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF6B7280),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    final transporterId = _booking!['trip']['transporter']['id'];
                                    final transporterName = _booking!['trip']['transporter']['name'] ?? 'Transporteur';
                                    
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                          otherUserId: transporterId,
                                          otherUserName: transporterName,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.message),
                                  label: const Text('Contacter le transporteur'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0066FF),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF111827),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, Color iconColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF111827),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
