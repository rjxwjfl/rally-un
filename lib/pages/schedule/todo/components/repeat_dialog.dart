import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rally/pages/schedule/components/clone_generator.dart';
import 'package:rally/pages/schedule/todo/components/repeat_model.dart';
import 'package:rally/pages/schedule/todo/components/weekday_selector.dart';
import 'package:rally/widget/custom_button.dart';

class RepeatDialog extends StatefulWidget {
  const RepeatDialog(
      {required this.frequency,
        required this.currentType,
        required this.selectedWeekday,
        required this.weekdayFlag,
        required this.scheduleStart,
        required this.scheduleEnd,
        required this.isDay,
        super.key});

  final int frequency;
  final int currentType;
  final List<int>? selectedWeekday;
  final List<bool>? weekdayFlag;
  final DateTime scheduleStart;
  final DateTime scheduleEnd;
  final bool? isDay;

  @override
  State<RepeatDialog> createState() => _RepeatDialogState();
}

class _RepeatDialogState extends State<RepeatDialog> {
  late final DateTime _scheduleStart = widget.scheduleStart;
  late DateTime _scheduleEnd = widget.scheduleEnd;
  late int _selectedType = widget.currentType;
  late int _frequency = widget.frequency;
  List<int>? _selectedWeekday;
  List<bool>? _weekdayFlag;
  bool? _isDay;

  void _initialize() {
    if (widget.selectedWeekday != null) {
      _selectedWeekday = List.from(widget.selectedWeekday!);
      _weekdayFlag = List.from(widget.weekdayFlag!);
    } else {
      _selectedWeekday = [1];
      _weekdayFlag = List.generate(7, (index) => false);
      _weekdayFlag![0] = true;
    }

    if (widget.isDay != null) {
      _isDay = widget.isDay!;
    } else {
      _isDay = false;
    }
  }

  void _increase() {
    setState(() {
      if ((_selectedType == 0 && _frequency < 30) ||
          (_selectedType == 1 && _frequency < 4) ||
          (_selectedType == 2 && _frequency < 12) ||
          _selectedType == 3) {
        _frequency++;
      }
    });
  }

  void _decrease() {
    if (_frequency > 1) {
      setState(() {
        _frequency--;
      });
    }
  }

  void _onRepeatTypeChange(int? value) {
    // daily: 30 days, weekly: 3 month, monthly: 6 month, yearly: 3 years
    const map = {0: 30, 1: 90, 2: 180, 3: 365 * 3};
    if (value != null) {
      setState(() {
        _frequency = 1;
        _selectedType = value;
        _scheduleEnd =
            _scheduleStart.copyWith(day: _scheduleEnd.day + map[value]!, hour: _scheduleEnd.hour, minute: _scheduleEnd.minute);
      });
    }
  }

  void _onWeekdaySelect(int index) {
    setState(() {
      _weekdayFlag![index] = !_weekdayFlag![index];
      if (_selectedWeekday!.contains(index + 1)) {
        _selectedWeekday!.remove(index + 1);
      } else {
        _selectedWeekday!.add(index + 1);
      }
      _selectedWeekday!.sort((a, b) => a.compareTo(b));
      if (_selectedWeekday!.isEmpty) {
        _weekdayFlag![0] = true;
        _selectedWeekday!.add(1);
      }
    });
  }

  String _repeatString(bool isDay) {
    const weekMap = {1: '월', 2: '화', 3: '수', 4: '목', 5: '금', 6: '토', 7: '일'};
    const map = {1: '첫째', 2: '둘째', 3: '셋째', 4: '넷째', 5: '마지막'};

    String subtext = '';
    if (_selectedType == 1) {
      if (_selectedWeekday!.isNotEmpty) {
        String weekdaysString = _selectedWeekday!.map((day) => weekMap[day]!).join(', ');
        subtext = '$weekdaysString요일';
      }
    } else if (_selectedType == 2) {
      if (!isDay) {
        subtext = '매월 ${DateFormat(DateFormat.DAY, 'ko_KR').format(_scheduleStart)}';
      } else {
        subtext = '매월 ${map[weekOfMonth(_scheduleStart)]} ${DateFormat('EEE', 'ko_KR').format(_scheduleStart)}요일';
      }
    } else if (_selectedType == 3) {
      if (!isDay) {
        subtext = '매년 ${DateFormat(DateFormat.MONTH_DAY, 'ko_KR').format(_scheduleStart)}';
      } else {
        subtext =
        '매년 ${DateFormat(DateFormat.MONTH, 'ko_KR').format(_scheduleStart)} ${map[weekOfMonth(_scheduleStart)]} ${DateFormat('EEE', 'ko_KR').format(_scheduleStart)}요일';
      }
    }

    return subtext;
  }

  void _submit() {
    RepeatModel data = RepeatModel(
      frequency: _frequency,
      currentType: _selectedType,
      scheduleEnd: _scheduleEnd,
    );

    if (_selectedType == 1) {
      data = data.copyWith(selectedWeekday: _selectedWeekday, weekdayFlag: _weekdayFlag);
    }

    if (_selectedType > 1) {
      data = data.copyWith(isDay: _isDay);
    }
    Navigator.of(context).pop(data);
  }

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text('반복 주기'),
                  ),
                ),
                IconButton(
                  onPressed: _decrease,
                  icon: const Icon(Icons.remove_circle_outline_rounded, size: 18.0),
                ),
                Text(
                  '$_frequency',
                  style: TextStyle(color: scheme.primary, fontSize: 14.0),
                ),
                IconButton(
                  onPressed: _increase,
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 18.0),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton2<int>(
                    value: _selectedType,
                    items: const [
                      DropdownMenuItem(value: 0, child: Text('일')),
                      DropdownMenuItem(value: 1, child: Text('주')),
                      DropdownMenuItem(value: 2, child: Text('월')),
                      DropdownMenuItem(value: 3, child: Text('년')),
                    ],
                    onChanged: _onRepeatTypeChange,
                    buttonStyleData: ButtonStyleData(
                      height: 35.0,
                      width: 60.0,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: scheme.surface,
                        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                        boxShadow: [
                          BoxShadow(
                            color: scheme.shadow.withOpacity(0.3),
                            spreadRadius: 0.0,
                            blurRadius: 2.0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_selectedType == 1)
              SizedBox(
                height: 70.0,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _weekdayFlag!.length,
                  itemBuilder: (context, index) => WeekdaySelectIndicator(
                    onTap: () => _onWeekdaySelect(index),
                    index: index,
                    isSelected: _weekdayFlag![index],
                  ),
                ),
              ),
            if (_selectedType > 1)
              Column(
                children: [_radioButton(isDay: false), _radioButton(isDay: true)],
              ),
            Align(
                alignment: Alignment.centerRight,
                child: CustomButton(onTap: _submit,text: '확인')
            ),
          ],
        ),
      ),
    );
  }

  Widget _radioButton({required bool isDay}) {
    return Row(
      children: [
        Radio(
            value: isDay,
            groupValue: _isDay,
            onChanged: (value) {
              setState(() {
                _isDay = isDay;
              });
            }),
        Text(_repeatString(isDay)),
      ],
    );
  }
}
