import 'package:flutter/material.dart';
import 'package:flutter_application_again/resources/auth_methods.dart';
import 'package:flutter_application_again/screens/authentication/introduction_screen.dart';
import 'package:flutter_application_again/utils/regex.dart';
import 'package:flutter_application_again/widgets/reusedComponents/animation_transition.dart';
import 'package:flutter_application_again/widgets/reusedComponents/input_text_field.dart';
import 'package:flutter_application_again/widgets/reusedComponents/snackbar.dart';

class deleteAccountDialog extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final _key = GlobalKey<FormState>();
  final auth = AuthService();
  deleteAccountDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Account'),
      content: SizedBox(
        height: 140,
        child: Column(
          children: [
            Text('Are you sure you want to permanently delete your account?'),
            SizedBox(
              height: 20,
            ),
            Form(
              key: _key,
              child: InputTextField(
                  autofocus: true,
                  hintText: 'Confirm Password',
                  isPassword: true,
                  validator: (val) {
                    if (val != null &&
                        val.isNotEmpty &&
                        passwordRegExp.hasMatch(val)) {
                      return null;
                    } else {
                      return 'Invalid password';
                    }
                  },
                  keyboardType: TextInputType.text,
                  toNextField: false,
                  controller: _controller),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
            )),
        TextButton(
            onPressed: () async {
              if (_key.currentState!.validate() == true) {
                await auth.reloadUser();
                await auth
                    .reauthentication(_controller.text)
                    .then((value) async {
                  if (value != null) {
                    CustomSnackBar.show(context, value, Duration(seconds: 3));
                  } else {
                    await auth.deleteAccount();
                    FadeTrans(translateTo: IntroductionScreen());
                  }
                  Navigator.pop(context);
                });
              }
            },
            child: Text(
              'Delete Account',
              style: TextStyle(color: Colors.red),
            )),
      ],
    );
  }
}
