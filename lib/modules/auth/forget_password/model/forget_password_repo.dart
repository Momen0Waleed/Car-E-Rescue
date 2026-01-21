import 'package:firebase_auth/firebase_auth.dart';

class ForgetPasswordRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception("No user found with this email address.");
      } else if (e.code == 'invalid-email') {
        throw Exception("The email address is not valid.");
      }
      throw Exception(e.message ?? "An error occurred. Please try again.");
    } catch (e) {
      throw Exception("An unexpected error occurred.");
    }
  }
}