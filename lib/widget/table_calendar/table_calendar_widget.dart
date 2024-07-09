import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rally/configs/style_config.dart';
import 'package:rally/dto/schedule/schedule_resp_dto.dart';
import 'package:table_calendar/table_calendar.dart';

class TableCalendarWidget extends StatefulWidget {
  const TableCalendarWidget(
      {this.selectedDay,
      required this.focusedDay,
      this.data,
      this.selectedDayPredicate,
      this.onDaySelected,
      this.onPageChanged,
      this.onFormatChanged,
      required this.calendarFormat,
      super.key});

  final DateTime? selectedDay;
  final DateTime focusedDay;
  final Map<DateTime, List<ScheduleRespDto>>? data;
  final bool Function(DateTime)? selectedDayPredicate;
  final void Function(DateTime, DateTime)? onDaySelected;
  final void Function(DateTime)? onPageChanged;
  final void Function(CalendarFormat)? onFormatChanged;
  final CalendarFormat calendarFormat;

  @override
  State<TableCalendarWidget> createState() => _TableCalendarWidgetState();
}

class _TableCalendarWidgetState extends State<TableCalendarWidget> {

  List<ScheduleRespDto> _getEvents(DateTime date){
    DateTime day = DateTime(date.year, date.month, date.day);
    return widget.data?[day]?? [];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return TableCalendar(
      locale: 'ko_KR',
      daysOfWeekHeight: 25.0,
      rowHeight: 45.0,
      calendarFormat: widget.calendarFormat,
      focusedDay: widget.focusedDay,
      firstDay: DateTime(2020, 1, 1),
      lastDay: DateTime(2100, 12, 31),
      eventLoader: _getEvents,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: StyleConfigs.bodyNormal.copyWith(color: scheme.outline),
        weekendStyle: StyleConfigs.bodyNormal.copyWith(color: Colors.red.withOpacity(0.5)),
      ),
      headerVisible: false,
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
        tablePadding: const EdgeInsets.symmetric(vertical: 12.0),
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
        outsideTextStyle: StyleConfigs.bodyNormal.copyWith(color: scheme.outline.withOpacity(0.5)),
        outsideDecoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0))),
        disabledTextStyle: StyleConfigs.bodyNormal.copyWith(color: scheme.outline.withOpacity(0.5)),
        disabledDecoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (BuildContext context, DateTime date, List<ScheduleRespDto> events) {
          if (events.isEmpty) {
            return const SizedBox();
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // if (per.isNotEmpty)
                Container(
                  height: 5.0,
                  width: 5.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                ),
                // if (per.isNotEmpty && group.isNotEmpty) SizedBox(width: 2.0),
                // if (group.isNotEmpty)
                Container(
                  height: 5.0,
                  width: 5.0,
                  decoration: BoxDecoration(
                    color: scheme.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      selectedDayPredicate: widget.selectedDayPredicate,
      onDaySelected: widget.onDaySelected,
      onPageChanged: widget.onPageChanged,
      onFormatChanged: widget.onFormatChanged,
    );
  }
}
