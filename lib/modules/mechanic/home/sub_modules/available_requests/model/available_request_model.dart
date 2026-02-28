class AvailableRequestModel {
  final int requestId;
  final String userName;
  final String type;
  final double lat;
  final double lng;
  final double distance;
  final DateTime createdAt;

  AvailableRequestModel({
    required this.requestId,
    required this.userName,
    required this.type,
    required this.lat,
    required this.lng,
    required this.distance,
    required this.createdAt,
  });

  factory AvailableRequestModel.fromJson(Map<String, dynamic> json) {
    return AvailableRequestModel(
      requestId: json['request id'] ?? 0,
      userName: json['user name'] ?? 'Unknown',
      type: json['type'] ?? 'General',
      lat: (json['request lat'] ?? 0.0).toDouble(),
      lng: (json['request lng'] ?? 0.0).toDouble(),
      distance: (json['distance in km'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(json['created at']),
    );
  }
}