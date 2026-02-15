class UserModel {
  final String id;
  final String email;
  final String name;
  final String role;
  final String phone;

  // Optional fields based on role
  final String? workshopName;
  final int? experienceYears;
  final String? carType;
  final String? carModel;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.phone,
    this.workshopName,
    this.experienceYears,
    this.carType,
    this.carModel,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? '',
      phone: map['phone'] ?? '',
      workshopName: map['workshop_name'],
      experienceYears: map['experience_years'],
      carType: map['car_type'],
      carModel: map['car_model'],
    );
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? carType,
    String? carModel,
    String? role,
  }) {
    return UserModel(
      id: id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      carType: carType ?? this.carType,
      carModel: carModel ?? this.carModel,
      role: role ?? this.role,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      carType: json['car_type'] ?? '',
      carModel: json['car_model'] ?? '',
      role: json['role'] ?? 'client',
    );
  }
}
