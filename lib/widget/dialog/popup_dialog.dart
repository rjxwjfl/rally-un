import 'package:flutter/material.dart';
import 'package:rally/widget/dialog/model/dialog_item_model.dart';

class PopupDialog extends StatelessWidget {
  const PopupDialog({required this.items, super.key});

  final List<DialogItemModel> items;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(height: 2.5),
        itemBuilder: (context, index) => popupItem(model: items[index]),
      ),
    );
  }

  Widget popupItem({required DialogItemModel model}) {
    return InkWell(
      onTap: model.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Text(
          model.text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
