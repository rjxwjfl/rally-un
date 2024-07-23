import 'package:flutter/material.dart';

class DragHandle extends StatelessWidget {
  const DragHandle({this.padding, super.key});

  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        height: 4.0,
        width: 52.0,
        decoration: BoxDecoration(
          color: scheme.outline,
          borderRadius: const BorderRadius.all(
            Radius.circular(2.0),
          ),
        ),
      ),
    );
  }
}
