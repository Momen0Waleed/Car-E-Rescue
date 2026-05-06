class RatingModel {
  final int ratingId;
  final int requestId;
  final String mechanicId;
  final String mechanicName;
  final int rate;
  final String feedback;
  final String createdAt;

  RatingModel({
    required this.ratingId,
    required this.requestId,
    required this.mechanicId,
    required this.mechanicName,
    required this.rate,
    required this.feedback,
    required this.createdAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      ratingId: json['rating id'] ?? 0,
      requestId: json['request id'] ?? 0,
      mechanicId: json['mechanic id'] ?? '',
      mechanicName: json['mechanic name'] ?? '',
      rate: json['rate'] ?? 0,
      feedback: json['feedback'] ?? '',
      createdAt: json['created at'] ?? '',
    );
  }
}
