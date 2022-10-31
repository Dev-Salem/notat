import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_again/resources/auth_methods.dart';
import 'package:flutter_application_again/resources/firestore_methods.dart';
import 'package:flutter_application_again/resources/internet_connection.dart';

class FirestoreFolderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userUid = AuthService().useUid;

  createMainFolder() async {
    //create the folder 'All' so you have a document to start with
    _firestore.settings.copyWith(persistenceEnabled: true);
    List<String> notes = [];
    try {
      await _firestore.collection(userUid).doc('folders').set({'All': notes});
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Future<String?> createFolder(String name) async {
    final internet = await Connection.checkInternet();
    List<String> notes = [];
    try {
      if (!internet) {
        return 'No internet connection';
      }
      await _firestore.collection(userUid).doc('folders').update({name: notes});
    } on FirebaseException catch (e) {
      return e.message;
    }
    return null;
  }

  deleteFolder(String name) async {
    final updates = <String, dynamic>{name: FieldValue.delete()};
    if (name == 'All') {
      return;
    }
    try {
      await _firestore.collection(userUid).doc('folders').update(updates);
      await FirestoreService().deleteDocsOfFolder(name);
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Future<String?> addDocToFolder(
      {required String folderField, required String noteUid}) async {
    try {
      _firestore.collection(userUid).doc('folders').update({
        folderField: FieldValue.arrayUnion([noteUid])
      });
    } on FirebaseException catch (e) {
      return e.message;
    }
    return null;
  }

  Future<String?> updateFolder(
      {required String folderField,
      required String noteUid,
      required String previousFolder}) async {
    try {
      //if the user is updating the folder, delete the note uid from the
      // previous folder and add the note uid to the new folder, otherwise don't change anything
      if (previousFolder != folderField) {
        await _firestore.collection(userUid).doc('folders').update({
          previousFolder: FieldValue.arrayRemove([noteUid])
        });

        await _firestore.collection(userUid).doc('folders').update({
          folderField: FieldValue.arrayUnion([noteUid])
        });
      }
    } on FirebaseException catch (e) {
      return e.message;
    }
    return null;
  }

  Future<String?> deleteDocFromFolder(
      {required String folderField, required String noteUid}) async {
    try {
      _firestore.collection(userUid).doc('folders').update({
        folderField: FieldValue.arrayRemove([noteUid])
      });
    } on FirebaseException catch (e) {
      return e.message;
    }
    return null;
  }

  Future<String?> clearFolders() async {
    //Go inside the 'folder' doc, and set all folders to []
    try {
      await _firestore
          .collection(userUid)
          .doc('folders')
          .get()
          .then((value) => value.data()?.forEach((key, value) {
                _firestore.collection(userUid).doc('folders').update({key: []});
              }));
    } on FirebaseException catch (e) {
      return e.message;
    }
    return null;
  }
}
