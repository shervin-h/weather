import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({this.color, this.size, Key? key}) : super(key: key);

  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.halfTriangleDot(
        color: color ?? Colors.white,
        size: size ?? 50,
      ),
    );
  }
}


