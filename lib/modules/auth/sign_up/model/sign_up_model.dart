class UserModel {
  final String id;
  final String email;
  final String name;
  final String role;

  // Optional fields based on role
  final String? workshopName;
  final int? experienceYears;
  final String? carType;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.workshopName,
    this.experienceYears,
    this.carType,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? '',
      workshopName: map['workshop_name'],
      experienceYears: map['experience_years'],
      carType: map['car_type'],
    );
  }
}