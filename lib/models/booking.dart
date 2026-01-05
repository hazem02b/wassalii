class Location {
  final double latitude;
  final double longitude;
  final String address;
  final String? city;
  final String? country;
  
  Location({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.city,
    this.country,
  });
  
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      address: json['address'] ?? '',
      city: json['city'],
      country: json['country'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'city': city,
      'country': country,
    };
  }
}

class Booking {
  final String id;
  final String clientId;
  final String? transporterId;
  final Location pickupLocation;
  final Location deliveryLocation;
  final PackageDetails packageDetails;
  final DateTime pickupDate;
  final double price;
  final BookingStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  Booking({
    required this.id,
    required this.clientId,
    this.transporterId,
    required this.pickupLocation,
    required this.deliveryLocation,
    required this.packageDetails,
    required this.pickupDate,
    required this.price,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });
  
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? json['_id'] ?? '',
      clientId: json['clientId'] ?? '',
      transporterId: json['transporterId'],
      pickupLocation: Location.fromJson(json['pickupLocation'] ?? {}),
      deliveryLocation: Location.fromJson(json['deliveryLocation'] ?? {}),
      packageDetails: PackageDetails.fromJson(json['packageDetails'] ?? {}),
      pickupDate: DateTime.parse(json['pickupDate'] ?? DateTime.now().toIso8601String()),
      price: (json['price'] ?? 0).toDouble(),
      status: BookingStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => BookingStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'transporterId': transporterId,
      'pickupLocation': pickupLocation.toJson(),
      'deliveryLocation': deliveryLocation.toJson(),
      'packageDetails': packageDetails.toJson(),
      'pickupDate': pickupDate.toIso8601String(),
      'price': price,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class PackageDetails {
  final String description;
  final double weight;
  final PackageSize size;
  final String? notes;
  
  PackageDetails({
    required this.description,
    required this.weight,
    required this.size,
    this.notes,
  });
  
  factory PackageDetails.fromJson(Map<String, dynamic> json) {
    return PackageDetails(
      description: json['description'] ?? '',
      weight: (json['weight'] ?? 0).toDouble(),
      size: PackageSize.values.firstWhere(
        (e) => e.toString().split('.').last == json['size'],
        orElse: () => PackageSize.medium,
      ),
      notes: json['notes'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'weight': weight,
      'size': size.toString().split('.').last,
      'notes': notes,
    };
  }
}

enum BookingStatus {
  pending,
  accepted,
  inProgress,
  completed,
  cancelled,
}

enum PackageSize {
  small,
  medium,
  large,
  extraLarge,
}
