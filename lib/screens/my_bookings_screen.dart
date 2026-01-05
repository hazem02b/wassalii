import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/booking_service.dart';
import 'booking_details_screen.dart';
import 'leave_review_screen.dart';
import '../utils/theme_extension.dart';
import '../utils/app_localizations.dart';

/// Page Mes Réservations - Design moderne identique à la version web
class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  final BookingService _bookingService = BookingService();
  
  String _activeTab = 'active';
  List<dynamic> _bookings = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _bookingService.getMyBookings();
      
      setState(() {
        _bookings = data;
      });
    } catch (e) {
      final errorMsg = e.toString();
      
      if (errorMsg.contains('Could not validate credentials') || errorMsg.contains('401')) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Session expirée. Veuillez vous reconnecter.'),
              backgroundColor: Color(0xFFDC2626),
              duration: Duration(seconds: 3),
            ),
          );
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            }
          });
        }
      }
      
      setState(() {
        _errorMessage = errorMsg;
        _bookings = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<dynamic> get _filteredBookings {
    return _bookings.where((booking) {
      if (booking == null || booking['status'] == null) return false;
      
      final status = booking['status'].toString().toLowerCase();
      if (_activeTab == 'active') {
        return ['pending', 'confirmed', 'in_transit'].contains(status);
      } else {
        return ['delivered', 'cancelled'].contains(status);
      }
    }).toList();
  }

  Color _getStatusColor(String status) {
    final statusLower = status.toLowerCase();
    switch (statusLower) {
      case 'confirmed':
        return const Color(0xFFDEEBFF);
      case 'pending':
        return const Color(0xFFFEF3C7);
      case 'delivered':
        return const Color(0xFFDCFCE7);
      case 'in_transit':
        return const Color(0xFFF3E8FF);
      case 'cancelled':
        return const Color(0xFFFEE2E2);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  Color _getStatusTextColor(String status) {
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
        return const Color(0xFF374151);
    }
  }

  String _getStatusText(String status) {
    final statusLower = status.toLowerCase();
    switch (statusLower) {
      case 'confirmed':
        return AppLocalizations.of(context).statusConfirmed;
      case 'pending':
        return AppLocalizations.of(context).statusPending;
      case 'delivered':
        return AppLocalizations.of(context).statusDelivered;
      case 'in_transit':
        return AppLocalizations.of(context).statusInTransit;
      case 'cancelled':
        return AppLocalizations.of(context).statusCancelled;
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              gradient: Theme.of(context).brightness == Brightness.dark
                  ? const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFF1E1E1E), Color(0xFF2D2D2D)],
                    )
                  : const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFF0066FF), Color(0xFF0052CC)],
                    ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          AppLocalizations.of(context).myBookingsTitle,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          onPressed: _fetchBookings,
                        ),
                      ],
                    ),
                  ),

                  // Tabs
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _activeTab = 'active'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _activeTab == 'active'
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                AppLocalizations.of(context).activeTab,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: _activeTab == 'active'
                                      ? const Color(0xFF0066FF)
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _activeTab = 'history'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _activeTab == 'history'
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                AppLocalizations.of(context).historyTab,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: _activeTab == 'history'
                                      ? const Color(0xFF0066FF)
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF0066FF),
                    ),
                  )
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
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: _fetchBookings,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0066FF),
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Réessayer'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : _filteredBookings.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.inbox_outlined,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _activeTab == 'active'
                                        ? AppLocalizations.of(context).noBookings
                                        : AppLocalizations.of(context).noHistory,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _activeTab == 'active'
                                        ? AppLocalizations.of(context).activeBookingsAppearHere
                                        : AppLocalizations.of(context).historyAppearHere,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filteredBookings.length,
                            itemBuilder: (context, index) {
                              final booking = _filteredBookings[index];
                              return _buildBookingCard(booking);
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final status = booking['status']?.toString() ?? 'pending';
    final tripDate = booking['trip_date'] != null
        ? DateFormat('dd MMM yyyy').format(DateTime.parse(booking['trip_date']))
        : 'Date inconnue';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: context.surfaceColor,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getStatusColor(status),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.confirmation_number_outlined,
                      color: _getStatusTextColor(status),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Réservation #${booking['id']}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _getStatusTextColor(status),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusTextColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(status),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getStatusTextColor(status),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Route
                Row(
                  children: [
                    const Icon(Icons.trip_origin, color: Color(0xFF0066FF), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        booking['from_location'] ?? 'Départ',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 9),
                  child: Container(
                    width: 2,
                    height: 20,
                    color: const Color(0xFFE5E7EB),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Color(0xFFDC2626), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        booking['to_location'] ?? 'Arrivée',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),

                // Details
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        icon: Icons.calendar_today,
                        label: 'Date',
                        value: tripDate,
                      ),
                    ),
                    Expanded(
                      child: _buildDetailItem(
                        icon: Icons.scale,
                        label: 'Poids',
                        value: '${booking['weight'] ?? '0'} kg',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        icon: Icons.attach_money,
                        label: 'Prix',
                        value: '${booking['total_price'] ?? '0'} €',
                      ),
                    ),
                    Expanded(
                      child: _buildDetailItem(
                        icon: booking['is_paid'] == true ? Icons.check_circle : Icons.pending,
                        label: 'Paiement',
                        value: booking['is_paid'] == true ? AppLocalizations.of(context).paid : AppLocalizations.of(context).awaitingPayment,
                        valueColor: booking['is_paid'] == true 
                            ? const Color(0xFF15803D)
                            : const Color(0xFFA16207),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Message selon le statut de la réservation
                if (status == 'pending') ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFF59E0B)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.hourglass_empty, color: Color(0xFFA16207), size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '⏳ En attente d\'approbation',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFA16207)),
                              ),
                              SizedBox(height: 2),
                              Text(
                                '💡 Vous ne paierez qu\'après acceptation du transporteur',
                                style: TextStyle(fontSize: 10, color: Color(0xFF92400E)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                
                if (status == 'confirmed' && booking['is_paid'] != true) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF10B981)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '✅ Acceptée par le transporteur',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF047857)),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '💳 Vous pouvez maintenant procéder au paiement',
                          style: TextStyle(fontSize: 10, color: Color(0xFF059669)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showPaymentDialog(booking),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.payment, size: 18),
                      label: const Text('Payer maintenant', style: TextStyle(fontSize: 13)),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                
                if (status == 'in_transit') ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E8FF),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF7C3AED)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.local_shipping, color: Color(0xFF7C3AED), size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '🚚 Colis en cours de livraison',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF7C3AED)),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Votre colis est en route vers sa destination',
                                style: TextStyle(fontSize: 10, color: Color(0xFF6D28D9)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                
                if (status == 'cancelled') ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFDC2626)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '❌ Réservation refusée par le transporteur',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFDC2626)),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Aucun paiement n\'a été effectué - Cherchez un autre transporteur',
                          style: TextStyle(fontSize: 10, color: Color(0xFFB91C1C)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                
                if (status == 'delivered') ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF10B981)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Color(0xFF10B981), size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '✅ Livré avec succès',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF047857)),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Votre colis a été livré',
                                style: TextStyle(fontSize: 10, color: Color(0xFF059669)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingDetailsScreen(bookingId: booking['id']),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF0066FF)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Détails',
                          style: TextStyle(
                            color: Color(0xFF0066FF),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (status.toLowerCase() == 'pending')
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Implement cancel booking
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDC2626),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Annuler',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    else if (status.toLowerCase() == 'delivered')
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LeaveReviewScreen(
                                  bookingId: booking['id'].toString(),
                                  recipientName: booking['trip']?['transporter']?['name'] ?? 'Transporteur',
                                  transporterId: booking['trip']?['transporter']?['id'] ?? 0,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0066FF),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Laisser un avis',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF6B7280)),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF9CA3AF),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: valueColor ?? const Color(0xFF111827),
              ),
            ),
          ],
        ),
      ],
    );
  }
  void _showPaymentDialog(Map<String, dynamic> booking) {
    String selectedPaymentMethod = 'card';
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text(
                '💳 Paiement',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Montant à payer: ${booking['total_price']?.toStringAsFixed(2) ?? '0.00'}€',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0066FF),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Méthode de paiement:',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    RadioListTile<String>(
                      title: const Text('💳 Carte bancaire'),
                      value: 'card',
                      groupValue: selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() => selectedPaymentMethod = value!);
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('📱 D17 (Mobile Money)'),
                      value: 'd17',
                      groupValue: selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() => selectedPaymentMethod = value!);
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('💵 Espèces au ramassage'),
                      value: 'cash',
                      groupValue: selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() => selectedPaymentMethod = value!);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _processPayment(booking['id'], selectedPaymentMethod);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Confirmer le paiement'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _processPayment(int bookingId, String paymentMethod) async {
    try {
      // Afficher un indicateur de chargement
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Simuler le processus de paiement (2 secondes)
      await Future.delayed(const Duration(seconds: 2));

      // Mettre à jour le paiement dans la base de données
      await _bookingService.updatePayment(bookingId, true, paymentMethod);

      // Fermer l'indicateur de chargement
      if (mounted) Navigator.pop(context);

      // Afficher un message de succès
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Paiement effectué avec succès!'),
            backgroundColor: Color(0xFF10B981),
            duration: Duration(seconds: 3),
          ),
        );
      }

      // Recharger les réservations
      _fetchBookings();
    } catch (e) {
      // Fermer l'indicateur de chargement
      if (mounted) Navigator.pop(context);

      // Afficher une erreur
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erreur de paiement: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }}
