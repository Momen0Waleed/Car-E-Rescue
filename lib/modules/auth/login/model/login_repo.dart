import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;

class LoginRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> login(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        throw Exception("Wrong password provided.");
      } else if (e.code == 'invalid-email') {
        throw Exception("The email address is badly formatted.");
      }
      throw Exception(e.message ?? "An unknown error occurred.");
    }
  }

  Future<Map<String, dynamic>> getUserData(String uid) async {
    var clientDoc = await _firestore.collection("clients").doc(uid).get();
    if (clientDoc.exists) {
      return clientDoc.data()!;
    }

    var providerDoc = await _firestore.collection("providers").doc(uid).get();
    if (providerDoc.exists) {
      return providerDoc.data()!;
    }

    throw Exception("User data not found in any collection.");
  }

  Future<void> saveUserRoleLocally(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_role', role);
  }

  Future<String?> getUserRoleLocally() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role');
  }

  // Clear role on logout
  Future<void> clearLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_role');
  }
}