import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? firebaseUser;
  Map<String, dynamic> userData = {};

  // void signUp(Map<String, dynamic> userData, String pass, VoidCallback onSucess,
  //     VoidCallback onFail) {
  //   isLoading = true;
  //   notifyListeners();
  // }

  void signIn(
      {required String email,
      required String pass,
      required VoidCallback onSucess,
      required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();
    _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((value) {
      firebaseUser = value.user;
      onSucess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signOut() async {
    await _auth.signOut();
    userData = {};
    //firebaseUser = null;
    notifyListeners();
  }

  void recoverPass() {}

  // bool isLoggedIn() {}
}
