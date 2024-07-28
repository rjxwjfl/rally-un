import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rally/pages/schedule/todo/components/date_picker_button.dart';

class DatePickBottomSheet extends StatefulWidget {
  const DatePickBottomSheet({required this.date, super.key});

  final DateTime date;

  @override
  State<DatePickBottomSheet> createState() => _DatePickBottomSheetState();
}

class _DatePickBottomSheetState extends State<DatePickBottomSheet> {
  late DateTime _startDate;
  late DateTime _endDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  bool _allDayStart = false;
  bool _allDayEnd = true;

  void _initialize() {
    _startDate = widget.date;
    _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
    if (_allDayEnd) {
      _endDate = DateTime(widget.date.year, widget.date.month, widget.date.day, 23, 59, 59);
      _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
    }
  }

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          DatePickerButton(
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              DateTime? date = await showDatePicker(
                context: context,
                initialDate: widget.date,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100, 12, 31),
              );
              if (date != null) {
                final start = DateTime(date.year, date.month, date.day, _startTime.hour, _startTime.minute);
                setState(() {
                  _startDate = start;
                  if (_endDate.isBefore(_startDate)) {
                    _endDate = start.copyWith(
                      day: date.day + 7,
                      hour: _endTime.hour,
                      minute: _endTime.minute,
                    );
                  }
                });
              }
            },
            icon: Icons.access_time_rounded,
            text: DateFormat(DateFormat.YEAR_MONTH_DAY, 'ko_KR').format(_startDate),
          ),
        ],
      ),
    );
  }
}
