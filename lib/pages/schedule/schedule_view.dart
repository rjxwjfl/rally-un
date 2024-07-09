import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rally/configs/style_config.dart';
import 'package:rally/dto/schedule/schedule_resp_dto.dart';
import 'package:rally/widget/dialog/model/dialog_item_model.dart';
import 'package:rally/widget/dialog/popup_dialog.dart';
import 'package:rally/widget/table_calendar/table_calendar_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  late Map<DateTime, List<ScheduleRespDto>>? _map;
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

  void _setSortType(int type, bool ascend) {
    setState(() {
      if (_sortType != type) {
        _sortType = type;
      }
      if (_isAscending != ascend) {
        _isAscending = ascend;
      }
    });
    Navigator.of(context).pop();
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
      appBar: AppBar(
        title: Text(DateFormat(DateFormat.YEAR_MONTH, Platform.localeName).format(_focusedDay), style: StyleConfigs.titleBold),
        actions: [
          InkWell(
            onTap: () {
              DateTime now = DateTime.now();
              DateTime nowDate = DateTime(now.year, now.month, now.day);
              if (_selectedDay != nowDate) {
                setState(() {
                  _selectedDay = nowDate;
                  _focusedDay = _selectedDay;
                });
              }
            },
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.center,
                constraints: const BoxConstraints(
                    minWidth: 25.0,
                    maxHeight: 25.0
                ),
                decoration: BoxDecoration(
                    border: Border.all(color: scheme.outline, width: 2.0),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    DateFormat(DateFormat.DAY).format(DateTime.now()),
                    style: StyleConfigs.captionBold.copyWith(color: scheme.outline),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => PopupDialog(
                items: [
                  DialogItemModel(onTap: () => _setSortType(2, false), text: '진행상태 순으로 정렬'),
                  DialogItemModel(onTap: () => _setSortType(0, true), text: '시작시간 내림차순 정렬'),
                  DialogItemModel(onTap: () => _setSortType(1, true), text: '종료시간 순으로 정렬'),
                ],
              ),
            ),
            icon: Icon(CupertinoIcons.sort_down, color: scheme.outline),
          ),
        ],
      ),
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
