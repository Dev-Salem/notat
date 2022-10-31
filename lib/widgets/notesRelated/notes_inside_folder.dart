import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_again/resources/firestore_methods.dart';
import 'package:flutter_application_again/widgets/notesRelated/note_cards.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<dynamic> foldersBottomSheet(BuildContext context, String folder) {
  return showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(150))),
      context: context,
      builder: (BuildContext _) => InsideFolder(folder));
}

class InsideFolder extends StatefulWidget {
  final String folder;
  const InsideFolder(this.folder, {Key? key}) : super(key: key);

  @override
  State<InsideFolder> createState() => _InsideFolderState();
}

class _InsideFolderState extends State<InsideFolder> {
  late final folderProvider;

  @override
  void initState() {
    folderProvider = StreamProvider((ref) => FirebaseFirestore.instance
        .collection(FirestoreService().userUid)
        .where('folder', isEqualTo: widget.folder)
        .snapshots());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(45), topRight: Radius.circular(45))),
      alignment: Alignment.bottomCenter,
      child: Consumer(builder: (context, ref, child) {
        final streamProv = ref.watch(folderProvider);
        return Padding(
          padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
          child: NoteCards(streamProv),
        );
      }),
    );
  }
}
