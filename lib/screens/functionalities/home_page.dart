import 'package:flutter/material.dart';
import 'package:flutter_application_again/resources/auth_methods.dart';
import 'package:flutter_application_again/resources/firestore_methods.dart';
import 'package:flutter_application_again/screens/authentication/introduction_screen.dart';
import 'package:flutter_application_again/screens/functionalities/create_note.dart';
import 'package:flutter_application_again/widgets/delete_account_dialog.dart';
import 'package:flutter_application_again/widgets/reusedComponents/animation_transition.dart';
import 'package:flutter_application_again/widgets/foldersRelated/folders._tab.dart';
import 'package:flutter_application_again/widgets/notesRelated/notes_tab.dart';
import 'package:flutter_application_again/widgets/reusedComponents/snackbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(right: 15, bottom: 15),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(FadeTrans(
                      translateTo: const CreateNote(),
                      duration: Duration(milliseconds: 800)));
                },
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(
                  Icons.add_outlined,
                  color: Colors.white,
                ),
              ),
            ),
            body: Column(children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 35, right: 20),
                    child: Text("Notat",
                        style: GoogleFonts.philosopher(fontSize: 30)),
                  ),
                  const Expanded(child: SizedBox()),
                  PopupMenuButton(
                    itemBuilder: ((context) => [
                          PopupMenuItem(
                            onTap: () async {
                              await FirestoreService().clearAllNotes();
                            },
                            value: 1,
                            child: const Text('Clear All notes'),
                          ),
                          PopupMenuItem(
                              onTap: () async {
                                await AuthService().reloadUser();
                                await AuthService().signOut().then((value) {
                                  if (value != null) {
                                    CustomSnackBar.show(
                                        context, value, Duration(seconds: 2));
                                  }
                                });
                                FadeTrans(translateTo: IntroductionScreen());
                              },
                              value: 2,
                              child: const Text('Sign out')),
                          PopupMenuItem(
                            onTap: () async {
                              Future.delayed(
                                  Duration(seconds: 0),
                                  (() => showDialog(
                                      context: context,
                                      builder: (dialogContext) {
                                        return deleteAccountDialog();
                                      })));
                            },
                            value: 3,
                            child: const Text(
                              'Delete Account',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15, left: 5),
                      child: Icon(
                        Icons.more_horiz_outlined,
                        color: Theme.of(context).hintColor.withOpacity(0.5),
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              TabBar(
                //isScrollable: true,
                //labelColor: Colors.white,

                unselectedLabelColor: Colors.white54,
                controller: _tabController,
                splashFactory: NoSplash.splashFactory,

                tabs: [
                  Tab(
                    child: Text(
                      'All',
                      style: GoogleFonts.roboto(
                          letterSpacing: 1,
                          fontSize: 17,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Tab(
                      child: Text('Folder',
                          style: GoogleFonts.roboto(
                              letterSpacing: 1,
                              fontSize: 17,
                              fontWeight: FontWeight.w500)))
                ],
                indicator: MaterialIndicator(
                    color: Theme.of(context).tabBarTheme.labelColor!,
                    topLeftRadius: 2,
                    topRightRadius: 2,
                    horizontalPadding: 75),
              ),
              const SizedBox(
                height: 25,
              ),
              Expanded(
                child: TabBarView(
                    controller: _tabController,
                    children: const [NotesTab(), FoldersTab()]),
              )
            ])));
  }
}
