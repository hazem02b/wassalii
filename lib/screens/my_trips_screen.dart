import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/trip_service.dart';
import 'edit_trip_screen.dart';
import '../utils/theme_extension.dart';
import '../utils/app_localizations.dart';

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> with SingleTickerProviderStateMixin {
  List<dynamic> _trips = [];
  bool _isLoading = true;
  late TabController _tabController;
  final TripService _tripService = TripService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    _loadTrips();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTrips() async {
    setState(() => _isLoading = true);
    try {
      final trips = await _tripService.getMyTrips();
      setState(() {
        _trips = trips;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _trips = [];
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de chargement: ${e.toString()}'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  List<dynamic> get _activeTrips {
    return _trips.where((trip) => trip['is_active'] == true).toList();
  }

  List<dynamic> get _pastTrips {
    return _trips.where((trip) => trip['is_active'] == false).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.surfaceColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context).myTrips,
          style: TextStyle(color: context.textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: context.textPrimary,
          unselectedLabelColor: context.textSecondary,
          indicatorColor: const Color(0xFFFF9800),
          indicatorWeight: 3,
          tabs: [
            Tab(text: '${AppLocalizations.of(context).past} (${_pastTrips.length})'),
            Tab(text: '${AppLocalizations.of(context).active} (${_activeTrips.length})'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF9800)))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildTripsList(_pastTrips),
                _buildTripsList(_activeTrips),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFF9800),
        unselectedItemColor: context.textSecondary,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: AppLocalizations.of(context).dashboard),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: AppLocalizations.of(context).trips),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: AppLocalizations.of(context).create),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: AppLocalizations.of(context).messages),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: AppLocalizations.of(context).profile),
        ],
        onTap: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/transporter-dashboard');
          if (index == 2) Navigator.pushNamed(context, '/create-trip');
          if (index == 3) Navigator.pushNamed(context, '/messages');
          if (index == 4) Navigator.pushNamed(context, '/transporter-profile');
        },
      ),
    );
  }

  Widget _buildTripsList(List<dynamic> trips) {
    if (trips.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.route_outlined, size: 64, color: context.textTertiary),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context).noTrips,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: context.textSecondary),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFFFF9800),
      onRefresh: _loadTrips,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: trips.length,
        itemBuilder: (context, index) {
          final trip = trips[index];
          return _TripCard(trip: trip, onDelete: _loadTrips, onEdit: _loadTrips);
        },
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final Map<String, dynamic> trip;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  
  const _TripCard({required this.trip, this.onDelete, this.onEdit});
  
  static final TripService _tripService = TripService();

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year} à ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.surfaceColor,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => _deleteTrip(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => _editTrip(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${trip['origin_city'] ?? 'N/A'} → ${trip['destination_city'] ?? 'N/A'}',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.check_circle, color: Colors.blue, size: 16),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: context.textSecondary),
                const SizedBox(width: 4),
                Text(_formatDate(trip['departure_date']), style: TextStyle(color: context.textSecondary, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('${trip['price_per_kg']?.toString() ?? '0'} DT/kg', style: TextStyle(fontSize: 13, color: context.textSecondary)),
                const SizedBox(width: 16),
                Text('${trip['available_weight']?.toString() ?? '0'}/${trip['max_weight']?.toString() ?? '0'}kg', style: TextStyle(fontSize: 13, color: context.textSecondary)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('payée(s): ${trip['paid_bookings']?.toString() ?? '0'}', style: const TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 4),
                      const Icon(Icons.check_circle, color: Colors.green, size: 12),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('réservation(s): ${trip['bookings_count']?.toString() ?? '0'}', style: const TextStyle(color: Colors.orange, fontSize: 11, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 4),
                      const Icon(Icons.access_time, color: Colors.orange, size: 12),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _deleteTrip(BuildContext context) {
    // Vérifier s'il y a des réservations payées
    final paidBookings = trip['paid_bookings'] ?? 0;
    
    if (paidBookings > 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Impossible de supprimer'),
          content: Text('Ce trajet a $paidBookings réservation(s) payée(s). Vous ne pouvez pas le supprimer.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le trajet'),
        content: const Text('Êtes-vous sûr de vouloir supprimer ce trajet ? Les réservations non payées seront annulées.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _tripService.deleteTrip(trip['id']);
                onDelete?.call();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Trajet supprimé avec succès'), backgroundColor: Colors.green),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  // Extraire le message d'erreur du backend
                  String errorMessage = 'Erreur lors de la suppression';
                  
                  final errorStr = e.toString();
                  if (errorStr.contains('Cannot delete trip with')) {
                    // Extraire le message spécifique du backend
                    final match = RegExp(r'Cannot delete trip with (\d+) paid booking').firstMatch(errorStr);
                    if (match != null) {
                      final count = match.group(1);
                      errorMessage = 'Impossible de supprimer ce trajet car il a $count réservation(s) payée(s)';
                    } else {
                      errorMessage = 'Impossible de supprimer ce trajet car il contient des réservations payées';
                    }
                  } else if (errorStr.contains('400')) {
                    errorMessage = 'Impossible de supprimer ce trajet. Il contient peut-être des réservations payées.';
                  } else {
                    errorMessage = 'Erreur: ${errorStr.split(':').last.trim()}';
                  }
                  
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Erreur'),
                      content: Text(errorMessage),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _editTrip(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTripScreen(trip: trip),
      ),
    );
    
    if (result == true) {
      onEdit?.call();
    }
  }
}
