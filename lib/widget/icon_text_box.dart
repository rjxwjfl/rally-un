import 'package:flutter/material.dart';
import 'package:rally/configs/style_config.dart';

class IconTextBox extends StatelessWidget {
  const IconTextBox({required this.text, this.icon, this.style, this.padding, super.key});

  final String text;
  final IconData? icon;
  final TextStyle? style;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0.0),
      child: Row(
        children: [
          SizedBox(
            width: 24.0,
            height: 48.0,
            child: icon != null ? Icon(icon, size: 18.0) : null,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              text,
              style: style ?? StyleConfigs.bodyNormal,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
