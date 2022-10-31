import 'package:flutter_application_again/providers/note_provider.dart';

import 'package:flutter_application_again/widgets/notesRelated/note_cards.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotesTab extends StatefulWidget {
  const NotesTab({
    super.key,
  });

  @override
  State<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Scaffold(
          body: Consumer(builder: (context, ref, child) {
            final streamProv = ref.watch(notesProvider);
            return NoteCards(streamProv);
          }),
        ));
  }
}
