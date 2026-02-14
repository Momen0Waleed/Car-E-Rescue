class UserRequestModel {
  final String? mechanicId;
  final String? mechanicName;
  final String status;
  final String type;
  final String createdAt;

  UserRequestModel({
    this.mechanicId,
    this.mechanicName,
    required this.status,
    required this.type,
    required this.createdAt,
  });

  factory UserRequestModel.fromJson(Map<String, dynamic> json) {
    return UserRequestModel(
      mechanicId: json['mechanic id'],
      mechanicName: json['mechanic name'],
      status: json['status'],
      type: json['type'],
      createdAt: json['created at'],
    );
  }
}