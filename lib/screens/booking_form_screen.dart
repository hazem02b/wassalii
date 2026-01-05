import 'package:flutter/material.dart';
import '../services/booking_service.dart';
import '../services/trip_service.dart';
import '../constants/app_colors.dart';
import '../models/trip.dart';

class BookingFormScreen extends StatefulWidget {
  final String tripId;
  final Trip? trip;

  const BookingFormScreen({
    super.key, 
    required this.tripId, 
    this.trip
  });

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final BookingService _bookingService = BookingService();
  
  bool _loading = true;
  bool _submitting = false;
  Trip? _trip;
  String? _error;

  // Form Controllers
  final _weightCtrl = TextEditingController();
  final _itemTypeCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _pickupAddressCtrl = TextEditingController();
  final _pickupCityCtrl = TextEditingController();
  final _deliveryAddressCtrl = TextEditingController();
  final _deliveryCityCtrl = TextEditingController();
  final _recipientNameCtrl = TextEditingController();
  final _recipientPhoneCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.trip != null) {
      _trip = widget.trip;
      _loading = false;
    } else {
      _fetchTrip();
    }
  }

  @override
  void dispose() {
    _weightCtrl.dispose();
    _itemTypeCtrl.dispose();
    _descriptionCtrl.dispose();
    _pickupAddressCtrl.dispose();
    _pickupCityCtrl.dispose();
    _deliveryAddressCtrl.dispose();
    _deliveryCityCtrl.dispose();
    _recipientNameCtrl.dispose();
    _recipientPhoneCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchTrip() async {
    try {
      final tripData = await TripService().getTripById(int.parse(widget.tripId));
      if (mounted) {
        setState(() {
          _trip = Trip.fromJson(tripData);
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Erreur lors du chargement du trajet: $e';
          _loading = false;
        });
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _submitting = true);
    
    try {
      await _bookingService.createBooking(
        tripId: int.parse(widget.tripId),
        weight: double.parse(_weightCtrl.text),
        itemType: _itemTypeCtrl.text,
        description: _descriptionCtrl.text.isNotEmpty ? _descriptionCtrl.text : null,
        pickupAddress: _pickupAddressCtrl.text,
        pickupCity: _pickupCityCtrl.text,
        deliveryAddress: _deliveryAddressCtrl.text,
        deliveryCity: _deliveryCityCtrl.text,
        recipientName: _recipientNameCtrl.text,
        recipientPhone: _recipientPhoneCtrl.text,
        notes: _notesCtrl.text.isNotEmpty ? _notesCtrl.text : null,
      );
      
      if (!mounted) return;
      
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Réservation envoyée'),
          content: const Text(
            '✅ Réservation envoyée avec succès!\n\n'
            '💡 Important: Vous ne paierez QU\'APRÈS que le transporteur accepte votre demande.\n\n'
            '🔒 Votre argent est protégé - aucun paiement avant confirmation!'
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la réservation: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  double _calculateTotal() {
    if (_trip == null || _weightCtrl.text.isEmpty) return 0;
    final weight = double.tryParse(_weightCtrl.text) ?? 0;
    final transportFee = _trip!.pricePerKg * weight;
    final serviceFee = transportFee * 0.1;
    return transportFee + serviceFee;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _trip == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Erreur')),
        body: Center(child: Text(_error ?? 'Trajet introuvable')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Nouvelle réservation',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withAlpha((0.3 * 255).round())),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _trip!.departureLocation.city ?? 'Départ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Icon(Icons.arrow_forward, color: AppColors.primary),
                        Text(
                          _trip!.arrivalLocation.city ?? 'Arrivée',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Prix par kg: ${_trip!.pricePerKg} €',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),

              _buildSectionTitle('Détails du colis'),
              _buildTextField(
                controller: _weightCtrl,
                label: 'Poids (kg)',
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Requis';
                  if (double.tryParse(v) == null) return 'Invalide';
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),
              _buildTextField(
                controller: _itemTypeCtrl,
                label: 'Type d\'objet (ex: Vêtements, Électronique)',
                validator: (v) => v?.isEmpty == true ? 'Requis' : null,
              ),
              _buildTextField(
                controller: _descriptionCtrl,
                label: 'Description (optionnel)',
                maxLines: 3,
              ),

              const SizedBox(height: 24),
              _buildSectionTitle('Retrait (Expéditeur)'),
              _buildTextField(
                controller: _pickupAddressCtrl,
                label: 'Adresse de retrait',
                validator: (v) => v?.isEmpty == true ? 'Requis' : null,
              ),
              _buildTextField(
                controller: _pickupCityCtrl,
                label: 'Ville de retrait',
                validator: (v) => v?.isEmpty == true ? 'Requis' : null,
              ),

              const SizedBox(height: 24),
              _buildSectionTitle('Livraison (Destinataire)'),
              _buildTextField(
                controller: _deliveryAddressCtrl,
                label: 'Adresse de livraison',
                validator: (v) => v?.isEmpty == true ? 'Requis' : null,
              ),
              _buildTextField(
                controller: _deliveryCityCtrl,
                label: 'Ville de livraison',
                validator: (v) => v?.isEmpty == true ? 'Requis' : null,
              ),
              _buildTextField(
                controller: _recipientNameCtrl,
                label: 'Nom du destinataire',
                validator: (v) => v?.isEmpty == true ? 'Requis' : null,
              ),
              _buildTextField(
                controller: _recipientPhoneCtrl,
                label: 'Téléphone du destinataire',
                keyboardType: TextInputType.phone,
                validator: (v) => v?.isEmpty == true ? 'Requis' : null,
              ),

              const SizedBox(height: 24),
              _buildSectionTitle('Notes'),
              _buildTextField(
                controller: _notesCtrl,
                label: 'Notes pour le transporteur (optionnel)',
                maxLines: 3,
              ),

              const SizedBox(height: 32),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.05 * 255).round()),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total estimé:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                          '${_calculateTotal().toStringAsFixed(2)} €',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Inclut les frais de service (10%)',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _submitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Confirmer la réservation',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
    void Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1),
          ),
        ),
      ),
    );
  }
}
