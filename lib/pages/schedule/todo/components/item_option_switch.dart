
import 'package:flutter/material.dart';
import 'package:rally/configs/style_config.dart';

class ItemOptionSwitch extends StatelessWidget {
  const ItemOptionSwitch({required this.text, required this.flag, required this.onChanged, this.icon, super.key});

  final String text;
  final bool flag;
  final IconData? icon;
  final void Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        SizedBox(
          width: 24.0,
          height: 48.0,
          child: icon != null ? Icon(icon, size: 18.0) : null,
        ),
        const SizedBox(width: 12.0),
        Text(
          text,
          style: StyleConfigs.bodyNormal,
        ),
        const Expanded(child: SizedBox()),
        Switch(
          value: flag,
          activeColor: scheme.primary,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
