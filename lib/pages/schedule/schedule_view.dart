import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rally/configs/style_config.dart';
import 'package:rally/dto/schedule/todo/todo_resp_dto.dart';
import 'package:rally/pages/components/sample/todo_sample.dart';
import 'package:rally/pages/schedule/todo/todo_ui.dart';
import 'package:rally/pages/schedule/schedule_create_view.dart';
import 'package:rally/pages/schedule/search/search_schedule_view.dart';
import 'package:rally/util/data_former.dart';
import 'package:rally/widget/drag_handle.dart';
import 'package:rally/widget/table_calendar/table_calendar_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  late Map<DateTime, List<TodoRespDto>>? _data;
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

  void _sortTodoList(List<TodoRespDto> list) {
    list.sort((a, b) => b.startDate.compareTo(a.startDate));
  }

  @override
  void initState() {
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _data = {};
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;

    return StreamBuilder<List<TodoRespDto>>(
        stream: null,
        builder: (context, snapshot) {
          _data = todoDataFormer(SampleTodoData.sampleList);
          DateTime selectDateKey = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);

          List<TodoRespDto> list = _data![selectDateKey] ?? [];

          _sortTodoList(list);

          return Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0.0,
              backgroundColor: scheme.background,
              title: Row(
                children: [
                  Text(
                    DateFormat(DateFormat.YEAR_MONTH, Platform.localeName).format(_focusedDay),
                    style: StyleConfigs.titleBold,
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     DateTime now = DateTime.now();
                  //     DateTime nowDate = DateTime(now.year, now.month, now.day);
                  //     if (_selectedDay != nowDate) {
                  //       setState(() {
                  //         _selectedDay = nowDate;
                  //         _focusedDay = _selectedDay;
                  //       });
                  //     }
                  //   },
                  //   borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  //     child: Text(
                  //       '${DateFormat(DateFormat.DAY).format(DateTime.now())}일',
                  //       style: StyleConfigs.titleBold.copyWith(color: scheme.outline),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () =>
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SearchScheduleView())),
                  icon: Icon(Icons.search_rounded, color: scheme.outline),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context)
                      .push(CupertinoPageRoute(builder: (_) => ScheduleCreateView(selectedDate: _selectedDay))),
                  icon: Icon(Icons.add),
                ),
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
                  child: Column(
                    children: [
                      TableCalendarWidget(
                        selectedDay: _selectedDay,
                        focusedDay: _focusedDay,
                        data: _data,
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
                      const DragHandle(),
                    ],
                  ),
                ),
                Expanded(
                  child: Scrollbar(
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 12.0, bottom: 32.0),
                      physics: const ClampingScrollPhysics(),
                      itemCount: list.length,
                      separatorBuilder: (context, index) => const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 28.0),
                        child: Divider(thickness: 0.1, height: 0.0),
                      ),
                      itemBuilder: (context, index) {
                        return TodoUi(data: list[index]);
                      },
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
