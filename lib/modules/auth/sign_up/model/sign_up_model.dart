import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String? service; // Optional for clients, required for providers
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.createdAt,
    this.service,
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "phone": phone,
      "email": email,
      "role": role,
      "service": service,
      "createdAt": createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? '',
      service: map['service'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}