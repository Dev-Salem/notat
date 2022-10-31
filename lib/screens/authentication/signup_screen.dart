// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_application_again/widgets/reusedComponents/snackbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_application_again/resources/auth_methods.dart';
import 'package:flutter_application_again/utils/regex.dart';
import 'package:flutter_application_again/widgets/reusedComponents/input_text_field.dart';
import 'package:flutter_application_again/widgets/reusedComponents/sign_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: SizedBox(
          child: SingleChildScrollView(
              //physics: const BouncingScrollPhysics(),
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
            top: height * 0.07,
            left: width * 0.28,
            child: Text(
              "Register",
              style: GoogleFonts.quicksand(
                  fontSize: 45, fontWeight: FontWeight.w500),
            ),
          ),
          Positioned(
            top: height * 0.14,
            left: width * 0.2,
            child: Text(
              "Create your new account",
              style: GoogleFonts.quicksand(fontSize: 20),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: height * 0.25),
            height: height * 0.80,
            width: width,
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius:
                    const BorderRadius.only(topLeft: Radius.circular(100))),
            child: const SignUpDetails(),
          ),
        ],
      ))),
    );
  }
}

class SignUpDetails extends StatefulWidget {
  const SignUpDetails({Key? key}) : super(key: key);

  @override
  State<SignUpDetails> createState() => _SignUpDetailsState();
}

class _SignUpDetailsState extends State<SignUpDetails> {
  final _key = GlobalKey<FormState>();
  bool isWaiting = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  void changeIsWaiting() {
    setState(() {
      isWaiting = !isWaiting;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Form(
        key: _key,
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 50, right: 45, left: 45),
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
                  margin: const EdgeInsets.only(top: 30, right: 45, left: 45),
                  child: InputTextField(
                    controller: passwordController,
                    toNextField: true,
                    keyboardType: TextInputType.text,
                    hintText: 'Password',
                    isPassword: true,
                    validator: (text) {
                      if (passwordRegExp.hasMatch(text!)) {
                        return null;
                      }
                      return 'Weak password, try add a special character/letter/number';
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30, right: 45, left: 45),
                  child: InputTextField(
                    controller: confirmPassController,
                    toNextField: false,
                    keyboardType: TextInputType.text,
                    hintText: 'Confirm Password',
                    isPassword: true,
                    validator: (text) {
                      if (passwordRegExp.hasMatch(text!) &&
                          passwordController.text ==
                              confirmPassController.text) {
                        return null;
                      } else if (passwordController.text !=
                          confirmPassController.text) {
                        return "Password Confirmation isn't correct";
                      }

                      return 'Weak password, try add a special character/letter/number';
                    },
                  ),
                ),
                SizedBox(height: 120),
                Container(
                  height: 38,
                  width: 320,
                  child: CustomButton(
                    isDisabled: isWaiting,
                    backgroundColor: Theme.of(context).primaryColor,
                    labelColor: Colors.white,
                    onTap: () async {
                      if (_key.currentState!.validate() == true) {
                        changeIsWaiting();
                        final String auth = await AuthService().createUser(
                            email: emailController.text,
                            password: passwordController.text);
                        changeIsWaiting();
                        CustomSnackBar.show(
                            context, auth, const Duration(seconds: 3));

                        Navigator.of(context).pop();
                      }
                    },
                    isRounded: true,
                    child: isWaiting
                        ? LoadingAnimationWidget.staggeredDotsWave(
                            color: Colors.white, size: 20)
                        : const Text("Sign up"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 100),
                  child: Row(
                    children: [
                      Text(
                        "Already have an account?",
                        style: GoogleFonts.roboto(
                            color: const Color.fromARGB(255, 187, 187, 242)),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('Login');
                          },
                          child: Text(
                            "Login",
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(178, 124, 77, 255)),
                          ))
                    ],
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
