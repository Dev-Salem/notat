import 'package:flutter/material.dart';

class FadeTrans extends PageRouteBuilder {
  final Widget translateTo;
  final Duration duration;
  FadeTrans(
      {required this.translateTo,
      this.duration = const Duration(milliseconds: 1000)})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => translateTo,
          transitionDuration: duration,
          reverseTransitionDuration: const Duration(milliseconds: 750),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            animation = CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            );
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}

class ScaleTrans extends PageRouteBuilder {
  final Widget translateTo;
  ScaleTrans({required this.translateTo})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => translateTo,
          transitionDuration: const Duration(milliseconds: 1000),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            animation = CurvedAnimation(
              parent: animation,
              curve: Curves.fastLinearToSlowEaseIn,
            );
            return ScaleTransition(
              scale: animation,
              alignment: Alignment.center,
              child: child,
            );
          },
        );
}
