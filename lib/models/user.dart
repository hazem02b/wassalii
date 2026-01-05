class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? avatar;
  final String? address;
  final UserType userType;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.avatar,
    this.address,
    required this.userType,
    required this.createdAt,
    this.updatedAt,
  });
  
  String get fullName => '$firstName $lastName';
  
  factory User.fromJson(Map<String, dynamic> json) {
    // Le backend peut renvoyer soit 'name' (nom complet), soit 'firstName'/'lastName' séparés
    String firstName = '';
    String lastName = '';
    
    if (json['name'] != null && json['name'].toString().isNotEmpty) {
      // Si on a 'name', on le split
      final parts = json['name'].toString().split(' ');
      firstName = parts.first;
      lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    } else {
      // Sinon on utilise firstName/lastName
      firstName = json['firstName'] ?? json['first_name'] ?? '';
      lastName = json['lastName'] ?? json['last_name'] ?? '';
    }
    
    return User(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      email: json['email'] ?? '',
      firstName: firstName,
      lastName: lastName,
      phone: json['phone'],
      avatar: json['avatar'] ?? json['avatar_url'] ?? json['profile_picture'],
      address: json['address'],
      userType: UserType.values.firstWhere(
        (e) => e.toString().split('.').last == json['userType'] || 
               e.toString().split('.').last == json['user_type'] ||
               e.toString().split('.').last == json['role'],
        orElse: () => UserType.client,
      ),
      createdAt: DateTime.parse(json['createdAt'] ?? json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null || json['updated_at'] != null 
          ? DateTime.parse(json['updatedAt'] ?? json['updated_at']) 
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'avatar': avatar,
      'address': address,
      'userType': userType.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
  
  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? avatar,
    UserType? userType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      userType: userType ?? this.userType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum UserType {
  client,
  transporter,
}
