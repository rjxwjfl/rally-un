import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:rally/configs/style_config.dart';
import 'package:rally/model/todo_edit_model.dart';
import 'package:rally/pages/schedule/todo/components/repeat_model.dart';
import 'package:rally/util/data_former.dart';
import 'package:rally/util/datetime_convert.dart';
import 'package:rally/widget/buttons/custom_button.dart';
import 'package:rally/widget/drag_handle.dart';
import 'package:rally/widget/formed_widget_component.dart';
import 'package:rally/widget/option_switch.dart';
import 'package:rally/widget/table_calendar/date_select_calendar.dart';
import 'package:table_calendar/table_calendar.dart';

class DatePickBottomSheet extends StatefulWidget {
  const DatePickBottomSheet({required this.data, super.key});

  final TodoEditModel data;

  @override
  State<DatePickBottomSheet> createState() => _DatePickBottomSheetState();
}

class _DatePickBottomSheetState extends State<DatePickBottomSheet> {
  late DateTime _startDate;
  late DateTime _endDate;
  late DateTime _focusedDay;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late bool _isSelected;
  late RepeatModel _repeatModel;
  late List<bool> _weekdayFlag = List.generate(7, (index) => false);

  String _timeIndicator(DateTime date) => hmFormatter(date);

  String _dateIndicator() {
    if (_startDate.withoutTime == _endDate.withoutTime) {
      return '같은 날';
    }
    return mdFormatter(_endDate);
  }

  DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  void _initialize() {
    _focusedDay = DateTime.now();
    _startDate = widget.data.startDate;
    _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);

    _endDate = widget.data.endDate;
    _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);

    _isSelected = widget.data.isTimeSelected!;

    _repeatModel = RepeatModel(
      frequency: 1,
      currentType: 0,
      selectedWeekday: [DateTime.now().weekday],
      isSpecDay: false,
    );
    for (var day in _repeatModel.selectedWeekday) {
      if (day >= DateTime.monday && day <= DateTime.sunday) {
        _weekdayFlag[day - 1] = true; // 1-based index to 0-based index
      }
    }
  }

  void _initWeek(DateTime date) {
    int weekdayIndex = (date.weekday % 7);
    _weekdayFlag = List.generate(7, (index) => false);
    _repeatModel.selectedWeekday = [date.weekday];
    _weekdayFlag[weekdayIndex] = true;
  }

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: kToolbarHeight),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const DragHandle(),
                  FormedWidgetComponent(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      prefix: Icon(Icons.calendar_month_outlined, size: 18.0, color: scheme.primary),
                      title: Text(mdFormatter(_startDate), style: StyleConfigs.leadMed),
                      suffix: const SizedBox()),
                  const Divider(height: 12.0, thickness: 0.2),
                  DateSelectCalendar(
                    selectedDay: _startDate,
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_startDate, day),
                    onDaySelected: (select, focus) {
                      if (!isSameDay(_startDate, select)) {
                        setState(() {
                          if (_isSelected) {
                            _startDate = _combineDateAndTime(select, _startTime);
                            _endDate = _combineDateAndTime(select, _endTime);
                          } else {
                            _startDate = select.withoutTime;
                            _endDate = select.add(const Duration(days: 1));
                          }
                          _focusedDay = focus;
                          _initWeek(select);
                        });
                        debugPrint('DATE PICKER :: Start $_startDate / End $_endDate');
                      }
                    },
                    onPageChanged: (focus) {
                      setState(() {
                        _focusedDay = focus;
                      });
                    },
                  ),
                  // _getActionButton(onTap: () {}, text: '오늘', date: DateTime.now()),
                  // _getActionButton(onTap: () {}, text: '내일', date: DateTime.now().add(const Duration(days: 1))),
                  const Divider(height: 0.0, thickness: 0.2),
                  OptionSwitch(
                    icon: Icons.more_time_outlined,
                    text: '옵션',
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    flag: _isSelected,
                    onChanged: (value) => setState(() {
                      _isSelected = !_isSelected;
                      if (_isSelected) {
                        DateTime now = DateTime.now();
                        // _startTime = TimeOfDay(hour: now.hour, minute: now.minute);
                        _endTime = TimeOfDay(hour: now.hour + 1, minute: now.minute);
                        // _startDate = _combineDateAndTime(_startDate, _startTime);
                        _endDate = _combineDateAndTime(_startDate, _endTime);
                      } else {
                        _startDate = _startDate.withoutTime;
                        _endDate = _startDate.add(const Duration(days: 1));
                      }
                      debugPrint('TIME SELECT :: Start $_startDate / End $_endDate');
                    }),
                  ),
                  if (_isSelected)
                    Container(
                      decoration: BoxDecoration(border: Border(top: BorderSide(color: scheme.outline.withOpacity(0.2)))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              const VerticalDivider(thickness: 0.2),
                              Expanded(
                                child: Column(
                                  children: [
                                    // FormedWidgetComponent(
                                    //   prefix: Padding(
                                    //     padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                    //     child: Icon(Icons.not_started_outlined,
                                    //         size: 18.0, color: Theme.of(context).colorScheme.outline.withOpacity(0.8)),
                                    //   ),
                                    //   title: Text('시작', style: StyleConfigs.bodyNormal),
                                    //   suffix: CustomButton(
                                    //     onTap: () async {
                                    //       final res = await showTimePicker(
                                    //           context: context,
                                    //           initialTime: _startTime,
                                    //           initialEntryMode: TimePickerEntryMode.dial);
                                    //       if (res != null) {
                                    //         setState(() {
                                    //           _startTime = res;
                                    //           _startDate = _combineDateAndTime(_startDate, _startTime);
                                    //           if (_startDate.isAfter(_endDate)) {
                                    //             _endTime = res.replacing(hour: res.hour + 1);
                                    //             _endDate = _combineDateAndTime(_endDate, _endTime);
                                    //           }
                                    //         });
                                    //       }
                                    //     },
                                    //     padding: const EdgeInsets.all(8.0),
                                    //     text: _timeIndicator(_startDate),
                                    //     textColor: scheme.primary,
                                    //   ),
                                    // ),
                                    FormedWidgetComponent(
                                      prefix: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                        child: Icon(Icons.stop_circle_outlined,
                                            size: 18.0, color: Theme.of(context).colorScheme.outline.withOpacity(0.8)),
                                      ),
                                      title: Text('종료', style: StyleConfigs.bodyNormal),
                                      suffix: Row(
                                        children: [
                                          // CustomButton(
                                          //   onTap: () async {
                                          //     final res = await showDatePicker(
                                          //       context: context,
                                          //       currentDate: _endDate,
                                          //       initialDate: _endDate,
                                          //       firstDate: _startDate,
                                          //       lastDate: DateTime(2100, 12, 31),
                                          //       initialEntryMode: DatePickerEntryMode.calendarOnly,
                                          //       locale: getLocale()
                                          //     );
                                          //     if (res != null) {
                                          //       setState(() {
                                          //         _endDate = _combineDateAndTime(res, _endTime);
                                          //
                                          //         if (_endDate.withoutTime == _startDate.withoutTime) {
                                          //           // If endDate is the same as startDate
                                          //           if (_endTime.hour < _startTime.hour || (_endTime.hour == _startTime.hour && _endTime.minute <= _startTime.minute)) {
                                          //             // Automatically set endTime to 1 hour after startTime
                                          //             _endTime = _startTime.replacing(hour: _startTime.hour + 1);
                                          //             _endDate = _combineDateAndTime(_endDate, _endTime);
                                          //           }
                                          //         }
                                          //       });
                                          //     }
                                          //   },
                                          //   padding: const EdgeInsets.all(8.0),
                                          //   text: _dateIndicator(),
                                          //   textColor: scheme.primary,
                                          // ),
                                          CustomButton(
                                            onTap: () async {
                                              final res = await showTimePicker(
                                                  context: context,
                                                  initialTime: _endTime,
                                                  initialEntryMode: TimePickerEntryMode.dial);
                                              if (res != null) {
                                                setState(() {
                                                  if (_startDate.withoutTime == _endDate.withoutTime) {
                                                    // Case 1: Dates are the same
                                                    if (res.hour < _startTime.hour || (res.hour == _startTime.hour && res.minute <= _startTime.minute)) {
                                                      // Automatically set endTime to 1 hour after startTime
                                                      _endTime = _startTime.replacing(hour: _startTime.hour + 1);
                                                    } else {
                                                      // Valid time selected
                                                      _endTime = res;
                                                    }
                                                  } else {
                                                    // Case 2: Dates are different, no validation needed
                                                    _endTime = res;
                                                  }
                                                  _endDate = _combineDateAndTime(_endDate, _endTime);
                                                });
                                              }
                                            },
                                            padding: const EdgeInsets.all(8.0),
                                            text: _timeIndicator(_endDate),
                                            textColor: scheme.primary,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Ink(
              height: kToolbarHeight,
              decoration:
                  BoxDecoration(color: scheme.surface, border: Border(top: BorderSide(color: scheme.outline, width: 0.2))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    ),
                    child: const Text('취소'),
                  ),
                  const SizedBox(width: 8.0),
                  TextButton(
                    onPressed: () {
                      final data = TodoEditModel(startDate: _startDate, endDate: _endDate, isTimeSelected: !_endDate.isDayStart);
                      debugPrint(data.toString());
                      Navigator.of(context).pop(data);
                    },
                    style:
                        TextButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)))),
                    child: const Text('적용'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
