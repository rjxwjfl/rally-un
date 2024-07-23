import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AnimatedProgressIndicator extends StatelessWidget {
  const AnimatedProgressIndicator({this.size = 60.0, this.padding = kToolbarHeight, super.key});

  final double size;
  final double padding;

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: padding),
        child: LoadingAnimationWidget.staggeredDotsWave(color: scheme.primary, size: size),
      ),
    );
  }
}
