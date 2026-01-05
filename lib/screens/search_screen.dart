import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/trip_service.dart';
import 'trip_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TripService _tripService = TripService();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  
  List<dynamic> _trips = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  String? _errorMessage;
  DateTime? _selectedDate;
  double? _maxWeight;
  
  @override
  void initState() {
    super.initState();
    // Charger les résultats automatiquement après la construction du widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialSearch();
    });
  }
  
  void _loadInitialSearch() {
    // Récupérer les arguments passés depuis la page d'accueil
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    if (args != null) {
      if (args['from'] != null) {
        _fromController.text = args['from'];
      }
      if (args['to'] != null) {
        _toController.text = args['to'];
      }
      
      // Marquer comme ayant déjà recherché pour éviter d'afficher le message vide
      setState(() {
        _hasSearched = true;
        _isLoading = true;
      });
      
      // Lancer automatiquement la recherche
      if (_fromController.text.isNotEmpty || _toController.text.isNotEmpty) {
        _handleSearch();
      }
    }
  }
  
  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  Future<void> _handleSearch() async {
    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _errorMessage = null;
    });

    try {
      final results = await _tripService.searchTrips(
        originCity: _fromController.text.trim().isNotEmpty ? _fromController.text.trim() : null,
        destinationCity: _toController.text.trim().isNotEmpty ? _toController.text.trim() : null,
        minDepartureDate: _selectedDate?.toIso8601String(),
        minWeight: _maxWeight,
      );

      setState(() {
        _trips = results;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur de recherche: $e';
        _trips = [];
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('fr', 'FR'),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rechercher des trajets'),
      ),
      body: Column(
        children: [
          // Search Form
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                TextField(
                  controller: _fromController,
                  decoration: InputDecoration(
                    labelText: 'De',
                    prefixIcon: const Icon(Icons.location_on),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _toController,
                  decoration: InputDecoration(
                    labelText: 'À',
                    prefixIcon: const Icon(Icons.flag),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _selectDate,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Date',
                            prefixIcon: const Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                          ),
                          child: Text(
                            _selectedDate != null
                                ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                                : 'Toutes les dates',
                            style: TextStyle(
                              color: _selectedDate != null ? Colors.black : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Poids min (kg)',
                          prefixIcon: const Icon(Icons.scale),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _maxWeight = double.tryParse(value);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _handleSearch,
                    icon: const Icon(Icons.search),
                    label: const Text(
                      'Rechercher',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0066FF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Results
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                            const SizedBox(height: 16),
                            Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : !_hasSearched
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search, size: 80, color: Colors.grey[400]),
                                const SizedBox(height: 16),
                                Text(
                                  'Entrez votre départ et destination',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : _trips.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[400]),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Aucun trajet trouvé',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: _trips.length,
                                itemBuilder: (context, index) {
                                  final trip = _trips[index];
                                  return _buildTripCard(trip);
                                },
                              ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripCard(dynamic trip) {
    String formatDate(String? isoDate) {
      if (isoDate == null || isoDate.isEmpty) return 'Date inconnue';
      try {
        final date = DateTime.parse(isoDate);
        return DateFormat('dd/MM/yyyy à HH:mm', 'fr_FR').format(date);
      } catch (e) {
        return 'Date inconnue';
      }
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/trip-details',
            arguments: trip,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Route
              Row(
                children: [
                  const Icon(Icons.location_on, color: Color(0xFF0066FF), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      trip['origin_city'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.flag, color: Color(0xFFFF9500), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      trip['destination_city'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),

              // Date and Price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        formatDate(trip['departure_date']),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${trip['price_per_kg'] ?? 0} DT/kg',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0066FF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Available weight
              Row(
                children: [
                  const Icon(Icons.scale, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'Disponible: ${trip['available_weight'] ?? 0} kg',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),

              // Transporter info
              if (trip['transporter_name'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        trip['transporter_name'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

              // Book button
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/trip-details',
                      arguments: trip,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Voir détails et réserver'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
