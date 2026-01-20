import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sign_up_model.dart';

class SignUpRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> createUser(String email, String password) {
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> saveUserData(UserModel user, String collection) async {
    try {
      if (_auth.currentUser != null) {
        await _auth.currentUser!.updateDisplayName(user.name);
      }

      await _firestore
          .collection(collection)
          .doc(user.uid)
          .set(user.toMap());

    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw Exception("Access denied. Please contact support.");
      } else if (e.code == 'network-request-failed') {
        throw Exception("Please check your internet connection.");
      }
      // throw Exception("Database Error: ${e.message}");
      throw Exception("Something went wrong please try again later.");
    } catch (e) {
      throw Exception("An unexpected error occurred while saving your data.");
    }
  }
}