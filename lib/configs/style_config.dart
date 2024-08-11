import 'package:flutter/material.dart';
import 'package:rally/main.dart';

class StyleConfigs {
  StyleConfigs._();

  static TextStyle headLineBold = const TextStyle(fontSize: 36.0, fontWeight: FontWeight.w800);

  static TextStyle titleBold = const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w800);
  static TextStyle titleNormal = const TextStyle(fontSize: 22.0);

  static TextStyle subtitleNormal = const TextStyle(fontSize: 18.0);
  static TextStyle subtitleMed = const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600);
  static TextStyle subtitleBold = const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w800);

  static TextStyle leadNormal = const TextStyle(fontSize: 16.0);
  static TextStyle leadMed = const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600);
  static TextStyle leadBold = const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w800);
  static TextStyle leadBoldComplete = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w800,
    decoration: TextDecoration.lineThrough,
    decorationColor: Theme.of(navigatorKey.currentContext!).colorScheme.outline,
    decorationThickness: 1.0,
    color: Theme.of(navigatorKey.currentContext!).colorScheme.outline,
  );

  static TextStyle notificationBold = const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w800);

  static TextStyle bodyNormal = const TextStyle(fontSize: 14.0, height: 1.5);
  static TextStyle bodyBold = const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w800, height: 1.5);
  static TextStyle bodyMed = const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, height: 1.5);
  static TextStyle bodyBoldLS = const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w800, letterSpacing: 5.0, height: 1.5);

  static TextStyle captionNormal = const TextStyle(fontSize: 12.0);
  static TextStyle captionMed = const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600);
  static TextStyle captionBold = const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w800);

  static TextStyle categoryBoldLS = const TextStyle(fontSize: 10.0, fontWeight: FontWeight.w800, letterSpacing: 5.0);
  static TextStyle notificationBadge = const TextStyle(fontSize: 10.0, fontWeight: FontWeight.w600);

  static TextStyle extraSmall = const TextStyle(fontSize: 10.0);

  static Container menuTitleFocus({required Color color, required double height, double width = 4.0}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.all(Radius.circular(width * 0.5))),
    );
  }
}
