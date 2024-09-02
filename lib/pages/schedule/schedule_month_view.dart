import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rally/configs/style_config.dart';

class ScheduleMonthView extends StatelessWidget {
  const ScheduleMonthView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return MonthView(
      borderSize: 0.2,
      borderColor: scheme.outline,
      headerStyle: HeaderStyle(
        headerTextStyle: StyleConfigs.titleBold,
        decoration: BoxDecoration(
          color: scheme.background,
        ),
      ),
      startDay: WeekDays.sunday,
      cellBuilder: (date, events, isToday, isMonth, isYear) {
        return Container(
          child: Text(
            '${date.day}',
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
