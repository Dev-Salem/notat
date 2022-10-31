import 'package:flutter/material.dart';
import 'package:flutter_application_again/resources/auth_methods.dart';
import 'package:flutter_application_again/utils/regex.dart';
import 'package:flutter_application_again/widgets/reusedComponents/input_text_field.dart';
import 'package:flutter_application_again/widgets/reusedComponents/sign_button.dart';
import 'package:flutter_application_again/widgets/reusedComponents/snackbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

Future<dynamic> forgotPassBottomSheet(BuildContext context) {
  return showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(150))),
      context: context,
      builder: (BuildContext _) => const ForgotPassword());
}

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
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
      child: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            const SizedBox(
              height: 50,
            ),
            Text(
              'Rest Password',
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(fontSize: 30),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              //width: 300,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _key,
                child: InputTextField(
                    hintText: 'Enter your email',
                    isPassword: false,
                    validator: (val) {
                      if (val != null &&
                          val.isNotEmpty &&
                          emailRegExp.hasMatch(val)) {
                        return null;
                      }
                      return 'Invalid Email';
                    },
                    keyboardType: TextInputType.emailAddress,
                    toNextField: false,
                    controller: _controller),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            LottieBuilder.network(
              'https://assets8.lottiefiles.com/packages/lf20_dd9wpbrh.json',
              height: 300,
              errorBuilder: (context, error, stackTrace) => Container(
                child: Icon(
                  Icons.error_outline_outlined,
                  size: 250,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: 50,
                child: CustomButton(
                    backgroundColor: Theme.of(context).primaryColor,
                    labelColor: Colors.white,
                    child: const Text('Send Rest Email'),
                    isRounded: true,
                    onTap: () async {
                      if (_key.currentState!.validate() == true) {
                        await AuthService()
                            .restPassword(_controller.text)
                            .then((value) {
                          Navigator.of(context).pop();
                          CustomSnackBar.show(
                              context,
                              value == null
                                  ? 'Rest email sent successfully, check your inbox/spam!'
                                  : '$value',
                              Duration(seconds: 3));
                        });
                      }
                    }))
          ],
        ),
      ),
    );
  }
}
