import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  const CustomFilledButton(
      {required this.onTap, this.borderRadius, this.color, this.borderColor, this.padding, required this.child, super.key});

  final VoidCallback onTap;
  final BorderRadius? borderRadius;
  final Color? color;
  final Color? borderColor;
  final EdgeInsets? padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(8.0)),
        child: Ink(
          decoration: BoxDecoration(
            color: color ?? scheme.primaryContainer,
            border: Border.all(color: borderColor ?? Colors.transparent),
            borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
