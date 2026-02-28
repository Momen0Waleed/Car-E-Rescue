class MechanicHistoryModel {
  final int requestId;
  final String userName;
  final String status;
  final String type;
  final DateTime createdAt;
  final String completedAt; // Kept as String due to "----" notes

  MechanicHistoryModel({
    required this.requestId,
    required this.userName,
    required this.status,
    required this.type,
    required this.createdAt,
    required this.completedAt,
  });

  factory MechanicHistoryModel.fromJson(Map<String, dynamic> json) {
    return MechanicHistoryModel(
      requestId: json['request id'] ?? 0,
      userName: json['user name'] ?? 'Unknown',
      status: json['status'] ?? 'Unknown',
      type: json['type'] ?? 'General',
      createdAt: DateTime.parse(json['created at']),
      completedAt: json['completed at'] ?? '----',
    );
  }
}