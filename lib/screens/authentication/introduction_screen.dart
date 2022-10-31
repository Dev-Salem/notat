import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_again/screens/authentication/login_screen.dart';
import 'package:flutter_application_again/screens/authentication/signup_screen.dart';
import 'package:flutter_application_again/widgets/reusedComponents/animation_transition.dart';
import 'package:flutter_application_again/widgets/reusedComponents/sign_button.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        Image.asset(
          'assets/pexels-irina-iriser-1381679.jpg',
          height: double.maxFinite,
          width: double.maxFinite,
          fit: BoxFit.cover,
        ),
        Column(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 40, top: 40),
              child: Text(
                "Notat",
                style: GoogleFonts.philosopher(fontSize: 55),
              ),
            ),
            Container(
                height: 300,
                width: 430,
                padding: const EdgeInsets.only(top: 100, left: 25, right: 25),
                child: AnimatedTextKit(
                    pause: const Duration(seconds: 2),
                    repeatForever: true,
                    animatedTexts: [
                      TyperAnimatedText('The best way to take your notes',
                          speed: const Duration(milliseconds: 100),
                          textStyle: GoogleFonts.philosopher(
                              fontSize: 50,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold))
                    ])),
            Expanded(child: SizedBox()),
            SizedBox(
              width: 330,
              height: 47,
              child: CustomButton(
                onTap: () {
                  Navigator.of(context)
                      .push(FadeTrans(translateTo: const SignUpScreen()));
                },
                backgroundColor: const Color.fromARGB(228, 255, 255, 255),
                labelColor: Theme.of(context).primaryColor,
                isRounded: true,
                child: const Text("Sign up"),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                width: 330,
                height: 47,
                child: CustomButton(
                  onTap: () {
                    Navigator.of(context)
                        .push(FadeTrans(translateTo: const LoginScreen()));
                  },
                  backgroundColor: Theme.of(context).primaryColor,
                  labelColor: Colors.white,
                  isRounded: true,
                  child: const Text("Login"),
                )),
            SizedBox(
              height: size.height * 0.1,
            )
          ],
        ),
      ],
    ));
  }
}
