import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color backgroundColor;
  final Color labelColor;
  final Widget child;
  final bool isRounded;
  final VoidCallback onTap;
  final bool isDisabled;
  const CustomButton(
      {super.key,
      this.isDisabled = false,
      required this.backgroundColor,
      required this.labelColor,
      required this.child,
      required this.isRounded,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isDisabled ? null : onTap,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
        foregroundColor: MaterialStateProperty.all<Color>(labelColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: isRounded
                    ? BorderRadius.circular(25)
                    : BorderRadius.circular(0))),
      ),
      child: child,
    );
  }
}
