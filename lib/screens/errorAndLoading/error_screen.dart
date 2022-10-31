import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            SizedBox(
              height: 150,
            ),
            Text(
              'Something went wrong',
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                  fontSize: 28, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 30,
            ),
            Icon(
              Icons.error_outline_outlined,
              color: Colors.white70,
              size: 120,
            )
          ],
        ),
      ),
    );
  }
}
