
import 'package:flutter/material.dart';
import 'package:rally/configs/style_config.dart';

class DatePickerButton extends StatelessWidget {
  const DatePickerButton({required this.onTap, required this.text, this.textColor, this.icon, super.key});

  final VoidCallback? onTap;
  final String text;
  final Color? textColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 24.0,
                  height: 48.0,
                  child: icon != null ? Icon(icon!, size: 18.0) : null,
                ),
                const SizedBox(width: 12.0),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                text,
                style: StyleConfigs.bodyNormal.copyWith(color: textColor ?? scheme.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
