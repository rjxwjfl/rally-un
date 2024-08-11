import 'package:flutter/material.dart';

class BorderButton extends StatelessWidget {
  const BorderButton({required this.onTap, this.backgroundColor, this.borderColor, this.icon, required this.child, super.key});

  final void Function() onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final Widget? icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      child: Ink(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor ?? scheme.onSurface, width: 2.0),
          borderRadius: const BorderRadius.all(Radius.circular(8.0))
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: icon,
              ),
              child
            ],
          ),
        ),
      ),
    );
  }
}
