class AvailableRequestModel {
  final int requestId;
  final String userName;
  final String type;
  final double lat;
  final double lng;
  final double distance;
  final DateTime createdAt;
  final String? workshopName;
  final double? workshopLat;
  final double? workshopLng;

  AvailableRequestModel({
    required this.requestId,
    required this.userName,
    required this.type,
    required this.lat,
    required this.lng,
    required this.distance,
    required this.createdAt,
    this.workshopName,
    this.workshopLat,
    this.workshopLng,
  });

  factory AvailableRequestModel.fromJson(Map<String, dynamic> json) {
    return AvailableRequestModel(
      requestId: json['request id'] ?? json['request_id'] ?? json['id'] ?? 0,
      userName: json['user name'] ?? json['user_name'] ?? 'Unknown',
      type: json['type'] ?? 'General',
      lat: (json['request lat'] ?? json['request_lat'] ?? json['lat'] ?? 0.0).toDouble(),
      lng: (json['request lng'] ?? json['request_lng'] ?? json['lng'] ?? 0.0).toDouble(),
      distance: (json['distance in km'] ?? json['distance_in_km'] ?? json['distance'] ?? 0.0).toDouble(),
      createdAt: DateTime.tryParse(json['created at'] ?? json['created_at'] ?? '') ?? DateTime.now(),
      workshopName: json['workshop name'] ?? json['workshop_name'],
      workshopLat: (json['workshop lat'] ?? json['workshop_lat'])?.toDouble(),
      workshopLng: (json['workshop lng'] ?? json['workshop_lng'])?.toDouble(),
    );
  }
}