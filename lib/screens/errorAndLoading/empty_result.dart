import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class EmptyResult extends StatelessWidget {
  const EmptyResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            const SizedBox(
              height: 100,
            ),
            Text(
              'Wow, such empty',
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(fontSize: 25),
            ),
            const SizedBox(
              height: 50,
            ),
            LottieBuilder.asset("assets/51382-astronaut-light-theme.json"),
            const SizedBox(
              height: 50,
            ),
            Text(
              'Try Adding Something Interesting',
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                  fontSize: 27, fontWeight: FontWeight.w400),
            )
          ],
        ),
      ),
    );
  }
}
