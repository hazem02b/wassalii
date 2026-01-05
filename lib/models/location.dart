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
