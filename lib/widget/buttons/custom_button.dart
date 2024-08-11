
import 'package:flutter/material.dart';
import 'package:rally/configs/style_config.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {this.onTap,
        this.margin,
        this.padding,
        this.border,
        this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
        this.splashColor,
        this.highlightColor,
        this.backgroundColor,
        this.textColor,
        required this.text,
        super.key});

  final void Function()? onTap;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Border? border;
  final BorderRadius? borderRadius;
  final Color? splashColor;
  final Color? highlightColor;
  final Color? backgroundColor;
  final Color? textColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: margin ?? const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: onTap,
        splashColor: splashColor ?? scheme.primary.withOpacity(0.2),
        highlightColor: highlightColor ?? scheme.primary.withOpacity(0.1),
        borderRadius: borderRadius,
        child: Ink(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: border,
            borderRadius: borderRadius,
          ),
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(text, style: StyleConfigs.bodyNormal.copyWith(color: textColor)),
          ),
        ),
      ),
    );
  }
}