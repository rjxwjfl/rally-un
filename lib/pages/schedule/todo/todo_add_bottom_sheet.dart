import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rally/configs/style_config.dart';
import 'package:rally/dto/schedule/todo/todo_req_dto.dart';
import 'package:rally/dto/user/todo_author.dart';
import 'package:rally/main.dart';
import 'package:rally/model/todo_edit_model.dart';
import 'package:rally/pages/schedule/todo/date_pick_bottom_sheet.dart';
import 'package:rally/util/data_converter.dart';
import 'package:rally/util/datetime_convert.dart';
import 'package:rally/widget/bottom_sheet/schedule_todo_bottom_sheet.dart';
import 'package:rally/widget/buttons/default_button.dart';
import 'package:rally/widget/buttons/inline_button.dart';
import 'package:rally/widget/drag_handle.dart';
import 'package:rally/widget/formed_widget_component.dart';
import 'package:rally/widget/text_field/title_text_field.dart';

class TodoAddBottomSheet extends StatefulWidget {
  const TodoAddBottomSheet({this.selectedDate, super.key});

  final DateTime? selectedDate;

  @override
  State<TodoAddBottomSheet> createState() => _TodoAddBottomSheetState();
}

class _TodoAddBottomSheetState extends State<TodoAddBottomSheet> {
  late final TextEditingController _titleEditor;
  late final TextEditingController _descEditor;
  late final FocusNode _titleNode;
  late final FocusNode _descNode;
  late TodoEditModel _todo;
  late DateTime _startDate;
  late DateTime _endDate;
  late bool _endOfDay;
  late int _defaultStorage;
  int _storageType = 1; // 0: 기본 보관함, 1: 공유 보관함
  int _priority = 0;

  void _initialize() {
    DateTime now = DateTime.now();
    if (widget.selectedDate != null) {
      _startDate = DateTime(widget.selectedDate!.year, widget.selectedDate!.month, widget.selectedDate!.day);
    } else {
      _startDate = DateTime(now.year, now.month, now.day);
    }
    _endDate = _startDate.add(const Duration(days: 1));

    _todo = TodoEditModel(
      startDate: _startDate,
      endDate: _endDate,
      isTimeSelected: false,
    );

    _endOfDay = !_todo.isTimeSelected!;

    _defaultStorage = prefs.getInt('default_storage') ?? 1;
  }

  @override
  void initState() {
    _titleEditor = TextEditingController();
    _descEditor = TextEditingController();
    _titleNode = FocusNode();
    _descNode = FocusNode();
    _initialize();
    _titleNode.requestFocus();
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
            padding: const EdgeInsets.only(bottom: kToolbarHeight * 3),
            child: Scrollbar(
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const DragHandle(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12.0, left: 16.0, right: 16.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (_storageType == 0) {
                                _storageType = 1;
                              } else {
                                _storageType = 0;
                              }
                            });
                          },
                          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                          child: Ink(
                            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_storageType == 0)
                                  Icon(CupertinoIcons.folder, size: 14.0, color: scheme.primary)
                                else
                                  Icon(Icons.share_outlined, size: 14.0, color: scheme.primary),
                                const SizedBox(width: 8.0),
                                if (_storageType == 0)
                                  Text('기본 보관함', style: StyleConfigs.captionNormal)
                                else
                                  Text('공유 보관함', style: StyleConfigs.captionNormal),
                                const SizedBox(width: 4.0),
                                Icon(Icons.arrow_right_outlined, size: 14.0)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    TitleTextField(
                      controller: _titleEditor,
                      focusNode: _titleNode,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      style: StyleConfigs.bodyNormal,
                      icon: Icons.edit_calendar_rounded,
                      hintText: '제목',
                      maxLines: 1,
                    ),
                    TitleTextField(
                      controller: _descEditor,
                      focusNode: _descNode,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      style: StyleConfigs.bodyNormal,
                      hintText: '설명 (선택)',
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Ink(
              decoration: BoxDecoration(
                color: scheme.surface,
                border: Border(top: BorderSide(color: scheme.outline, width: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InlineButton(
                    onTap: () async {
                      TodoEditModel? res = await FormedBottomSheet.todoEditBottomSheet(
                          context: context, builder: (context) => DatePickBottomSheet(data: _todo));

                      if (mounted) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      }
                      if (res != null) {
                        setState(() {
                          _todo = res;
                          _startDate = res.startDate;
                          _endDate = res.endDate;
                          _endOfDay = res.isTimeSelected!;
                        });
                      }
                    },
                    icon: Icons.calendar_month_outlined,
                    title: Text('일시', style: StyleConfigs.bodyNormal),
                    suffix: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(mdFormatter(_startDate), style: StyleConfigs.bodyNormal.copyWith(color: scheme.primary)),
                        ),
                        _getTimeText(start: _startDate, end: _endDate),
                      ],
                    ),
                  ),
                  FormedWidgetComponent(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    prefix: const Icon(Icons.flag_outlined, size: 18.0),
                    title: Text('우선순위', style: StyleConfigs.bodyNormal),
                    suffix: AnimatedToggleSwitch<int>.size(
                      height: 38.0,
                      current: _priority,
                      values: const [0, 1, 2],
                      iconAnimationType: AnimationType.onHover,
                      selectedIconScale: 1.0,
                      onChanged: (value) {
                        setState(() {
                          _priority = value;
                        });
                      },
                      style: const ToggleStyle(
                        borderColor: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      styleBuilder: (value) => ToggleStyle(
                        borderColor: priorityColorBuilder(priority: value),
                        indicatorColor: priorityColorBuilder(priority: value).withOpacity(0.6),
                        indicatorBorderRadius: BorderRadius.zero,
                      ),
                      iconList: [
                        Text('낮음', style: StyleConfigs.captionMed),
                        Text('중간', style: StyleConfigs.captionMed),
                        Text('높음', style: StyleConfigs.captionMed),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomFilledButton(
                          onTap: () => Navigator.of(context).pop(),
                          color: scheme.surface,
                          padding: EdgeInsets.zero,
                          child: Text('취소', style: StyleConfigs.bodyNormal.copyWith(color: scheme.primary)),
                        ),
                        CustomFilledButton(
                          onTap: () async {
                            final todo = TodoReqDto(
                              title: _titleEditor.value.text.trim(),
                              desc: _descEditor.value.text.trim(),
                              priority: _priority,
                              state: 0,
                              startDate: _startDate,
                              endDate: _endDate,
                            );
                            await sqflite.createTodo(storageId: _defaultStorage, todo: todo);

                            if (mounted){
                              Navigator.of(context).pop();
                            }
                          },
                          color: scheme.surface,
                          padding: EdgeInsets.zero,
                          child: Text('생성', style: StyleConfigs.bodyNormal.copyWith(color: scheme.primary)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _getTimeText({required DateTime start, required DateTime end}) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    if (start.isDayStart && end.isDayStart) {
      return Text('(종일)', style: StyleConfigs.bodyNormal.copyWith(color: scheme.primary));
    } else if (start.isDayStart) {
      return Text('${hmFormatter(end)} 까지', style: StyleConfigs.bodyNormal.copyWith(color: scheme.primary));
    } else {
      return Row(
        children: [
          Text(hmFormatter(start), style: StyleConfigs.bodyNormal.copyWith(color: scheme.primary)),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.keyboard_double_arrow_right_sharp, size: 14.0),
          ),
          if (start.withoutTime != end.withoutTime)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(mdFormatter(end), style: StyleConfigs.bodyNormal.copyWith(color: scheme.primary)),
            ),
          Text(hmFormatter(end), style: StyleConfigs.bodyNormal.copyWith(color: scheme.primary)),
        ],
      );
    }
  }

  Widget _getIconButton({required void Function() onTap, required IconData icon}) {
    return Align(
      alignment: Alignment.center,
      child: Row(
        children: [
          Icon(icon, size: 18.0),
        ],
      ),
    );
  }
}
