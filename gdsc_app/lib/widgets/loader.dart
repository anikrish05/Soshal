import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';

class LoaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
        child: LoadingAnimationWidget.fourRotatingDots(
        color: Color(0xFFFF8050),
        size: 50,
    ),
    ),
    );
  }
}
