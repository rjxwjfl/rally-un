import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rally/configs/style_config.dart';
import 'package:rally/dto/schedule/todo/internal_todo_resp_dto.dart';
import 'package:rally/main.dart';
import 'package:rally/pages/schedule/search/search_schedule_view.dart';
import 'package:rally/pages/schedule/todo/todo_ui.dart';
import 'package:rally/util/data_former.dart';
import 'package:rally/widget/drag_handle.dart';
import 'package:rally/widget/table_calendar/table_calendar_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> with AutomaticKeepAliveClientMixin{
  late Map<DateTime, List<InternalTodoRespDto>> _data;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  int _sortType = 0;
  bool _isAscending = true;

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

  void _sortTodoList(List<InternalTodoRespDto> list) {
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
    super.build(context);
    ColorScheme scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: scheme.background,
        title: Text(
          DateFormat(DateFormat.YEAR_MONTH, Platform.localeName).format(_focusedDay),
          style: StyleConfigs.titleBold,
        ),
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
            child: Ink(
              width: 30.0,
              height: 30.0,
              decoration: BoxDecoration(
                border: Border.all(color: scheme.outline),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Center(child: Text(DateFormat(DateFormat.DAY).format(DateTime.now()), style: StyleConfigs.bodyMed)),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SearchScheduleView())),
            icon: Icon(Icons.search_rounded, color: scheme.outline),
          ),
          // IconButton(
          //   onPressed: () =>
          //       Navigator.of(context).push(CupertinoPageRoute(builder: (_) => ScheduleCreateView(selectedDate: _selectedDay))),
          //   icon: const Icon(Icons.add),
          // ),
        ],
      ),
      body: StreamBuilder<List<InternalTodoRespDto>>(
          stream: sqflite.todoStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              sqflite.getTodoCalendar();
              return const SizedBox();
            }

            List<InternalTodoRespDto> data = snapshot.data!;

            _data = todoDataFormer(data);
            DateTime selectDateKey = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);

            List<InternalTodoRespDto> list = _data[selectDateKey] ?? [];

            _sortTodoList(list);
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: scheme.background,
                    boxShadow: [
                      BoxShadow(
                        color: scheme.shadow.withOpacity(0.2),
                        blurRadius: 2.4,
                        spreadRadius: 0.1,
                        offset: Offset(0.0, 0.2),
                      ),
                    ],
                  ),
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 48.0,
                              height: 48.0,
                              decoration: BoxDecoration(
                                color: scheme.primary,
                                border: Border.all(color: scheme.secondary),
                                borderRadius: BorderRadius.all(Radius.circular(8.0))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${_selectedDay.day}',
                                    style: StyleConfigs.titleBold.copyWith(color: scheme.onPrimary), textAlign: TextAlign.center),
                              ),
                            ),
                          ),
                          Text(DateFormat(DateFormat.WEEKDAY, Platform.localeName).format(_selectedDay),
                              style: StyleConfigs.captionNormal),
                        ],
                      ),
                      Expanded(
                        child: Scrollbar(
                          child: ListView.separated(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 8.0, bottom: kToolbarHeight),
                            physics: const ClampingScrollPhysics(),
                            itemCount: list.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 8.0),
                            itemBuilder: (context, index) {
                              return TodoUi(data: list[index]);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
