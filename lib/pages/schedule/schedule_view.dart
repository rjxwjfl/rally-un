import 'package:flutter/material.dart';
import 'package:rally/model/schedule/schedule_model.dart';
import 'package:rally/widget/table_calendar/table_calendar_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  late Map<DateTime, List<ScheduleModel>>? _map;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  int _sortType = 0;
  bool _isAscending = true;
  bool _schExpanded = true;
  bool _persExpanded = true;
  bool _groupExpanded = true;

  void _onFormatChanged(CalendarFormat format) {
    setState(() {
      _calendarFormat = format;
    });
  }

  @override
  void initState() {
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _map = {};
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Column(
            children: [
              TableCalendarWidget(
                selectedDay: _selectedDay,
                focusedDay: _focusedDay,
                data: _map,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                },
                calendarFormat: _calendarFormat,
                onFormatChanged: _onFormatChanged,
              ),
              Container(
                height: 4.0,
                width: 52.0,
                decoration: BoxDecoration(
                  color: scheme.surfaceVariant,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(2.0),
                  ),
                ),
              ),
              const SizedBox(height: 4.0),
            ],
          )
        ],
      ),
    );
  }
}
