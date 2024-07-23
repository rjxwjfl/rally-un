import 'package:flutter/material.dart';

Future<void> scheduleTodoBottomSheet({required BuildContext context, required Widget child}) async{
  await showModalBottomSheet(
    useSafeArea: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(8.0))),
    context: context,
    builder: (context) => child,
  );
}
