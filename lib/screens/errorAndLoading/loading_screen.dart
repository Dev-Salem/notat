import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingScreen extends StatelessWidget {
  final double size;
  const LoadingScreen({Key? key, this.size = 150}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: LoadingAnimationWidget.staggeredDotsWave(
              color: Theme.of(context).primaryColor, size: size),
        ),
      ),
    );
  }
}
