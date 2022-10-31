import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final String? Function(String?) validator;
  final TextInputType keyboardType;
  final bool toNextField;
  final Widget? suffixIcon;
  final bool autofocus;
  final maxLength;
  final TextEditingController controller;
  const InputTextField(
      {super.key,
      this.suffixIcon,
      this.autofocus = false,
      this.maxLength = null,
      required this.hintText,
      required this.isPassword,
      required this.validator,
      required this.keyboardType,
      required this.toNextField,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      validator: validator,
      autofocus: autofocus,
      textInputAction:
          toNextField ? TextInputAction.next : TextInputAction.done,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
          suffixIcon: suffixIcon,
          errorMaxLines: 4,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
          hintText: hintText,
          filled: true,
          fillColor: const Color.fromARGB(28, 187, 187, 242),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(25)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).cardColor),
              borderRadius: BorderRadius.circular(25)),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(25))),
    );
  }
}
