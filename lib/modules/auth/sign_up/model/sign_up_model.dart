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
  final double? workshopLat;
  final double? workshopLng;
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
    this.workshopLat,
    this.workshopLng,
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
      available: map['available'] is bool
          ? map['available']
          : (map['available']?.toString().toLowerCase() == 'true'),
      rating: map['rating'] is num
          ? (map['rating'] as num).toDouble()
          : double.tryParse(map['rating']?.toString() ?? '0.0') ?? 0.0,
      totalJobs: map['total jops'] is int
          ? map['total jops']
          : int.tryParse(map['total jops']?.toString() ?? '0') ?? 0,
      workshopName: map['workshop name'] ?? map['workshop_name'],
      workshopLat: (map['workshop lat'] ?? map['workshop_lat'] ?? map['workshop_latitude'])?.toDouble(),
      workshopLng: (map['workshop lng'] ?? map['workshop_lng'] ?? map['workshop_longitude'])?.toDouble(),
      experienceYears: map['experince years'] != null
          ? (map['experince years'] is String ? int.tryParse(map['experince years']) : map['experince years'] as int?)
          : (map['experience_years'] is String ? int.tryParse(map['experience_years']) : map['experience_years'] as int?),
      carType: map['car type'] ?? map['car_type'],
      carModel: map['car model'] ?? map['car_model'],
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
    double? workshopLat,
    double? workshopLng,
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
      workshopLat: workshopLat ?? this.workshopLat,
      workshopLng: workshopLng ?? this.workshopLng,
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
      available: data['available'] is bool
          ? data['available']
          : (data['available']?.toString().toLowerCase() == 'true'),
      rating: data['rating'] is num
          ? (data['rating'] as num).toDouble()
          : double.tryParse(data['rating']?.toString() ?? '0.0') ?? 0.0,
      totalJobs: data['total jops'] is int
          ? data['total jops']
          : int.tryParse(data['total jops']?.toString() ?? '0') ?? 0,
      workshopName: data['workshop name'] ?? data['workshop_name'],
      workshopLat: (data['workshop lat'] ?? data['workshop_lat'] ?? data['workshop_latitude'])?.toDouble(),
      workshopLng: (data['workshop lng'] ?? data['workshop_lng'] ?? data['workshop_longitude'])?.toDouble(),
      experienceYears: data['experince years'] != null
          ? (data['experince years'] is String ? int.tryParse(data['experince years']) : data['experince years'] as int?)
          : (data['experience_years'] is String ? int.tryParse(data['experience_years']) : data['experience_years'] as int?),
      carType: data['car type'] ?? data['car_type'],
      carModel: data['car model'] ?? data['car_model'],
    );
  }
}
