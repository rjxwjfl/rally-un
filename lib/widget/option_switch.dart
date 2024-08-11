import 'package:flutter/material.dart';
import 'package:rally/configs/style_config.dart';

class OptionSwitch extends StatelessWidget {
  const OptionSwitch({required this.text, this.icon, required this.flag, required this.onChanged, this.padding, super.key});

  final String text;
  final IconData? icon;
  final bool flag;
  final void Function(bool)? onChanged;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: Row(
              children: [
                SizedBox(
                  width: 18.0,
                  child: icon != null ? Icon(icon, size: 18.0) : null,
                ),
                const SizedBox(width: 12.0),
                Text(
                  text,
                  style: StyleConfigs.bodyNormal,
                ),
              ],
            ),
          ),
        ),
        Switch(
          value: flag,
          activeColor: scheme.primary,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
