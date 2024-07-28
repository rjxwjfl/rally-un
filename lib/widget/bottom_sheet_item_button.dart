import 'package:flutter/material.dart';
import 'package:rally/configs/style_config.dart';

class BottomSheetItemButton extends StatelessWidget {
  const BottomSheetItemButton({required this.onTap, required this.icon, required this.text, super.key});

  final void Function() onTap;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: scheme.tertiaryContainer,
          borderRadius: BorderRadius.all(Radius.circular(4.0))
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: scheme.onTertiaryContainer, size: 18.0),
              const SizedBox(width: 8.0),
              Text(text, style: StyleConfigs.captionNormal.copyWith(color: scheme.onTertiaryContainer),)
            ],
          ),
        ),
      ),
    );
  }
}
