import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

class ScheduleMonthView extends StatelessWidget {
  const ScheduleMonthView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return MonthView(
      borderSize: 0.2,
      borderColor: scheme.outline,
      cellBuilder: (date, events, isToday, isMonth, isYear){
        return Container(
          child: Text('${date.day}'),
        );
      },
    );
  }
}
