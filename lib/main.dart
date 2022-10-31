import 'dart:io';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_again/screens/authentication/login_screen.dart';
import 'package:flutter_application_again/screens/authentication/signup_screen.dart';
import 'package:flutter_application_again/screens/functionalities/home_page.dart';
import 'package:flutter_application_again/screens/wrapper.dart';
import 'package:flutter_application_again/utils/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/*
Notat /نوتات: a simple taking notes app which was 
developed by dev-Salem
created Date: 2022 - 18th Aug 
*/

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = (details) {
    //whenever there's an error, exit the app
    FlutterError.presentError(details);
    if (kReleaseMode) exit(1);
  };
  runApp(ProviderScope(
      child: DevicePreview(
          enabled: !kReleaseMode, builder: ((context) => MyApp()))));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      debugShowCheckedModeBanner: false,
      builder: DevicePreview.appBuilder,
      theme: CustomTheme.DarkTheme,
      home: const Wrapper(),
      routes: {
        'Login': (context) => const LoginScreen(),
        'Sign up': (context) => const SignUpScreen(),
        'Home page': (context) => const HomePage()
      },
    );
  }
}
