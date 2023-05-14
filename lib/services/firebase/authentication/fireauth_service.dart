import 'dart:developer';
import 'package:esports_battlefield_arena/app/failures.dart';
import 'package:esports_battlefield_arena/services/firebase/authentication/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireAuthService extends Auth {
  final _firebaseAuth = FirebaseAuth.instance;
  @override
  resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      Failure errorMsg;
      errorMsg = fireauthError(e.code);
      log(errorMsg.toString());
      log(e.message.toString());
      throw errorMsg;
    }
  }

  @override
  Future<String?> signIn(String email, String password) async {
    try {
      var userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.user != null) {
        return userCredential.user!.uid;
      } else {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      Failure errorMsg;
      errorMsg = fireauthError(e.code);
      log(errorMsg.toString());
      log(e.message.toString());
      throw errorMsg;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      Failure errorMsg;
      errorMsg = fireauthError(e.code);
      log(errorMsg.toString());
      log(e.message.toString());
      throw errorMsg;
    }
  }

  @override
  Future<String?> createAccount(String email, String password) async {
    try {
      //create user first
      var userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      //send email verification
      if (userCredential.user != null) {
        await userCredential.user!.sendEmailVerification();
        return userCredential.user!.uid;
      } else {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      Failure errorMsg;
      errorMsg = fireauthError(e.code);
      log(errorMsg.toString());
      log(e.message.toString());
      throw errorMsg;
    }
  }

  @override
  bool isUserSignOn() {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        log("There is a user sign in with uid: ${FirebaseAuth.instance.currentUser!.uid.toString()}");
        return true;
      } else {
        log("No user is sign on");
        return false;
      }
    } on FirebaseAuthException catch (e) {
      Failure errorMsg;
      errorMsg = fireauthError(e.code);
      log(errorMsg.toString());
      log(e.message.toString());
      throw errorMsg;
    }
  }

  @override
  deleteUserAuth() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      await user?.delete();
    } on FirebaseAuthException catch (e) {
      Failure errorMsg;
      errorMsg = fireauthError(e.code);
      log(errorMsg.toString());
      log(e.message.toString());
      throw errorMsg;
    }
  }

  @override
  reAuthenticate(String email, String password) async {
    try {
      // Prompt the user to re-provide their sign-in credentials.
      // Then, use the credentials to reauthenticate:
      var user = FirebaseAuth.instance.currentUser;
      await user?.reauthenticateWithCredential(
          EmailAuthProvider.credential(email: email, password: password));
    } on FirebaseAuthException catch (e) {
      Failure errorMsg;
      errorMsg = fireauthError(e.code);
      log(errorMsg.toString());
      log(e.message.toString());
      throw errorMsg;
    }
  }

  @override
  String? currentUser() {
    if (_firebaseAuth.currentUser != null) {
      return _firebaseAuth.currentUser!.uid;
    } else {
      return null;
    }
  }

  @override
  String? getCurrentUserEmail() {
    if (_firebaseAuth.currentUser != null) {
      return _firebaseAuth.currentUser!.email;
    } else {
      return null;
    }
  }
}
