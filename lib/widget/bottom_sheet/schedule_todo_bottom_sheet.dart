import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:rally/model/todo_edit_model.dart';

class FormedBottomSheet {
  FormedBottomSheet._();

  static Future<void> defaultBottomSheet({required BuildContext context, required Widget Function(BuildContext) builder}) async {
    await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(4.0))),
      builder: builder,
    );
  }

  static Future<void> snappingBottomSheet({required BuildContext context, required Widget Function(BuildContext) builder}) async {
    await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(4.0))),
      builder: builder,
    );
  }

  static Future<TodoEditModel?> todoEditBottomSheet(
      {required BuildContext context, required Widget Function(BuildContext) builder}) async {
    return await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(4.0))),
      builder: builder,
    );
  }

  static Future<void> flexibleBottomSheet(
      {required BuildContext context, required Widget Function(BuildContext, ScrollController, double) builder}) async {
    await showFlexibleBottomSheet(
      context: context,
      minHeight: 0,
      initHeight: 0.5,
      maxHeight: 1,
      anchors: [0, 0.5, 1],
      isSafeArea: true,
      bottomSheetBorderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
      builder: builder,
    );
  }
}
