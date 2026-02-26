// user_request_model.dart

class UserRequestModel {
  final int? requestId;
  final String? mechanicId;
  final String? mechanicName;
  final String status;
  final String type;
  final String createdAt;
  final String? completedAt;

  UserRequestModel({
    this.requestId,
    this.mechanicId,
    this.mechanicName,
    required this.status,
    required this.type,
    required this.createdAt,
    this.completedAt,
  });


  factory UserRequestModel.fromJson(Map<String, dynamic> json) {
    return UserRequestModel(
      requestId: json['request id'],
      mechanicId: json['mechanic id'],
      mechanicName: json['mechanic name'],
      status: json['status'] ?? 'Unknown',
      type: json['type'] ?? 'General',
      createdAt: json['created at'] ?? '',
      completedAt: json['completed at'],
    );
  }
}