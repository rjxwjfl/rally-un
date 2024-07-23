import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rally/dto/schedule/todo/replica_gen_model.dart';
import 'package:rally/dto/schedule/todo/replica_date_model.dart';
import 'package:rally/dto/schedule/todo/todo_req_dto.dart';
import 'package:rally/dto/user/user_data_resp_dto.dart';
import 'package:rally/pages/schedule/components/clone_generator.dart';
import 'package:rally/pages/schedule/todo/components/date_picker_button.dart';
import 'package:rally/pages/schedule/todo/components/item_option_button.dart';
import 'package:rally/pages/schedule/todo/components/repeat_dialog.dart';
import 'package:rally/pages/schedule/todo/components/repeat_model.dart';
import 'package:rally/pages/schedule/todo_user_add_view.dart';
import 'package:rally/widget/indicator/result_indicator.dart';
import 'package:rally/widget/indicator/user/horizontal_user_indicator.dart';
import 'package:rally/widget/non_glow_inkwell.dart';
import 'package:rally/widget/notification/notification_snack_bar.dart';
import 'package:rally/pages/schedule/todo/components/item_option_switch.dart';
import 'package:rally/widget/text_field/title_text_field.dart';

class ScheduleCreateView extends StatefulWidget {
  const ScheduleCreateView({required this.selectedDate, super.key});

  final DateTime selectedDate;

  @override
  State<ScheduleCreateView> createState() => _ScheduleCreateViewState();
}

class _ScheduleCreateViewState extends State<ScheduleCreateView> {
  final StreamController<List<UserDataRespDto>> _pickerStream = StreamController.broadcast();
  final TextEditingController _titleEditor = TextEditingController();
  final TextEditingController _descEditor = TextEditingController();
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _descFocus = FocusNode();
  late List<int> _selectedWeekday;
  late List<bool> _weekdayFlag = List.generate(7, (index) => false);
  late List<UserDataRespDto> _pickedList;
  List<Duration> _reminderList = [];

  late DateTime _scheduleStart;
  late DateTime _scheduleEnd;
  late DateTime _repeatEnd;

  late TimeOfDay _executionTime;
  late TimeOfDay _expirationTime;

  bool _allDayFlag = true;
  bool _repeatFlag = false;
  bool _specFlag = false;
  bool _todayFlag = true;
  bool _isShare = false;
  Duration? _reminderDuration;
  int? _repeatType;
  int _frequency = 1;
  int? _selectedCategory;
  double? _lat;
  double? _lng;

  String _reminderText() {
    if (_reminderDuration != null) {
      if (_reminderDuration!.inDays > 0) {
        if (_reminderDuration!.inDays >= 7) {
          return '${(_reminderDuration!.inHours / 7)}주 후';
        }
        return '${_reminderDuration!.inDays}일 후';
      }
      if (_reminderDuration!.inHours > 0) {
        return '${_reminderDuration!.inHours}시간 후';
      }
      if (_reminderDuration!.inMinutes > 0) {
        return '${_reminderDuration!.inMinutes}시간 후';
      }
    }
    return '없음';
  }

  Future<void> _postTodo() async {
    if (!_validate()) {
      return;
    }

    CloneGenerator generator = CloneGenerator();

    List<ReplicaDateModel> replica = generator.generator(
      model: RepGenerateModel(
        description: _descEditor.text.trim(),
        scheduleStart: _scheduleStart,
        scheduleEnd: _scheduleEnd,
        allDayFlag: _allDayFlag,
        todayFlag: _todayFlag,
        specFlag: _specFlag,
        frequency: _frequency,
        repeatType: _repeatType,
        weekday: _selectedWeekday,
      ),
    );

    TodoReqDto? todo = TodoReqDto(
      replica: replica,
      repeatFlag: _repeatFlag,
      repeatType: _repeatType,
      frequency: _frequency,
      weekday: _selectedWeekday,
      allDayFlag: _allDayFlag,
      todayFlag: _todayFlag,
      specFlag: _specFlag,
    );
  }

  bool _validate() {
    NotificationSnackBar snackBar = NotificationSnackBar(context);
    if (_titleEditor.text.trim().isEmpty) {
      snackBar.alert(text: '제목을 입력하세요.');
      FocusScope.of(context).requestFocus(_titleFocus);
      return false;
    }

    if (_titleEditor.text.trim().length > 20) {
      snackBar.alert(text: '제목이 너무 깁니다.');
      FocusScope.of(context).requestFocus(_titleFocus);
      return false;
    }

    if (_descEditor.text.trim().isEmpty) {
      snackBar.alert(text: '설명을 입력하세요.');
      FocusScope.of(context).requestFocus(_descFocus);
      return false;
    }

    if (_selectedCategory == null) {
      snackBar.alert(text: '일정 분류를 선택하세요.');
      FocusScope.of(context).unfocus();
      return false;
    }

    return true;
  }

  bool _compareTimeOfDay(TimeOfDay value, TimeOfDay target) {
    if (value.hour > target.hour) {
      return true;
    }

    if (value.hour == target.hour) {
      return value.minute > target.minute;
    }

    return false;
  }

  String _formatDuration(Duration duration) {
    int weeks = duration.inDays ~/ 7;
    int days = duration.inDays % 7;
    int hours = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;

    String formattedDuration = '';

    if (weeks > 0) {
      formattedDuration += '$weeks주 ';
    }
    if (days > 0) {
      formattedDuration += '$days일 ';
    }
    if (hours > 0) {
      formattedDuration += '$hours시간 ';
    }
    if (minutes > 0) {
      formattedDuration += '$minutes분 ';
    }

    formattedDuration += '전';

    return formattedDuration.trim();
  }

  String repeatTypeToString(int type) {
    const map = {0: '일', 1: '주', 2: '개월', 3: '년'};

    return map[type] ?? '일';
  }

  String repeatString({
    required bool repeatFlag,
    required int frequency,
    required int repeatType,
    required DateTime scheduleStart,
    bool isSpecificDay = false,
    List<int>? weeks,
  }) {
    const weekMap = {1: '월', 2: '화', 3: '수', 4: '목', 5: '금', 6: '토', 7: '일'};
    const map = {1: '첫째', 2: '둘째', 3: '셋째', 4: '넷째', 5: '마지막'};

    String text;
    String subtext = '';
    if (repeatFlag) {
      text = '$frequency${repeatTypeToString(repeatType)}마다';
      if (repeatType == 1) {
        if (weeks != null) {
          String weekdaysString = weeks.map((day) => weekMap[day]!).join(', ');
          text = '$text $weekdaysString요일';
        }
      } else if (repeatType == 2) {
        if (!isSpecificDay) {
          subtext = '매월 ${DateFormat(DateFormat.DAY, 'ko_KR').format(scheduleStart)}';
        } else {
          subtext = '매월 ${map[weekOfMonth(scheduleStart)]} ${DateFormat('EEE', 'ko_KR').format(scheduleStart)}요일';
        }
        text = '$text ($subtext)';
      } else if (repeatType == 3) {
        if (!isSpecificDay) {
          subtext = '매년 ${DateFormat(DateFormat.MONTH_DAY, 'ko_KR').format(scheduleStart)}';
        } else {
          subtext =
              '매년 ${DateFormat(DateFormat.MONTH, 'ko_KR').format(scheduleStart)} ${map[weekOfMonth(scheduleStart)]} ${DateFormat('EEE', 'ko_KR').format(scheduleStart)}요일';
        }
        text = '$text ($subtext)';
      }

      return text;
    }

    return '';
  }

  void _sinkUser(List<UserDataRespDto> data) {
    _pickedList = data;
    _pickedList.sort((a, b) => a.displayName.compareTo(b.displayName));
    _pickerStream.sink.add(_pickedList);
  }

  @override
  void initState() {
    DateTime now = DateTime.now();
    _executionTime = TimeOfDay(hour: now.hour, minute: now.minute);
    _expirationTime = TimeOfDay(hour: now.hour + 1, minute: now.minute);
    _scheduleStart = widget.selectedDate.copyWith(hour: _executionTime.hour, minute: _executionTime.minute);
    _scheduleEnd = widget.selectedDate.copyWith(hour: _expirationTime.hour, minute: _expirationTime.minute);
    _repeatEnd = _scheduleStart.add(const Duration(days: 28));
    _selectedWeekday = [];
    _pickedList = [];
    _weekdayFlag[0] = true;
    _selectedWeekday.add(1);
    super.initState();
  }

  @override
  void dispose() {
    _titleEditor.dispose();
    _descEditor.dispose();
    _titleFocus.dispose();
    _descFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: scheme.background,
        scrolledUnderElevation: 0.0,
        actions: [
          TextButton(onPressed: () => _postTodo(), child: const Text('생성')),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              TitleTextField(
                controller: _titleEditor,
                focusNode: _titleFocus,
                hintText: '제목',
                icon: Icons.edit_calendar_rounded,
              ),
              const Divider(thickness: 0.1),
              TitleTextField(
                controller: _descEditor,
                focusNode: _descFocus,
                hintText: '세부 설명 (선택)',
              ),
              const Divider(thickness: 0.1),
              Column(
                children: [
                  ItemOptionSwitch(
                    text: '종일',
                    flag: _allDayFlag,
                    onChanged: (value) {
                      setState(() {
                        _allDayFlag = value;
                        if (_repeatFlag) {
                          // 반복 일정의 경우 반복 종료일을 일정 종료일로 적용한다.
                          _scheduleEnd = _repeatEnd;
                        }

                        if (_allDayFlag) {
                          _scheduleStart = _scheduleStart.copyWith(hour: 0, minute: 0, second: 0);
                          _scheduleEnd = _scheduleEnd.copyWith(hour: 23, minute: 59, second: 59);
                        } else {
                          _scheduleStart =
                              _scheduleStart.copyWith(hour: _executionTime.hour, minute: _executionTime.minute);
                          if (_todayFlag) {
                            _scheduleEnd = _scheduleEnd.copyWith(hour: 23, minute: 59, second: 59);
                          } else {
                            _scheduleEnd =
                                _scheduleEnd.copyWith(hour: _expirationTime.hour, minute: _expirationTime.minute);
                          }
                        }
                      });
                    },
                  ),
                  if (!_allDayFlag)
                    ItemOptionSwitch(
                      text: '마감시간',
                      flag: !_todayFlag,
                      onChanged: (value) {
                        setState(() {
                          _todayFlag = !value;
                          if (_repeatFlag) {
                            _scheduleEnd = _repeatEnd;
                          }
                          // 종료시각이 있는 경우에는 하루종일 일정이 아니므로 종료 시각을 조정하도록 한다.
                          if (_todayFlag) {
                            _scheduleEnd = _scheduleEnd.copyWith(hour: 23, minute: 59, second: 59);
                          } else {
                            _scheduleEnd =
                                _scheduleEnd.copyWith(hour: _expirationTime.hour, minute: _expirationTime.minute);
                          }
                        });
                      },
                    ),
                  ItemOptionSwitch(
                    text: '반복',
                    flag: _repeatFlag,
                    onChanged: (value) {
                      setState(() {
                        _repeatFlag = value;
                        _repeatType = 0;
                        if (_repeatFlag) {
                          _scheduleEnd =
                              _repeatEnd.copyWith(hour: _expirationTime.hour, minute: _expirationTime.minute);
                        } else {
                          // 반복이 아닌 경우에는 시작 날짜와 동일하니 시간만 조정하도록 한다.
                          if (_todayFlag || _allDayFlag) {
                            _scheduleEnd = _scheduleStart.copyWith(hour: 23, minute: 59, second: 59);
                          } else {
                            _scheduleEnd =
                                _scheduleStart.copyWith(hour: _expirationTime.hour, minute: _expirationTime.minute);
                          }
                        }
                      });
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // When schedule start
                      DatePickerButton(
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: _scheduleStart,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100, 12, 31),
                          );
                          if (date != null) {
                            final start =
                                DateTime(date.year, date.month, date.day, _executionTime.hour, _executionTime.minute);
                            setState(() {
                              _scheduleStart = start;
                              if (_scheduleEnd.isBefore(_scheduleStart)) {
                                _scheduleEnd = start.copyWith(
                                  day: date.day + 7,
                                  hour: _expirationTime.hour,
                                  minute: _expirationTime.minute,
                                );
                              }
                            });
                          }
                        },
                        icon: Icons.access_time_rounded,
                        text: DateFormat(DateFormat.YEAR_MONTH_DAY, 'ko_KR').format(_scheduleStart),
                      ),
                      const Expanded(child: SizedBox()),
                      if (!_allDayFlag)
                        Column(
                          children: [
                            DatePickerButton(
                              onTap: () async {
                                FocusScope.of(context).requestFocus(FocusNode());
                                TimeOfDay? time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay(hour: _executionTime.hour, minute: _executionTime.minute),
                                );

                                if (time != null) {
                                  setState(() {
                                    _executionTime = time;
                                    _expirationTime = time.replacing(hour: time.hour + 1);
                                    _scheduleStart = _scheduleStart.copyWith(
                                        hour: _executionTime.hour, minute: _executionTime.minute);
                                    _scheduleEnd = _scheduleEnd.copyWith(
                                        hour: _expirationTime.hour, minute: _expirationTime.minute);
                                  });
                                }
                              },
                              text: DateFormat('a hh:mm', 'ko_KR').format(_scheduleStart),
                            ),
                            if (!_todayFlag)
                              DatePickerButton(
                                onTap: () async {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  TimeOfDay? time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(hour: _expirationTime.hour, minute: _expirationTime.minute),
                                  );

                                  if (time != null) {
                                    setState(() {
                                      if (_compareTimeOfDay(time, _executionTime)) {
                                        _expirationTime = time;
                                        _scheduleEnd = _scheduleEnd.copyWith(
                                            hour: _expirationTime.hour, minute: _expirationTime.minute);
                                      } else {
                                        _expirationTime = _executionTime.replacing(hour: _executionTime.hour + 1);
                                        _scheduleEnd = _scheduleEnd.copyWith(
                                            hour: _expirationTime.hour, minute: _expirationTime.minute);
                                      }
                                    });
                                  }
                                },
                                text: DateFormat('a hh:mm', 'ko_KR').format(_scheduleEnd),
                              ),
                          ],
                        ),
                    ],
                  ),
                  if (_repeatFlag)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ItemOptionButton(
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            RepeatModel? data = await showDialog(
                              context: context,
                              builder: (context) => RepeatDialog(
                                frequency: _frequency,
                                currentType: _repeatType!,
                                selectedWeekday: _selectedWeekday,
                                weekdayFlag: _weekdayFlag,
                                scheduleStart: _scheduleStart,
                                scheduleEnd: _scheduleEnd,
                                isDay: _specFlag,
                              ),
                            );
                            if (data != null) {
                              setState(() {
                                _frequency = data.frequency;
                                _repeatType = data.currentType;
                                _scheduleEnd = data.scheduleEnd;

                                if (data.currentType == 1) {
                                  _weekdayFlag = List.from(data.weekdayFlag!);
                                  _selectedWeekday = List.from(data.selectedWeekday!);
                                }

                                if (data.currentType > 1) {
                                  _specFlag = data.isDay!;
                                }
                              });
                            }
                          },
                          titleText: '반복 유형',
                          icon: Icons.event_repeat,
                          contentText: repeatString(
                            repeatFlag: _repeatFlag,
                            frequency: _frequency,
                            repeatType: _repeatType!,
                            scheduleStart: _scheduleStart,
                            isSpecificDay: _specFlag,
                            weeks: _selectedWeekday,
                          ),
                        ),
                        ItemOptionButton(
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            DateTime? date = await showDatePicker(
                              context: context,
                              initialDate: _scheduleEnd,
                              firstDate: _scheduleStart.add(const Duration(days: 1)),
                              lastDate: DateTime(2100, 12, 31),
                            );
                            if (date != null) {
                              setState(() {
                                _repeatEnd = date.copyWith(hour: _expirationTime.hour, minute: _expirationTime.minute);
                                _scheduleEnd = _repeatEnd;
                              });
                            }
                          },
                          titleText: '반복 종료',
                          icon: Icons.access_time_filled_rounded,
                          contentText: DateFormat(DateFormat.YEAR_MONTH_DAY, 'ko_KR').format(_scheduleEnd),
                        ),
                      ],
                    ),
                ],
              ),
              const Divider(thickness: 0.1),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Column(
                  children: [
                    ItemOptionSwitch(
                      text: '공유',
                      flag: _isShare,
                      onChanged: (value) {
                        setState(() {
                          _isShare = !_isShare;
                          _pickedList = [];
                        });
                        _pickerStream.sink.add(_pickedList);
                      },
                      icon: Icons.share,
                    ),
                    if (_isShare) StreamBuilder(
                      stream: _pickerStream.stream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return ItemOptionButton(onTap: () async{
                            FocusScope.of(context).requestFocus(FocusNode());
                            List<UserDataRespDto>? data = await showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                              isScrollControlled: true,
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                  child: TodoUserAddView(pickedUserList: List.from(_pickedList)),
                                );
                              },
                            );

                            if (data != null) {
                              _sinkUser(data);
                            }
                          },titleText: '공유 대상 선택', );
                        }
                        return Scrollbar(
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 24.0),
                            itemCount: _pickedList.length,
                            itemBuilder: (context, index) {
                              UserDataRespDto data = _pickedList[index];
                              return HorizontalUserIndicator(
                                key: ValueKey(data.userId),
                                displayName: data.displayName,
                                imageUrl: data.imageUrl,
                                checkInfo: () async {},
                                onRemove: () {
                                  _pickedList.removeWhere((element) => element.userId == data.userId);
                                  _pickedList.sort((a, b) => a.displayName.compareTo(b.displayName));
                                  _pickerStream.sink.add(_pickedList);
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: kToolbarHeight),
            ],
          ),
        ),
      ),
    );
  }

  Widget dateIndicator({required int index, required bool dateBool, required VoidCallback onTap}) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    const map = {0: '월', 1: '화', 2: '수', 3: '목', 4: '금', 5: '토', 6: '일'};
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: NonGlowInkWell(
        onTap: onTap,
        child: Container(
          height: 45.0,
          width: 45.0,
          decoration: BoxDecoration(
              color: dateBool ? scheme.primary : scheme.surface,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: scheme.shadow.withOpacity(0.3),
                    spreadRadius: 0.0,
                    blurRadius: 2.0,
                    offset: const Offset(0, 2.0))
              ]),
          child: Center(
            child: Text(
              map[index]!,
              style: TextStyle(color: dateBool ? scheme.onPrimary : scheme.onSurface),
            ),
          ),
        ),
      ),
    );
  }

  Widget reminderUI(Duration item) {
    return Row(
      children: [
        Text(_formatDuration(item)),
        const Expanded(child: SizedBox()),
        IconButton(
          onPressed: () {
            setState(() {
              _reminderList.removeWhere((element) => element == item);
            });
          },
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }
}
