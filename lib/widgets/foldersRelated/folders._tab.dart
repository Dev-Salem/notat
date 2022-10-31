import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_again/providers/folders_provider.dart';
import 'package:flutter_application_again/resources/firstore_folder_methods.dart';
import 'package:flutter_application_again/screens/errorAndLoading/error_screen.dart';
import 'package:flutter_application_again/screens/errorAndLoading/loading_screen.dart';
import 'package:flutter_application_again/widgets/foldersRelated/folder_dialog.dart';
import 'package:flutter_application_again/widgets/notesRelated/notes_inside_folder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';

class FoldersTab extends StatefulWidget {
  const FoldersTab({super.key});

  @override
  State<FoldersTab> createState() => _FoldersTabState();
}

class _FoldersTabState extends State<FoldersTab> {
  final TextEditingController folderController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    folderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Scaffold(
        body: Consumer(builder: ((context, ref, child) {
          final streamProv = ref.watch(folderProvider);
          return streamProv.when(
              data: ((snapshot) {
                if (snapshot.data() == null) {
                  exit(0);
                }
                final data = snapshot.data()!;
                final keys = data.keys.toList();
                return GridView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: keys.length + 1,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            crossAxisCount: 2),
                    itemBuilder: ((context, index) {
                      if (index == keys.length) {
                        //the last item is the add button
                        return GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: ((context) => FolderDialog(
                                    formKey: formKey,
                                    folderController: folderController,
                                    keys: keys)));
                          },
                          child: Container(
                            height: 100,
                            width: 80,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(
                              top: 5,
                            ),
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(25)),
                            child: LayoutBuilder(builder: (context, size) {
                              return Column(
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Theme.of(context).primaryColor,
                                    size: size.maxHeight - 40,
                                  ),
                                  const Text('Add')
                                ],
                              );
                            }),
                          ),
                        );
                      }
                      return FocusedMenuHolder(
                        duration: const Duration(milliseconds: 100),
                        menuWidth: 250,
                        menuBoxDecoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor),
                        animateMenuItems: false,
                        blurBackgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        onPressed: () {
                          foldersBottomSheet(context, keys[index]);
                        },
                        menuItems: keys[index] == 'All'
                            ? [] //user can't delete the 'All' folder
                            : [
                                FocusedMenuItem(
                                    trailingIcon: const Icon(
                                      Icons.delete_forever_outlined,
                                      color: Colors.white,
                                    ),
                                    title:
                                        const Text('Delete (All notes inside)'),
                                    onPressed: () async {
                                      await FirestoreFolderService()
                                          .deleteFolder(keys[index]);
                                    },
                                    backgroundColor: Colors.redAccent)
                              ],
                        child: Container(
                          height: 100,
                          width: 80,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(
                            top: 5,
                          ),
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(25)),
                          child: LayoutBuilder(builder: (context, size) {
                            return Column(
                              children: [
                                Icon(Icons.folder,
                                    color: Color.fromARGB(255, 216, 182, 57),
                                    size: size.maxHeight - 40),
                                SizedBox(
                                    width: 100,
                                    child: Text(
                                      keys[index],
                                      textAlign: TextAlign.center,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ))
                              ],
                            );
                          }),
                        ),
                      );
                    }));
              }),
              error: ((error, stackTrace) => ErrorPage()),
              loading: () => const LoadingScreen());
        })),
      ),
    );
  }
}
