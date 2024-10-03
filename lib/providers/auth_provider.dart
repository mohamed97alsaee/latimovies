import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:latimovies/providers/base_provider.dart';

class AutheticationProvider extends BaseProvider {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  bool loading = false;
  Future<bool> login(String email, String password) async {
    setBusy(true);
    UserCredential userCred = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    if (userCred.user != null) {
      setBusy(false);

      return true;
    } else {
      setBusy(false);

      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    setBusy(true);
    firebaseAuth.sendPasswordResetEmail(email: email);

    setBusy(false);

    return true;
  }

  Future<bool> createAccount(String name, String email, String password) async {
    UserCredential userCred = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (userCred.user != null) {
      FirebaseFirestore.instance
          .collection("users")
          .add({"name": name, "email": email, "user_uid": userCred.user!.uid});

      return true;
    } else {
      return false;
    }
  }

  Future<bool> logout() async {
    firebaseAuth.signOut();
    return true;
  }
}
