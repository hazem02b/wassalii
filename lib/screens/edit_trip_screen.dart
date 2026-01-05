import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/trip_service.dart';
import '../utils/theme_extension.dart';

class EditTripScreen extends StatefulWidget {
  final Map<String, dynamic> trip;
  
  const EditTripScreen({super.key, required this.trip});

  @override
  State<EditTripScreen> createState() => _EditTripScreenState();
}

class _EditTripScreenState extends State<EditTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _departureController = TextEditingController();
  final _arrivalController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _priceController = TextEditingController();
  final _availableSpaceController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;
  
  String _selectedVehicleType = 'Voiture';

  @override
  void initState() {
    super.initState();
    _loadTripData();
  }

  void _loadTripData() {
    _departureController.text = widget.trip['origin_city'] ?? '';
    _arrivalController.text = widget.trip['destination_city'] ?? '';
    _priceController.text = widget.trip['price_per_kg']?.toString() ?? '';
    _availableSpaceController.text = widget.trip['max_weight']?.toString() ?? '';
    _descriptionController.text = widget.trip['description'] ?? '';
    _selectedVehicleType = widget.trip['vehicle_info'] ?? 'Voiture';
    
    // Format date
    if (widget.trip['departure_date'] != null) {
      try {
        final date = DateTime.parse(widget.trip['departure_date']);
        _dateController.text = '${date.day}/${date.month}/${date.year}';
        _timeController.text = '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      } catch (e) {
        // Ignore
      }
    }
  }

  @override
  void dispose() {
    _departureController.dispose();
    _arrivalController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _priceController.dispose();
    _availableSpaceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      _dateController.text = '${date.day}/${date.month}/${date.year}';
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      _timeController.text = '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _updateTrip() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Convertir la date et l'heure en format ISO
      final dateParts = _dateController.text.split('/');
      final timeParts = _timeController.text.split(':');
      final departureDate = DateTime(
        int.parse(dateParts[2]), // année
        int.parse(dateParts[1]), // mois
        int.parse(dateParts[0]), // jour
        int.parse(timeParts[0]), // heure
        int.parse(timeParts[1]), // minute
      ).toIso8601String();

      await TripService().updateTrip(widget.trip['id'], {
        'origin_city': _departureController.text.trim(),
        'origin_country': widget.trip['origin_country'] ?? 'Tunisie',
        'destination_city': _arrivalController.text.trim(),
        'destination_country': widget.trip['destination_country'] ?? 'Tunisie',
        'departure_date': departureDate,
        'max_weight': double.parse(_availableSpaceController.text),
        'price_per_kg': double.parse(_priceController.text),
        'description': _descriptionController.text.trim(),
        'vehicle_info': _selectedVehicleType,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Trajet modifié avec succès'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
          'Modifier le trajet',
          style: TextStyle(color: context.textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informations sur l\'itinéraire',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                
                TextFormField(
                  controller: _departureController,
                  decoration: InputDecoration(
                    hintText: 'De (ex: Casablanca)',
                    prefixIcon: const Icon(Icons.location_on_outlined, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: context.borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: context.borderColor),
                    ),
                    filled: true,
                    fillColor: context.surfaceColor,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                  validator: (value) => value?.isEmpty ?? true ? 'Requis' : null,
                ),
                
                const SizedBox(height: 12),
                
                TextFormField(
                  controller: _arrivalController,
                  decoration: InputDecoration(
                    hintText: 'À (ex: Marrakech)',
                    prefixIcon: const Icon(Icons.location_on_outlined, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: context.borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: context.borderColor),
                    ),
                    filled: true,
                    fillColor: context.surfaceColor,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                  validator: (value) => value?.isEmpty ?? true ? 'Requis' : null,
                ),
                
                const SizedBox(height: 20),
                
                const Text(
                  'Horaire',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'mm/dd/yy',
                          prefixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: context.borderColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: context.borderColor),
                          ),
                          filled: true,
                          fillColor: context.surfaceColor,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        ),
                        onTap: _selectDate,
                        validator: (value) => value?.isEmpty ?? true ? 'Requis' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _timeController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: '--:--',
                          prefixIcon: const Icon(Icons.access_time_outlined, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: context.borderColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: context.borderColor),
                          ),
                          filled: true,
                          fillColor: context.surfaceColor,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        ),
                        onTap: _selectTime,
                        validator: (value) => value?.isEmpty ?? true ? 'Requis' : null,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                const Text(
                  'Capacité et tarification',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                
                TextFormField(
                  controller: _availableSpaceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Capacité totale (kg)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: context.borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: context.borderColor),
                    ),
                    filled: true,
                    fillColor: context.surfaceColor,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                  validator: (value) => value?.isEmpty ?? true ? 'Requis' : null,
                ),
                
                const SizedBox(height: 12),
                
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '(DT) Prix par kg',
                    prefixIcon: const Icon(Icons.attach_money, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: context.borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: context.borderColor),
                    ),
                    filled: true,
                    fillColor: context.surfaceColor,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                  validator: (value) => value?.isEmpty ?? true ? 'Requis' : null,
                ),
                
                const SizedBox(height: 12),
                
                DropdownButtonFormField<String>(
                  value: _selectedVehicleType,
                  decoration: InputDecoration(
                    hintText: 'Sélectionner le type de véhicule',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: context.borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: context.borderColor),
                    ),
                    filled: true,
                    fillColor: context.surfaceColor,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                  items: ['Voiture', 'Camionnette', 'Camion', 'Moto']
                      .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedVehicleType = value!),
                ),
                
                const SizedBox(height: 20),
                
                const Text(
                  'Informations supplémentaires',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Description (optionnelle)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: context.borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: context.borderColor),
                    ),
                    filled: true,
                    fillColor: context.surfaceColor,
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                
                const SizedBox(height: 28),
                
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updateTrip,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9800),
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Enregistrer les modifications',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
