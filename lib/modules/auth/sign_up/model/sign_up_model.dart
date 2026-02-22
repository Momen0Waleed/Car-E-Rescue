class UserModel {
  final String id;
  final String email;
  final String name;
  final String role;
  final String phone;
  final bool available;
  final double rating;
  final int totalJobs;

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
    this.available = false,
    this.rating = 0.0,
    this.totalJobs = 0,
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
      available: map['available'] ?? false,
      rating: (map['rating'] ?? 0.0).toDouble(),
      totalJobs: map['total jops'] ?? 0,
      workshopName: map['workshop name'],
      experienceYears: map['experince years'] is String
          ? int.tryParse(map['experince years'])
          : map['experince years'] as int?,
      carType: map['car type'],
      carModel: map['car model'],
    );
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    bool? available,
    double? rating,
    int? totalJobs,
    String? carType,
    String? carModel,
    String? workshopName,
    int? experienceYears,
    String? role,
  }) {
    return UserModel(
      id: id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      available: available ?? this.available,
      rating: rating ?? this.rating,
      totalJobs: totalJobs ?? this.totalJobs,
      carType: carType ?? this.carType,
      carModel: carModel ?? this.carModel,
      workshopName: workshopName ?? this.workshopName,
      experienceYears: experienceYears ?? this.experienceYears,
      role: role ?? this.role,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final data = json['user'] ?? json;

    return UserModel(
      id: data['id']?.toString() ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      role: data['role'] ?? 'client',
      workshopName: data['workshop name'],
      experienceYears: data['experince years'] is String
          ? int.tryParse(data['experince years'])
          : data['experince years'] as int?,
      carType: data['car type'],
      carModel: data['car model'],
    );
  }
}
