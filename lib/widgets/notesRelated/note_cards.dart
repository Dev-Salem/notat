import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_application_again/resources/firestore_methods.dart';
import 'package:flutter_application_again/screens/errorAndLoading/error_screen.dart';
import 'package:flutter_application_again/screens/functionalities/edit_note.dart';
import 'package:flutter_application_again/screens/errorAndLoading/empty_result.dart';
import 'package:flutter_application_again/screens/errorAndLoading/loading_screen.dart';
import 'package:flutter_application_again/widgets/reusedComponents/animation_transition.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';

class NoteCards extends StatefulWidget {
  final AsyncValue<QuerySnapshot<Map<String, dynamic>>> snapshot;
  NoteCards(this.snapshot);

  @override
  State<NoteCards> createState() => _NoteCardsState();
}

class _NoteCardsState extends State<NoteCards> {
  @override
  Widget build(BuildContext context) {
    return widget.snapshot.when(
        data: ((snapshot) {
          if (snapshot.docs.length == 0) {
            return EmptyResult();
          }
          return MasonryGridView.builder(
              physics: const BouncingScrollPhysics(),
              mainAxisSpacing: 15,
              crossAxisSpacing: 10,
              itemCount: snapshot.docs.length,
              gridDelegate:
                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
              itemBuilder: ((gridViewContegyxt, index) {
                var myData = snapshot.docs[index];
                var json = jsonDecode(myData['document']);
                final controller = quill.QuillController(
                    document: quill.Document.fromJson(json),
                    selection: const TextSelection.collapsed(offset: 0));
                return FocusedMenuHolder(
                  menuWidth: 200,
                  menuOffset: 10,
                  bottomOffsetHeight: 0,
                  menuBoxDecoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor),
                  animateMenuItems: false,
                  blurBackgroundColor:
                      Theme.of(context).scaffoldBackgroundColor,
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(FadeTrans(
                        translateTo: EditNote(noteUid: myData['uid'])));
                  },
                  menuItems: [
                    FocusedMenuItem(
                        trailingIcon: const Icon(
                          Icons.edit,
                          color: Color.fromARGB(178, 255, 255, 255),
                        ),
                        title: const Text('Edit'),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).push(
                              FadeTrans(
                                  translateTo:
                                      EditNote(noteUid: myData['uid'])));
                        },
                        backgroundColor: const Color.fromARGB(255, 57, 55, 78)),
                    FocusedMenuItem(
                        trailingIcon: const Icon(
                          Icons.delete_forever_outlined,
                          color: Colors.white,
                        ),
                        title: const Text('Delete'),
                        onPressed: () async {
                          await FirestoreService().deleteNote(
                              uid: myData['uid'], folder: myData['folder']);
                        },
                        backgroundColor: Colors.redAccent)
                  ],
                  child: Builder(builder: (context) {
                    return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 22,
                        ),
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(25)),
                        child: Column(
                          children: [
                            AutoSizeText(
                              myData['title'],
                              //softWrap: true,
                              minFontSize: 16,
                              maxLines: 4,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.roboto(
                                  fontSize: 10, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            ShaderMask(
                              shaderCallback: ((bounds) {
                                return const LinearGradient(
                                    begin: Alignment.center,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color.fromARGB(189, 218, 218, 252),
                                      Color.fromARGB(189, 218, 218, 252),
                                      Colors.transparent
                                    ]).createShader(bounds);
                              }),
                              child: quill.QuillEditor(
                                padding: const EdgeInsets.only(bottom: 10),
                                autoFocus: true,
                                enableInteractiveSelection: false,
                                readOnly: true,
                                showCursor: false,
                                scrollPhysics:
                                    const NeverScrollableScrollPhysics(),
                                scrollable: true,
                                expands: false,
                                maxHeight: 150,
                                scrollController:
                                    ScrollController(keepScrollOffset: false),
                                controller: controller,
                                focusNode: FocusNode(),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                    Jiffy(DateTime.parse(
                                            myData['date'].toDate().toString()))
                                        .MMMd
                                        .toString(),
                                    style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      color: const Color.fromARGB(
                                          90, 255, 255, 255),
                                    )),
                                const Expanded(child: SizedBox()),
                                SizedBox(
                                  width: 85,
                                  child: Text(myData['folder'],
                                      textAlign: TextAlign.end,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        color: const Color.fromARGB(
                                            90, 255, 255, 255),
                                      )),
                                )
                              ],
                            )
                          ],
                        ));
                  }),
                );
              }));
        }),
        error: ((error, stackTrace) => ErrorPage()),
        loading: (() => const LoadingScreen()));
  }
}
