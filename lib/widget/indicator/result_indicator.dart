import 'package:flutter/material.dart';
import 'package:rally/configs/style_config.dart';

class ResultIndicator extends StatelessWidget {
  const ResultIndicator({required this.icon, required this.text, super.key});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 72.0,
          color: Theme.of(context).colorScheme.outline.withOpacity(0.7),
        ),
        const SizedBox(height: 5.0),
        Text(
          text,
          style: StyleConfigs.bodyNormal.copyWith(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
