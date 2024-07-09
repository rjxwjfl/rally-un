import 'package:flutter/material.dart';
import 'package:rally/configs/style_config.dart';

class NotificationSnackBar {
  BuildContext context;

  NotificationSnackBar(this.context);

  void notification({required String text}) {
    var snackBar = SnackBar(
      elevation: 10.0,
      margin: EdgeInsets.zero,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      behavior: SnackBarBehavior.floating,
      content: Text(
        text,
        style: StyleConfigs.bodyMed.copyWith(color: Theme.of(context).colorScheme.onSecondary),
        textAlign: TextAlign.center,
      ),
      duration: const Duration(milliseconds: 1500),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return;
  }

  void alert({required String text}) {
    var snackBar = SnackBar(
      elevation: 10.0,
      margin: EdgeInsets.zero,
      backgroundColor: Theme.of(context).colorScheme.error,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      behavior: SnackBarBehavior.floating,
      content: Text(
        text,
        textAlign: TextAlign.center,
        style: StyleConfigs.bodyMed.copyWith(color: Theme.of(context).colorScheme.onError),
      ),
      duration: const Duration(milliseconds: 1500),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return;
  }
}
