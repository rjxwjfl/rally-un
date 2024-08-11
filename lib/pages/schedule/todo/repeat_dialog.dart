import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rally/configs/style_config.dart';
import 'package:rally/pages/schedule/components/clone_generator.dart';
import 'package:rally/pages/schedule/todo/components/repeat_model.dart';
import 'package:rally/pages/schedule/todo/components/weekday_selector.dart';
import 'package:rally/widget/buttons/default_button.dart';
import 'package:rally/widget/formed_widget_component.dart';

class RepeatDialog extends StatefulWidget {
  const RepeatDialog({required this.repeatModel, super.key});

  final RepeatModel repeatModel;

  @override
  State<RepeatDialog> createState() => _RepeatDialogState();
}

class _RepeatDialogState extends State<RepeatDialog> {
  late RepeatModel _model;
  late int _selectedType;
  late int _frequency;
  List<int>? _selectedWeekday;
  List<bool>? _weekdayFlag;

  DropdownMenuItem<int> _itemForm(int value, String text) {
    return DropdownMenuItem(
      value: value,
      alignment: Alignment.center,
      child: Text(text, style: StyleConfigs.captionNormal),
    );
  }

  void _initialize() {
    _model = widget.repeatModel;
    _weekdayFlag = List.generate(7, (index) => false);
    _selectedWeekday = _model.selectedWeekday;
    _frequency = _model.frequency;
    _selectedType = _model.currentType;
    for (var day in _selectedWeekday!) {
      if (day >= DateTime.monday && day <= DateTime.sunday) {
        _weekdayFlag![day - 1] = true; // 1-based index to 0-based index
      }
    }
  }

  void _increase() {
    setState(() {
      if ((_selectedType == 1 && _frequency < 30) ||
          (_selectedType == 2 && _frequency < 4) ||
          (_selectedType == 3 && _frequency < 12) ||
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
    if (value != null) {
      setState(() {
        _frequency = 1;
        _selectedType = value;
      });
    }
  }

  String _repeatString({required bool isDay, required DateTime date}) {
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
        subtext = '매월 ${DateFormat(DateFormat.DAY, 'ko_KR').format(date)}';
      } else {
        subtext = '매월 ${map[weekOfMonth(date)]} ${DateFormat('EEE', 'ko_KR').format(date)}요일';
      }
    } else if (_selectedType == 3) {
      if (!isDay) {
        subtext = '매년 ${DateFormat(DateFormat.MONTH_DAY, 'ko_KR').format(date)}';
      } else {
        subtext =
            '매년 ${DateFormat(DateFormat.MONTH, 'ko_KR').format(date)} ${map[weekOfMonth(date)]} ${DateFormat('EEE', 'ko_KR').format(date)}요일';
      }
    }

    return subtext;
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

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Dialog(
      backgroundColor: scheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CustomFilledButton(
                  onTap: () {},
                  padding: EdgeInsets.zero,
                  color: Colors.transparent,
                  borderColor: scheme.primary,
                  child: const Text('적용'),
                ),
              ),
            ),
            const Divider(height: 12.0, thickness: 0.2),
            FormedWidgetComponent(title: Text('반복 유형'), suffix: DropdownButtonHideUnderline(
              child: DropdownButton2<int>(
                isDense: true,
                alignment: Alignment.center,
                value: _model.currentType,
                items: [
                  _itemForm(0, '반복 없음'),
                  _itemForm(1, '일'),
                  _itemForm(2, '주'),
                  _itemForm(3, '월'),
                  _itemForm(4, '년'),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _model.frequency = 1;
                      _model.currentType = value;
                    });
                  }
                },
                buttonStyleData: ButtonStyleData(
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
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
            ),),
            if (_selectedType != 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text('반복 주기'),
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
                  ],
                ),
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
            // if (_selectedType > 1)
            //   Column(
            //     children: [_radioButton(isSpecDay: false), _radioButton(isSpecDay: true)],
            //   ),
          ],
        ),
      ),
    );
  }
}
