import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/trip_service.dart';
import '../utils/theme_extension.dart';
import '../utils/app_localizations.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
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
  bool _isPriceNegotiable = false;
  String _selectedTripType = 'Ponctuel';
  bool _acceptDocuments = false;
  bool _acceptClothing = false;
  bool _acceptElectronics = false;
  bool _acceptFood = false;
  bool _acceptBooks = false;
  bool _acceptFurniture = false;
  bool _offerInsurance = false;

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

  Future<void> _createTrip() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Préparer la liste des items acceptés
      List<String> acceptedItems = [];
      if (_acceptDocuments) acceptedItems.add('Documents');
      if (_acceptClothing) acceptedItems.add('Vêtements');
      if (_acceptElectronics) acceptedItems.add('Électronique');
      if (_acceptFood) acceptedItems.add('Alimentation');
      if (_acceptBooks) acceptedItems.add('Livres');
      if (_acceptFurniture) acceptedItems.add('Meubles');

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

      await TripService().createTrip({
        'origin_city': _departureController.text.trim(),
        'origin_country': 'Tunisie', // Par défaut
        'destination_city': _arrivalController.text.trim(),
        'destination_country': 'Tunisie', // Par défaut
        'departure_date': departureDate,
        'max_weight': double.parse(_availableSpaceController.text),
        'price_per_kg': double.parse(_priceController.text),
        'description': _descriptionController.text.trim(),
        'accepted_items': acceptedItems,
        'vehicle_info': _selectedVehicleType,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).tripCreatedSuccess),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context).error}: $e'),
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
          AppLocalizations.of(context).createNewTrip,
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
                // Informations sur l'itinéraire
                Text(
                  AppLocalizations.of(context).routeInformation,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                
                TextFormField(
                  controller: _departureController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).fromExample,
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
                  validator: (value) => value?.isEmpty ?? true ? AppLocalizations.of(context).required : null,
                ),
                
                const SizedBox(height: 12),
                
                TextFormField(
                  controller: _arrivalController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).toExample,
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
                  validator: (value) => value?.isEmpty ?? true ? AppLocalizations.of(context).required : null,
                ),
                
                const SizedBox(height: 20),
                
                // Horaire
                Text(
                  AppLocalizations.of(context).schedule,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                        validator: (value) => value?.isEmpty ?? true ? AppLocalizations.of(context).required : null,
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
                        validator: (value) => value?.isEmpty ?? true ? AppLocalizations.of(context).required : null,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Capacité et tarification
                Text(
                  AppLocalizations.of(context).capacityPricing,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                
                TextFormField(
                  controller: _availableSpaceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).totalCapacity,
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
                  validator: (value) => value?.isEmpty ?? true ? AppLocalizations.of(context).required : null,
                ),
                
                const SizedBox(height: 12),
                
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).pricePerKg,
                    prefixIcon: const Icon(Icons.euro_outlined, size: 20),
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
                  validator: (value) => value?.isEmpty ?? true ? AppLocalizations.of(context).required : null,
                ),
                
                const SizedBox(height: 12),
                
                DropdownButtonFormField<String>(
                  value: _selectedVehicleType,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).selectVehicleType,
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
                  items: [
                    DropdownMenuItem(value: 'Voiture', child: Text(AppLocalizations.of(context).car)),
                    DropdownMenuItem(value: 'Camionnette', child: Text(AppLocalizations.of(context).van)),
                    DropdownMenuItem(value: 'Camion', child: Text(AppLocalizations.of(context).truck)),
                    DropdownMenuItem(value: 'Moto', child: Text(AppLocalizations.of(context).motorcycle)),
                  ],
                  onChanged: (value) => setState(() => _selectedVehicleType = value!),
                ),
                
                const SizedBox(height: 12),
                
                CheckboxListTile(
                  value: _isPriceNegotiable,
                  onChanged: (value) => setState(() => _isPriceNegotiable = value!),
                  title: Text(AppLocalizations.of(context).priceNegotiable),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  activeColor: const Color(0xFFFF9800),
                ),
                
                const SizedBox(height: 20),
                
                // Type de trajet
                Text(
                  AppLocalizations.of(context).tripType,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                
                _TripTypeButton(
                  label: AppLocalizations.of(context).oneTime,
                  isSelected: _selectedTripType == 'Ponctuel',
                  onTap: () => setState(() => _selectedTripType = 'Ponctuel'),
                ),
                const SizedBox(height: 8),
                _TripTypeButton(
                  label: AppLocalizations.of(context).weekly,
                  isSelected: _selectedTripType == 'Hebdomadaire',
                  onTap: () => setState(() => _selectedTripType = 'Hebdomadaire'),
                ),
                const SizedBox(height: 8),
                _TripTypeButton(
                  label: AppLocalizations.of(context).monthly,
                  isSelected: _selectedTripType == 'Mensuel',
                  onTap: () => setState(() => _selectedTripType = 'Mensuel'),
                ),
                
                const SizedBox(height: 20),
                
                // Articles acceptés
                Text(
                  AppLocalizations.of(context).acceptedItems,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _ArticleCheckbox(
                      label: AppLocalizations.of(context).documents,
                      value: _acceptDocuments,
                      onChanged: (v) => setState(() => _acceptDocuments = v!),
                    ),
                    _ArticleCheckbox(
                      label: AppLocalizations.of(context).clothing,
                      value: _acceptClothing,
                      onChanged: (v) => setState(() => _acceptClothing = v!),
                    ),
                    _ArticleCheckbox(
                      label: AppLocalizations.of(context).electronics,
                      value: _acceptElectronics,
                      onChanged: (v) => setState(() => _acceptElectronics = v!),
                    ),
                    _ArticleCheckbox(
                      label: AppLocalizations.of(context).food,
                      value: _acceptFood,
                      onChanged: (v) => setState(() => _acceptFood = v!),
                    ),
                    _ArticleCheckbox(
                      label: AppLocalizations.of(context).books,
                      value: _acceptBooks,
                      onChanged: (v) => setState(() => _acceptBooks = v!),
                    ),
                    _ArticleCheckbox(
                      label: AppLocalizations.of(context).furniture,
                      value: _acceptFurniture,
                      onChanged: (v) => setState(() => _acceptFurniture = v!),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Informations supplémentaires
                Text(
                  AppLocalizations.of(context).additionalInformation,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).descriptionOptional,
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
                
                const SizedBox(height: 12),
                
                CheckboxListTile(
                  value: _offerInsurance,
                  onChanged: (value) => setState(() => _offerInsurance = value!),
                  title: Text(AppLocalizations.of(context).offerInsurance),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  activeColor: const Color(0xFFFF9800),
                ),
                
                const SizedBox(height: 28),
                
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _createTrip,
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
                        : Text(
                            AppLocalizations.of(context).publishTrip,
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFF9800),
        unselectedItemColor: context.textSecondary,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.dashboard), label: AppLocalizations.of(context).dashboard),
          BottomNavigationBarItem(icon: const Icon(Icons.list), label: AppLocalizations.of(context).trips),
          BottomNavigationBarItem(icon: const Icon(Icons.add_circle), label: AppLocalizations.of(context).create),
          BottomNavigationBarItem(icon: const Icon(Icons.message), label: AppLocalizations.of(context).messages),
          BottomNavigationBarItem(icon: const Icon(Icons.person), label: AppLocalizations.of(context).profile),
        ],
        onTap: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/transporter-dashboard');
          if (index == 1) Navigator.pushReplacementNamed(context, '/my-trips');
          if (index == 3) Navigator.pushNamed(context, '/transporter-messages');
          if (index == 4) Navigator.pushNamed(context, '/transporter-profile');
        },
      ),
    );
  }
}

class _TripTypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TripTypeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          border: Border.all(
            color: isSelected ? const Color(0xFFFF9800) : context.borderColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFFFF9800) : context.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _ArticleCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _ArticleCheckbox({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          border: Border.all(color: context.borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: const Color(0xFFFF9800),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
