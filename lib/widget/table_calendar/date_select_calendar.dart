import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rally/configs/style_config.dart';
import 'package:table_calendar/table_calendar.dart';

class DateSelectCalendar extends StatefulWidget {
  const DateSelectCalendar(
      {this.selectedDay,
        required this.focusedDay,
        this.selectedDayPredicate,
        this.onDaySelected,
        this.onPageChanged,
        super.key});

  final DateTime? selectedDay;
  final DateTime focusedDay;
  final bool Function(DateTime)? selectedDayPredicate;
  final void Function(DateTime, DateTime)? onDaySelected;
  final void Function(DateTime)? onPageChanged;

  @override
  State<DateSelectCalendar> createState() => _DateSelectCalendarState();
}

class _DateSelectCalendarState extends State<DateSelectCalendar> {

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return TableCalendar(
      locale: Platform.localeName,
      daysOfWeekHeight: 25.0,
      rowHeight: 45.0,
      calendarFormat: CalendarFormat.month,
      focusedDay: widget.focusedDay,
      firstDay: DateTime.now(),
      lastDay: DateTime(2100, 12, 31),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: StyleConfigs.bodyNormal.copyWith(color: scheme.outline),
        weekendStyle: StyleConfigs.bodyNormal.copyWith(color: Colors.red.withOpacity(0.5)),
      ),
      headerVisible: true,
      headerStyle: HeaderStyle(
        titleCentered: true,
        titleTextFormatter: (date, locale) => DateFormat.yMMMMd(locale).format(date),
        titleTextStyle: StyleConfigs.subtitleNormal,
        leftChevronPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        leftChevronMargin: EdgeInsets.zero,
        rightChevronPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        rightChevronMargin: EdgeInsets.zero,
        headerPadding: const EdgeInsets.symmetric(vertical: 4.0),
        formatButtonVisible: false,
      ),
      calendarStyle: CalendarStyle(
        tablePadding: const EdgeInsets.only(bottom: 12.0),
        cellMargin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
        markersAlignment: Alignment.bottomCenter,
        weekNumberTextStyle: StyleConfigs.bodyNormal,
        weekendTextStyle: StyleConfigs.bodyNormal.copyWith(color: Colors.redAccent),
        weekendDecoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0))),
        selectedTextStyle: StyleConfigs.leadBold.copyWith(color: scheme.onPrimaryContainer),
        selectedDecoration: BoxDecoration(
          color: scheme.primaryContainer,
          border: Border.all(color: scheme.onPrimaryContainer.withOpacity(0.2)),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
        todayTextStyle: StyleConfigs.leadBold.copyWith(color: scheme.secondary),
        todayDecoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(color: scheme.secondary.withOpacity(0.4), width: 1.0),
        ),
        defaultTextStyle: StyleConfigs.bodyNormal,
        defaultDecoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0))),
        withinRangeTextStyle: StyleConfigs.bodyNormal,
        withinRangeDecoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0))),
        outsideTextStyle: StyleConfigs.bodyNormal,
        outsideDecoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0))),
        disabledTextStyle: StyleConfigs.bodyNormal.copyWith(color: scheme.outline.withOpacity(0.2)),
        disabledDecoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      ),
      selectedDayPredicate: widget.selectedDayPredicate,
      onDaySelected: widget.onDaySelected,
      onPageChanged: widget.onPageChanged,
    );
  }
}
