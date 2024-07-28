import 'package:flutter/material.dart';
import 'package:rally/util/data_converter.dart';

class PriorityIndicator extends StatelessWidget {
  const PriorityIndicator({required this.priority, this.width, this.height, this.textGap, super.key});

  final int priority;
  final double? width;
  final double? height;
  final double? textGap;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(right: textGap?? 4.0),
      child: Container(
        width: width ?? 12.0,
        height: height ?? 12.0,
        decoration: BoxDecoration(
          color: priorityColorBuilder(priority: priority),
          borderRadius: const BorderRadius.all(Radius.circular(2.0)),
        ),
      ),
    );
  }
}
