import 'package:flutter/material.dart';
import 'package:flutter_application_again/providers/folders_provider.dart';
import 'package:flutter_application_again/screens/errorAndLoading/loading_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class FolderMenu extends ConsumerWidget {
  FolderMenu({
    Key? key,
    required this.selected,
  });

  ValueNotifier<String?> selected;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(folderProvider).when(
        data: ((data) {
          final snapshot = data.data();
          final keys = snapshot!.keys.toList();

          return TextButton(
              onPressed: () {
                showMenu(
                    context: context,
                    position: RelativeRect.fill,
                    items: List.generate(
                      keys.length,
                      (index) => PopupMenuItem(
                          onTap: () {
                            selected.value = keys[index];
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.folder,
                                color: Color.fromARGB(255, 216, 182, 57),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                  constraints: BoxConstraints(maxWidth: 150),
                                  child: Text(
                                    keys[index],
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                  )),
                            ],
                          )),
                    ));
              },
              child: ValueListenableBuilder(
                valueListenable: selected,
                builder: ((context, value, child) => Text(
                      'Folder: $value',
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.ubuntu(
                          fontSize: 14,
                          color: Colors.white30,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600),
                    )),
              ));
        }),
        error: ((error, stackTrace) => Text('Error')),
        loading: (() => LoadingScreen(
              size: 50,
            )));
  }
}
