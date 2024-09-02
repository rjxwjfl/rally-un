import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:rally/configs/style_config.dart';
import 'package:rally/main.dart';
import 'package:rally/util/datetime_convert.dart';

Widget timeIndicator({required DateTime start, required DateTime end, Color? color}) {
  DateTime now = DateTime.now();
  TextStyle timeStyle = StyleConfigs.captionNormal;
  if (start.withoutTime == end.withoutTime || start.add(const Duration(days: 1)) == end) {
    if (start.isDayStart && start.isDayStart) {
      return Text('종일', style: timeStyle.copyWith(color: color));
    } else if (start.isDayStart) {
      return Text(todoTimeFormat(start), style: timeStyle.copyWith(color: color));
    } else {
      return Row(
        children: [
          Text(todoTimeFormat(start), style: timeStyle.copyWith(color: color)),
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Icon(Icons.keyboard_arrow_right_rounded, size: 12.0, color: color),
          ),
          Text(todoTimeFormat(end), style: timeStyle.copyWith(color: color)),
        ],
      );
    }
  } else {
    return Row(
      children: [
        Text(todoTimeFormat(start), style: timeStyle.copyWith(color: color)),
         Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Icon(Icons.keyboard_arrow_right_rounded, size: 12.0, color: color),
        ),
        Text(todoTimeFormat(end), style: timeStyle.copyWith(color: color)),
      ],
    );
  }
}
