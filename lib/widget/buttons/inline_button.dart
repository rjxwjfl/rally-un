import 'package:flutter/material.dart';

class InlineButton extends StatelessWidget {
  const InlineButton({required this.onTap, this.icon, required this.title, this.suffix, super.key});

  final void Function() onTap;
  final IconData? icon;
  final Widget title;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          children: [
            SizedBox(width: 24.0, height: 24.0, child: icon != null ? Icon(icon!, size: 18.0) : null),
            const SizedBox(width: 12.0),
            Expanded(child: title),
            if (suffix != null) suffix!
          ],
        ),
      ),
    );
  }
}
