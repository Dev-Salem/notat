import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_again/resources/auth_methods.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notesProvider = StreamProvider(((ref) => FirebaseFirestore.instance
    .collection(AuthService().useUid)
    .orderBy('date', descending: true)
    .snapshots()));
