import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_test/user.dart';

class Service {
  Future signIn(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    await updateEmailStatus();
  }

  Future signUp(String name, String email, String password) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    await addUser(name);
    await FirebaseAuth.instance.currentUser?.sendEmailVerification();
  }

  Future resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<String?> getToken() async {
    return await FirebaseAuth.instance.currentUser?.getIdToken();
  }

  Future addUser(String name) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user?.email != null &&
        user?.emailVerified != null &&
        user?.uid != null) {
      final UserApp userApp = UserApp(
          name: name,
          email: user?.email as String,
          emailVerifivationStatus: user?.emailVerified as bool,
          uid: user?.uid as String);
      FirebaseFirestore.instance
          .collection("users")
          .doc(user?.uid)
          .set(userApp.toJson());
    }
  }

  Future updateEmailStatus() async {
    final docUser = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid);
    docUser.update(
        {'email_verified': FirebaseAuth.instance.currentUser?.emailVerified});
  }
}
