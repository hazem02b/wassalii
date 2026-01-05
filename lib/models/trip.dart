import 'location.dart';

class Trip {
  final String id;
  final String transporterId;
  final Location departureLocation;
  final Location arrivalLocation;
  final DateTime departureDate;
  final double availableSpace;
  final double pricePerKg;
  final TripStatus status;
  final String? vehicleType;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  Trip({
    required this.id,
    required this.transporterId,
    required this.departureLocation,
    required this.arrivalLocation,
    required this.departureDate,
    required this.availableSpace,
    required this.pricePerKg,
    required this.status,
    this.vehicleType,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });
  
  factory Trip.fromJson(Map<String, dynamic> json) {
    // Handle both old format (nested objects) and new backend format (flat fields)
    if (json.containsKey('origin_city')) {
      return Trip(
        id: (json['id'] ?? 0).toString(),
        transporterId: (json['transporter_id'] ?? 0).toString(),
        departureLocation: Location(
          latitude: 0,
          longitude: 0,
          address: '${json['origin_city']}, ${json['origin_country']}',
          city: json['origin_city'],
          country: json['origin_country'],
        ),
        arrivalLocation: Location(
          latitude: 0,
          longitude: 0,
          address: '${json['destination_city']}, ${json['destination_country']}',
          city: json['destination_city'],
          country: json['destination_country'],
        ),
        departureDate: DateTime.parse(json['departure_date'] ?? DateTime.now().toIso8601String()),
        availableSpace: (json['available_weight'] ?? json['max_weight'] ?? 0).toDouble(),
        pricePerKg: (json['price_per_kg'] ?? 0).toDouble(),
        status: (json['is_active'] == true) ? TripStatus.available : TripStatus.completed,
        vehicleType: json['vehicle_info'],
        notes: json['description'],
        createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
        updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      );
    }

    return Trip(
      id: json['id'] ?? json['_id'] ?? '',
      transporterId: json['transporterId'] ?? '',
      departureLocation: Location.fromJson(json['departureLocation'] ?? {}),
      arrivalLocation: Location.fromJson(json['arrivalLocation'] ?? {}),
      departureDate: DateTime.parse(json['departureDate'] ?? DateTime.now().toIso8601String()),
      availableSpace: (json['availableSpace'] ?? 0).toDouble(),
      pricePerKg: (json['pricePerKg'] ?? 0).toDouble(),
      status: TripStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => TripStatus.available,
      ),
      vehicleType: json['vehicleType'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transporterId': transporterId,
      'departureLocation': departureLocation.toJson(),
      'arrivalLocation': arrivalLocation.toJson(),
      'departureDate': departureDate.toIso8601String(),
      'availableSpace': availableSpace,
      'pricePerKg': pricePerKg,
      'status': status.toString().split('.').last,
      'vehicleType': vehicleType,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

enum TripStatus {
  available,
  inProgress,
  completed,
  cancelled,
}
