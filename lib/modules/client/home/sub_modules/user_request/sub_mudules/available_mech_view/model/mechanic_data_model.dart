class MechanicDataModel {
  final String mechanicId;
  final String workshopName;
  final double workshopLat;
  final double workshopLng;
  final double distanceInKm;

  MechanicDataModel({
    required this.mechanicId,
    required this.workshopName,
    required this.workshopLat,
    required this.workshopLng,
    required this.distanceInKm,
  });

  factory MechanicDataModel.fromJson(Map<String, dynamic> json) {
    return MechanicDataModel(
      mechanicId: json['mechanic id'],
      workshopName: json['workshop name'],
      workshopLat: (json['workshop lat'] as num).toDouble(),
      workshopLng: (json['workshop lng'] as num).toDouble(),
      distanceInKm: (json['distance in km'] as num).toDouble(),
    );
  }
}