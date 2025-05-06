// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';

class SignUpController {
  String? email;
  String? password;
  User? user;

  void setEmail(String email) {
    this.email = email;
  }

  void setPassword(String password) {
    this.password = password;
  }

  Future<void> completeSignUP(String email, String password) async {
    this.email = email;
    this.password = password;
    await createNewFireBaseUser();
    print("Sign up successful");
  }

  Future<void> createNewFireBaseUser() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      user = userCredential.user;
      print('User created with UID: ${user?.uid} and email: ${user?.email}');
    } on FirebaseAuthException catch (e) {
      print('Error savign user data: $e');
    }
  }
}
