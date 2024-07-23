
import 'package:flutter/material.dart';
import 'package:rally/configs/style_config.dart';

class ItemOptionButton extends StatelessWidget {
  const ItemOptionButton({this.onTap, this.icon, required this.titleText, this.contentText, this.contentWidget, super.key});

  final VoidCallback? onTap;
  final IconData? icon;
  final String titleText;
  final String? contentText;
  final Widget? contentWidget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 24.0,
          height: 48.0,
          child: icon != null ? Icon(icon, size: 18.0) : null,
        ),
        const SizedBox(width: 12.0),
        Text(
          titleText,
          style: StyleConfigs.bodyNormal,
        ),
        const Expanded(child: SizedBox()),
        if (contentText != null)
          InkWell(
            onTap: onTap,
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                contentText!,
                style: StyleConfigs.bodyNormal.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ),
        if (contentWidget != null) contentWidget!,
      ],
    );
  }
}
