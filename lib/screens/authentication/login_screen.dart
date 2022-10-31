import 'package:flutter/material.dart';
import 'package:flutter_application_again/resources/auth_methods.dart';
import 'package:flutter_application_again/resources/internet_connection.dart';
import 'package:flutter_application_again/screens/authentication/forgot_password.dart';
import 'package:flutter_application_again/screens/functionalities/home_page.dart';
import 'package:flutter_application_again/screens/authentication/verify_email_screen.dart';
import 'package:flutter_application_again/utils/regex.dart';
import 'package:flutter_application_again/widgets/reusedComponents/animation_transition.dart';
import 'package:flutter_application_again/widgets/reusedComponents/input_text_field.dart';
import 'package:flutter_application_again/widgets/reusedComponents/sign_button.dart';
import 'package:flutter_application_again/widgets/reusedComponents/snackbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: SizedBox(
          child: SingleChildScrollView(
              //physics: const NeverScrollableScrollPhysics(),
              child: Stack(
        children: [
          Positioned(
            child: Opacity(
              opacity: 0.8,
              child: Image.asset(
                'assets/pexels-irina-iriser-1381679.jpg',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            top: height * 0.13,
            left: width * 0.35,
            child: Text(
              "Notat",
              style: GoogleFonts.philosopher(fontSize: 55),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: height * 0.3),
            height: height * 0.75,
            width: width,
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius:
                    const BorderRadius.only(topLeft: Radius.circular(100))),
            child: const LoginDetails(),
          )
        ],
      ))),
    );
  }
}

class LoginDetails extends StatefulWidget {
  const LoginDetails({super.key});

  @override
  State<LoginDetails> createState() => _LoginDetailsState();
}

class _LoginDetailsState extends State<LoginDetails> {
  final _key = GlobalKey<FormState>();
  bool isWaiting = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
//------------------------------------------------------------------------
  loginProcess() async {
    if (_key.currentState!.validate() == true) {
      changeIsWaiting();
      final String? auth = await AuthService().loginUser(
          email: emailController.text, password: passwordController.text);

      if (auth == null) {
        //check if login is successful

        if (AuthService().isVerified) {
          //Check if the user is Verified
          Navigator.of(context)
              .pushReplacement(FadeTrans(translateTo: const HomePage()));
        } else {
          CustomBottomSheet(context);
        }
      } else {
        changeIsWaiting();
        CustomSnackBar.show(context, auth, const Duration(seconds: 5));
      }
    }
  }

//----------------------------------------------------------------
  void changeIsWaiting() {
    setState(() {
      isWaiting = !isWaiting;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

//-------------------------
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: size.width * 0.1,
        ),
        Text("Welcome back",
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
                fontSize: 35, color: const Color.fromARGB(255, 187, 187, 242))),
        const SizedBox(
          height: 5,
        ),
        Text(
          'Login to your account',
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(fontSize: 13, color: Colors.white54),
        ),
        Form(
            key: _key,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 60, right: 45, left: 45),
                  child: InputTextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Email',
                    isPassword: false,
                    toNextField: true,
                    validator: (text) {
                      if (emailRegExp.hasMatch(text!)) {
                        return null;
                      }
                      return 'Invalid Email';
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, right: 45, left: 45),
                  child: InputTextField(
                    controller: passwordController,
                    toNextField: false,
                    keyboardType: TextInputType.text,
                    hintText: 'Password',
                    isPassword: true,
                    validator: (text) {
                      if (passwordRegExp.hasMatch(text!)) {
                        return null;
                      }

                      return 'Weak password, try adding a number, a letter or a special character';
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 170),
                    child: TextButton(
                        onPressed: () async {
                          final internet = await Connection.checkInternet();
                          if (internet) {
                            forgotPassBottomSheet(context);
                          } else {
                            CustomSnackBar.show(context,
                                'No internet connection', Duration(seconds: 3));
                          }
                        },
                        child: Text(
                          "Forgot password?",
                          style: GoogleFonts.roboto(
                              color: const Color.fromARGB(255, 187, 187, 242)),
                        ))),
                SizedBox(
                  height: size.height * 0.1,
                ),
                Container(
                  //margin: const EdgeInsets.only(top: 90),
                  height: 38,
                  width: 320,
                  child: CustomButton(
                    backgroundColor: Theme.of(context).primaryColor,
                    labelColor: Colors.white,
                    onTap: () async {
                      loginProcess();
                    },
                    isDisabled: isWaiting,
                    isRounded: true,
                    child: isWaiting
                        ? LoadingAnimationWidget.staggeredDotsWave(
                            size: 20, color: Colors.white)
                        : const Text("Login"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 100),
                  child: Row(
                    children: [
                      Text(
                        "Don't have an account?",
                        style: GoogleFonts.roboto(
                            color: const Color.fromARGB(255, 187, 187, 242)),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed('Sign up');
                          },
                          child: Text(
                            "Sign up",
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(178, 124, 77, 255)),
                          )),
                    ],
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
