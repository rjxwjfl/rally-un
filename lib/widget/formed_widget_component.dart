import 'package:flutter/material.dart';

class FormedWidgetComponent extends StatelessWidget {
  const FormedWidgetComponent({required this.title, this.prefix, this.suffix, this.style, this.padding, super.key});

  final Widget title;
  final Widget? prefix;
  final Widget? suffix;
  final TextStyle? style;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: padding ?? const EdgeInsets.all(0.0),
      child: Row(
        children: [
          SizedBox(
            width: 24.0,
            height: 48.0,
            child: prefix,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: title
          ),
          SizedBox(child: suffix,)
        ],
      ),
    );
  }
}
