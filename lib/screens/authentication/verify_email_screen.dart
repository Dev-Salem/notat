import 'dart:async';
import 'package:custom_timer/custom_timer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_again/resources/auth_methods.dart';
import 'package:flutter_application_again/screens/functionalities/home_page.dart';
import 'package:flutter_application_again/widgets/reusedComponents/animation_transition.dart';
import 'package:flutter_application_again/widgets/reusedComponents/sign_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

Future<dynamic> CustomBottomSheet(BuildContext context) {
  return showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(150))),
      context: context,
      builder: (BuildContext _) => const VerifyEmail());
}

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  late CustomTimerController _controller;
  bool isDismised = true;
  late Timer timer;

  void changeButtonState() {
    setState(() {
      isDismised = !isDismised;
    });
  }

  checkVerification() async {
    await FirebaseAuth.instance.currentUser?.reload();
    final user = FirebaseAuth.instance.currentUser;
    if (user?.emailVerified ?? false) {
      Navigator.of(context, rootNavigator: true)
          .pushReplacementNamed('Home page')
          .then((value) {
        disposeScreen();
      });
    }
  }

  sendEmailVerification() async {
    if (AuthService().isVerified) {
      Navigator.of(context)
          .pushReplacement(FadeTrans(translateTo: const HomePage()))
          .then((value) {
        disposeScreen();
      });
    } else {
      FirebaseAuth.instance.currentUser!.sendEmailVerification();
    }
  }

  void disposeScreen() {
    if (!mounted) {
      print('disposed ---------');
      @override
      void dispose() {
        _controller.dispose();
        timer.cancel();
        super.dispose();
      }
    }
  }

  @override
  void initState() {
    _controller = CustomTimerController();
    sendEmailVerification();
    _controller.start();
    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      checkVerification();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(45), topRight: Radius.circular(45))),
      alignment: Alignment.bottomCenter,
      child: Center(
        child: ListView(
          children: [
            const SizedBox(
              height: 50,
            ),
            Text(
              "Verify Email",
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                  fontSize: 35, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            LottieBuilder.network(
              'https://assets8.lottiefiles.com/packages/lf20_dd9wpbrh.json',
              height: 300,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.error_outline_outlined),
            ),
            Text(
              "We've sent you a verification email, Check your inbox/spam!",
              style: GoogleFonts.quicksand(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              height: 40,
              width: 200,
              child: CustomButton(
                backgroundColor: isDismised
                    ? Colors.white12
                    : Theme.of(context).primaryColor,
                labelColor: Colors.white,
                isRounded: true,
                isDisabled: isDismised,
                onTap: () async {
                  changeButtonState();
                  sendEmailVerification();
                  _controller.reset();
                  _controller.start();
                },
                child: const Text("Resend Email"),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 20),
              child: CustomTimer(
                controller: _controller,
                begin: const Duration(minutes: 2),
                end: const Duration(),
                builder: (time) {
                  return Text(
                    '${time.minutes}:${time.seconds}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  );
                },
                onChangeState: (state) {
                  if (state == CustomTimerState.finished) {
                    changeButtonState();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
