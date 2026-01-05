import 'package:flutter/material.dart';
import '../services/booking_service.dart';
import '../services/trip_service.dart';
import '../services/user_service.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'my_reviews_screen.dart';
import '../utils/theme_extension.dart';
import '../utils/app_localizations.dart';
import 'dart:convert';
import 'dart:typed_data';

class TransporterDashboardScreen extends StatefulWidget {
  const TransporterDashboardScreen({super.key});

  @override
  State<TransporterDashboardScreen> createState() => _TransporterDashboardScreenState();
}

class _TransporterDashboardScreenState extends State<TransporterDashboardScreen> {
  int _selectedIndex = 0;
  final BookingService _bookingService = BookingService();
  final TripService _tripService = TripService();
  final UserService _userService = UserService();
  
  // Données dynamiques
  List<dynamic> _allBookings = [];
  List<dynamic> _trips = [];
  bool _isLoading = true;
  String? _errorMessage;
  Uint8List? _profileImageBytes;
  Map<String, dynamic>? _userData;
  String _imageKey = DateTime.now().millisecondsSinceEpoch.toString();
  
  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final bookings = await _bookingService.getAllBookings();
      final trips = await _tripService.getMyTrips();
      final userData = await _userService.getCurrentUser();
      
      setState(() {
        _allBookings = bookings;
        _trips = trips;
        _userData = userData;
        if (userData['profile_picture'] != null) {
          _profileImageBytes = base64Decode(userData['profile_picture']);
        }
        _imageKey = DateTime.now().millisecondsSinceEpoch.toString();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  List<dynamic> get _pendingBookings {
    return _allBookings.where((b) => b['status'] == 'pending').toList();
  }

  List<dynamic> get _confirmedPaidBookings {
    return _allBookings.where((b) => 
      b['status'] == 'confirmed' && b['is_paid'] == true
    ).toList();
  }

  List<dynamic> get _inTransitBookings {
    return _allBookings.where((b) => b['status'] == 'in_transit').toList();
  }

  int get _activeTripsCount {
    return _trips.where((t) => t['is_active'] == true && t['is_completed'] == false).length;
  }

  double get _monthlyRevenue {
    final now = DateTime.now();
    final thisMonth = _allBookings.where((b) {
      if (b['created_at'] == null) return false;
      final bookingDate = DateTime.parse(b['created_at']);
      return bookingDate.year == now.year && 
             bookingDate.month == now.month &&
             b['is_paid'] == true;
    });
    
    return thisMonth.fold(0.0, (sum, b) => sum + (b['total_price'] ?? 0.0));
  }

  Future<void> _acceptBooking(int bookingId) async {
    try {
      await _bookingService.acceptBooking(bookingId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).reservationAccepted),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
      _loadDashboardData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _rejectBooking(int bookingId) async {
    try {
      await _bookingService.rejectBooking(bookingId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).reservationRefused),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
      _loadDashboardData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _startDelivery(int bookingId) async {
    try {
      await _bookingService.startDelivery(bookingId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).deliveryStarted),
          backgroundColor: const Color(0xFF0EA5E9),
        ),
      );
      _loadDashboardData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _markAsDelivered(int bookingId) async {
    try {
      await _bookingService.markAsDelivered(bookingId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).deliveryCompleted),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
      _loadDashboardData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userName = authProvider.currentUser?.fullName ?? 'Transporteur';
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header orange avec stats
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFFFF9800),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context).welcome,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              userName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.language, color: Colors.white),
                              onPressed: () {},
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () async {
                                final result = await Navigator.pushNamed(context, '/transporter-profile');
                                // Recharger les données après le retour de la page de profil
                                if (mounted) {
                                  await _loadDashboardData();
                                }
                              },
                              child: CircleAvatar(
                                key: ValueKey(_imageKey),
                                backgroundColor: Colors.white,
                                backgroundImage: _profileImageBytes != null
                                    ? MemoryImage(_profileImageBytes!)
                                    : null,
                                child: _profileImageBytes == null
                                    ? const Icon(Icons.person, color: Color(0xFFFF9800))
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      AppLocalizations.of(context).readyToTransport,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _StatCard(
                          icon: Icons.directions_car,
                          label: AppLocalizations.of(context).active,
                          value: _isLoading ? '...' : _activeTripsCount.toString(),
                        ),
                        _StatCard(
                          icon: Icons.hourglass_empty,
                          label: AppLocalizations.of(context).pendingReservations,
                          value: _isLoading ? '...' : _pendingBookings.length.toString(),
                        ),
                        _StatCard(
                          icon: Icons.attach_money,
                          label: AppLocalizations.of(context).monthlyRevenue,
                          value: _isLoading ? '...' : '${_monthlyRevenue.toStringAsFixed(0)}€',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Section: Réservations en attente
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🕒 ${AppLocalizations.of(context).pendingReservations}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _pendingBookings.isEmpty
                        ? Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: context.surfaceColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context).noPendingReservations,
                                style: TextStyle(color: context.textSecondary),
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _pendingBookings.length,
                            itemBuilder: (context, index) {
                              final booking = _pendingBookings[index];
                              return _BookingCard(
                                booking: booking,
                                onAccept: () => _acceptBooking(booking['id']),
                                onReject: () => _rejectBooking(booking['id']),
                                showAcceptReject: true,
                              );
                            },
                          ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Section: Réservations confirmées et payées
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '✅ ${AppLocalizations.of(context).confirmedPaid}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _confirmedPaidBookings.isEmpty
                        ? Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: context.surfaceColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context).noConfirmedPaid,
                                style: TextStyle(color: context.textSecondary),
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _confirmedPaidBookings.length,
                            itemBuilder: (context, index) {
                              final booking = _confirmedPaidBookings[index];
                              return _BookingCard(
                                booking: booking,
                                onStartDelivery: () => _startDelivery(booking['id']),
                                showStartDelivery: true,
                              );
                            },
                          ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Section: Livraisons en cours
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🚚 ${AppLocalizations.of(context).inDelivery}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _inTransitBookings.isEmpty
                        ? Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: context.surfaceColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context).noInDelivery,
                                style: TextStyle(color: context.textSecondary),
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _inTransitBookings.length,
                            itemBuilder: (context, index) {
                              final booking = _inTransitBookings[index];
                              return _BookingCard(
                                booking: booking,
                                onMarkDelivered: () => _markAsDelivered(booking['id']),
                                showMarkDelivered: true,
                              );
                            },
                          ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Boutons d'action
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF9800),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/create-trip');
                        },
                        icon: const Icon(Icons.add),
                        label: Text(AppLocalizations.of(context).publishNewTrip),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFFF9800),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Color(0xFFFF9800)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyReviewsScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.star_outline),
                        label: Text(AppLocalizations.of(context).myReviews),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          switch (index) {
            case 0:
              // Dashboard - déjà ici
              break;
            case 1:
              Navigator.pushNamed(context, '/my-trips');
              break;
            case 2:
              Navigator.pushNamed(context, '/create-trip');
              break;
            case 3:
              Navigator.pushNamed(context, '/transporter-messages');
              break;
            case 4:
              Navigator.pushNamed(context, '/transporter-profile');
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFF9800),
        unselectedItemColor: context.textSecondary,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard),
            label: AppLocalizations.of(context).dashboard,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            label: AppLocalizations.of(context).trips,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.add_circle),
            label: AppLocalizations.of(context).create,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.message),
            label: AppLocalizations.of(context).messages,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: AppLocalizations.of(context).profile,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFFFF9800), size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;
  final VoidCallback? onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (iconColor ?? Colors.grey).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? Colors.grey,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: context.textPrimary,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: context.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onStartDelivery;
  final VoidCallback? onMarkDelivered;
  final bool showAcceptReject;
  final bool showStartDelivery;
  final bool showMarkDelivered;

  const _BookingCard({
    required this.booking,
    this.onAccept,
    this.onReject,
    this.onStartDelivery,
    this.onMarkDelivered,
    this.showAcceptReject = false,
    this.showStartDelivery = false,
    this.showMarkDelivered = false,
  });

  @override
  Widget build(BuildContext context) {
    final client = booking['client'];
    final trip = booking['trip'];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFFFF9800),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      client?['name'] ?? 'Client',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: context.textPrimary,
                      ),
                    ),
                    Text(
                      '${trip?['origin_city'] ?? 'Origine'} → ${trip?['destination_city'] ?? 'Destination'}',
                      style: TextStyle(
                        color: context.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${booking['total_price']?.toStringAsFixed(2) ?? '0.00'}€',
                style: const TextStyle(
                  color: Color(0xFFFF9800),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.scale, size: 16, color: context.textSecondary),
              const SizedBox(width: 4),
              Text(
                '${booking['weight']?.toString() ?? '0'}kg',
                style: TextStyle(fontSize: 12, color: context.textSecondary),
              ),
              const SizedBox(width: 16),
              Icon(Icons.inventory_2, size: 16, color: context.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  booking['item_type'] ?? 'Colis',
                  style: TextStyle(fontSize: 12, color: context.textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (booking['tracking_number'] != null) ...[
            const SizedBox(height: 8),
            Text(
              'Tracking: ${booking['tracking_number']}',
              style: const TextStyle(fontSize: 11, color: Colors.blue),
            ),
          ],
          
          // Boutons d'action
          if (showAcceptReject) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onAccept,
                    icon: const Icon(Icons.check, size: 18),
                    label: Text(AppLocalizations.of(context).accept),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onReject,
                    icon: const Icon(Icons.close, size: 18),
                    label: Text(AppLocalizations.of(context).refuse),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ],
          
          if (showStartDelivery) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onStartDelivery,
                icon: const Icon(Icons.local_shipping, size: 18),
                label: Text(AppLocalizations.of(context).startDelivery),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
          
          if (showMarkDelivered) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onMarkDelivered,
                icon: const Icon(Icons.check_circle, size: 18),
                label: Text(AppLocalizations.of(context).markDelivered),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}