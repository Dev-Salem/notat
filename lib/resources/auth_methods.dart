import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_again/resources/firestore_methods.dart';
import 'package:flutter_application_again/resources/firstore_folder_methods.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get useUid => _auth.currentUser!.uid;

  Future<String> createUser(
      {required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await FirestoreFolderService().createMainFolder();
      return 'Account created successfully';
    } on FirebaseException catch (e) {
      return e.message!;
    }
  }

  Future<String?> loginUser(
      {required String email, required String password}) async {
    String? feedback;
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseException catch (e) {
      feedback = e.message;
    }
    return feedback;
  }

  Future<String?> restPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
    return null;
  }

  Future<String?> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
    return null;
  }

  Future<String?> deleteAccount() async {
    try {
      await FirestoreService().deleteAllDocs(useUid);
      await _auth.currentUser!.delete();
    } on FirebaseException catch (e) {
      return e.message;
    }

    return null;
  }

  Future<String?> reloadUser() async {
    try {
      await _auth.currentUser?.reload();
    } on FirebaseException catch (e) {
      return e.message;
    }
    return null;
  }

  Future<String?> reauthentication(String password) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
          email: _auth.currentUser!.email!, password: password);
      await _auth.currentUser!.reauthenticateWithCredential(credential);
    } on FirebaseException catch (e) {
      return e.message;
    }
    return null;
  }

  bool get isVerified => _auth.currentUser!.emailVerified;
}
