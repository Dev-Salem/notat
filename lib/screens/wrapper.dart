import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_again/resources/auth_methods.dart';
import 'package:flutter_application_again/screens/authentication/introduction_screen.dart';
import 'package:flutter_application_again/screens/errorAndLoading/error_screen.dart';
import 'package:flutter_application_again/screens/functionalities/home_page.dart';
import 'package:flutter_application_again/screens/errorAndLoading/loading_screen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.userChanges(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              if (AuthService().isVerified) {
                return HomePage();
              } else if (snapshot.hasError) {
                return ErrorPage();
              }
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }
          return const IntroductionScreen();
        }));
  }
}
