import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_again/models/note.dart';
import 'package:flutter_application_again/resources/auth_methods.dart';
import 'package:flutter_application_again/resources/firstore_folder_methods.dart';
import 'package:flutter_application_again/resources/internet_connection.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firestoreFolder = FirestoreFolderService();
  final userUid = AuthService().useUid;

  Future<String?> addDocument(
      {required String document,
      required String title,
      required String searchableDocument,
      String folder = 'All',
      required DateTime date}) async {
    final String uid = const Uuid().v4();
    final internet = await Connection.checkInternet();
    final Note note = Note(
        folder: folder,
        document: document,
        searchableDocument:
            searchableDocument.toLowerCase().replaceAll('\\n', ' '),
        date: date,
        uid: uid,
        title: title.isNotEmpty ? title : 'untitled');

    try {
      if (!internet) {
        return 'No internet connection';
      }
      await _firestore.collection(userUid).doc(uid).set(note.toJson());
      await firestoreFolder.addDocToFolder(folderField: folder, noteUid: uid);
    } on FirebaseException catch (e) {
      return e.message!;
    }
    return null;
  }

  Future<String?> updateDocument(
      {required String document,
      required String searchableDocument,
      required String title,
      required String previousFolder,
      required folder,
      required String noteUid,
      required DateTime date}) async {
    final internet = await Connection.checkInternet();
    final Note note = Note(
        folder: folder,
        searchableDocument:
            searchableDocument.toLowerCase().replaceAll('\\n', ' '),
        document: document,
        date: date,
        uid: noteUid,
        title: title.isNotEmpty ? title : 'untitled');

    try {
      if (!internet) {
        return 'No internet connection';
      }
      await _firestore.collection(userUid).doc(noteUid).set(note.toJson());
      await firestoreFolder.updateFolder(
          folderField: folder,
          noteUid: noteUid,
          previousFolder: previousFolder);
    } on FirebaseException catch (e) {
      return e.message!;
    }

    return null;
  }

  getNote({required String uid}) async {
    final snapshot = await _firestore.collection(userUid).doc(uid).get();
    return snapshot.data();
  }

  clearAllNotes() async {
    final folder = _firestore.collection(userUid).doc('folders');

    try {
      await _firestore.collection(userUid).get().then((value) {
        //Delete all docs except the folder doc
        for (DocumentSnapshot ds in value.docs) {
          if (ds.reference != folder) {
            ds.reference.delete();
          }
        }
      });
      await firestoreFolder.clearFolders();
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Future<String?> deleteDocsOfFolder(String folder) async {
    var data =
        _firestore.collection(userUid).where('folder', isEqualTo: folder);
    try {
      data.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          element.reference.delete();
        });
      });
    } on FirebaseException catch (e) {
      return e.message;
    }
    return null;
  }

  Future<String?> deleteNote(
      {required String uid, required String folder}) async {
    try {
      await _firestore.collection(userUid).doc(uid).delete();
      await firestoreFolder.deleteDocFromFolder(
          folderField: folder, noteUid: uid);
    } on FirebaseException catch (e) {
      return e.message;
    }
    return null;
  }

  Future<String?> deleteAllDocs(String uid) async {
    try {
      await _firestore.collection(userUid).get().then((value) {
        for (DocumentSnapshot ds in value.docs) {
          ds.reference.delete();
        }
      });
    } on FirebaseException catch (e) {
      return e.message;
    }
    return null;
  }
}
