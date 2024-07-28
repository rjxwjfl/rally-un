import 'package:flutter/material.dart';
import 'package:rally/configs/style_config.dart';

class LeadWidgetTextBox extends StatelessWidget {
  const LeadWidgetTextBox({required this.text, this.widget, this.style, this.padding, super.key});

  final String text;
  final Widget? widget;
  final TextStyle? style;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: padding ?? const EdgeInsets.all(0.0),
      child: Row(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 24.0, maxHeight: 24.0),
            child: SizedBox(width: 24.0, height: 24.0,child: widget),
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
