import 'package:flutter/material.dart';

class NonGlowInkWell extends StatelessWidget {
  const NonGlowInkWell({this.onTap, required this.child, this.borderRadius, super.key});

  final VoidCallback? onTap;
  final Widget child;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashFactory: InkRipple.splashFactory,
      borderRadius: borderRadius,
      onTap: onTap,
      child: child,
    );
  }
}
