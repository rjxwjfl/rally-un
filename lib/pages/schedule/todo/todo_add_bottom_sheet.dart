import 'package:flutter/material.dart';
import 'package:rally/configs/style_config.dart';
import 'package:rally/util/datetime_convert.dart';
import 'package:rally/widget/bottom_sheet_item_button.dart';
import 'package:rally/widget/buttons/default_button.dart';
import 'package:rally/widget/drag_handle.dart';
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
  late DateTime _startDate;
  late DateTime _endDate;
  int _priority = 1;

  List<BottomIcon> _icons = [
    BottomIcon(onTap: () {}, icon: Icons.image_outlined),
    BottomIcon(onTap: () {}, icon: Icons.map_outlined),
  ];

  void _initTime() {
    DateTime now = DateTime.now();
    if (widget.selectedDate != null) {
      _startDate = widget.selectedDate!;
      _endDate = DateTime(widget.selectedDate!.year, widget.selectedDate!.month, widget.selectedDate!.day, 23, 59, 59);
    } else {
      _startDate = now;
      _endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    }
  }

  @override
  void initState() {
    _titleEditor = TextEditingController();
    _descEditor = TextEditingController();
    _titleNode = FocusNode();
    _descNode = FocusNode();
    _initTime();
    _titleNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: kToolbarHeight * 2),
                child: Scrollbar(
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const DragHandle(),
                        TitleTextField(
                          controller: _titleEditor,
                          focusNode: _titleNode,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          style: StyleConfigs.bodyNormal,
                          icon: Icons.edit_calendar_rounded,
                          hintText: '작업 제목',
                          maxLines: 1,
                        ),
                        TitleTextField(
                          controller: _descEditor,
                          focusNode: _descNode,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          style: StyleConfigs.bodyNormal,
                          hintText: '상세 설명 (선택)',
                        ),
                        // FormedWidgetComponent(
                        //   prefix: const Icon(Icons.repeat, size: 18.0),
                        //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        //   title: NonGlowInkWell(
                        //     onTap: () {
                        //       FocusScope.of(context).requestFocus(FocusNode());
                        //       FormedBottomSheet.snappingBottomSheet(
                        //           context: context, builder: (context) => DatePickBottomSheet(date: _startDate));
                        //     },
                        //     child: Text('없음'),
                        //   ),
                        // ),
                        // FormedWidgetComponent(
                        //   prefix: const Icon(Icons.priority_high_rounded, size: 18.0),
                        //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        //   title: const Text('중요도'),
                        //   suffix: AnimatedToggleSwitch<int>.size(
                        //     height: 35.0,
                        //     current: _priority,
                        //     values: const [0, 1, 2],
                        //     iconAnimationType: AnimationType.onHover,
                        //     selectedIconScale: 1.0,
                        //     onChanged: (value) {
                        //       setState(() {
                        //         _priority = value;
                        //       });
                        //     },
                        //     style: ToggleStyle(
                        //         backgroundColor: scheme.surfaceVariant,
                        //         borderColor: Colors.transparent,
                        //         borderRadius: const BorderRadius.all(Radius.circular(5.0))),
                        //     styleBuilder: (value) => ToggleStyle(
                        //         borderColor: priorityColorBuilder(priority: value),
                        //         indicatorColor: priorityColorBuilder(priority: value).withOpacity(0.5),
                        //         indicatorBorderRadius: BorderRadius.zero),
                        //     iconList: const [
                        //       Text('낮음'),
                        //       Text('일반'),
                        //       Text('높음'),
                        //     ],
                        //   ),
                        // ),
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
                  height: kToolbarHeight * 2,
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: scheme.shadow.withOpacity(0.2),
                        blurRadius: 2.4,
                        spreadRadius: 0.5,
                        offset: const Offset(0.0, -0.2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: kToolbarHeight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              BottomSheetItemButton(onTap: () async {
                                FocusScope.of(context).requestFocus(FocusNode());
                                DateTime? date = await showDatePicker(
                                  context: context,
                                  initialDate: _startDate,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100, 12, 31),
                                );

                                TimeOfDay? sTime =
                                await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(DateTime.now()));

                                if (date != null) {
                                  var start = DateTime(date.year, date.month, date.day, _startDate.hour, _startDate.minute);
                                  if (sTime != null) {
                                    start = start.copyWith(hour: sTime.hour, minute: sTime.minute);
                                  }
                                  setState(() {
                                    _startDate = start;
                                    if (_endDate.isBefore(_startDate)) {
                                      _endDate = start.copyWith(
                                        hour: _endDate.hour,
                                        minute: _endDate.minute,
                                      );
                                    }
                                  });
                                }
                              }, icon: Icons.calendar_month_outlined, text: ymdFormatter(_startDate),),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: kToolbarHeight,
                        child: Row(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: _icons.length,
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                separatorBuilder: (context, index) => const SizedBox(width: 4.0),
                                itemBuilder: (context, index) => _getIconButton(model: _icons[index]),
                              ),
                            ),
                            DefaultButton(onTap: () {}, child: Text('생성'))
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
    );
  }

  Widget _getIconButton({required BottomIcon model}) {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: model.onTap,
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(model.icon, size: 18.0),
        ),
      ),
    );
  }
}

class BottomIcon {
  VoidCallback onTap;
  IconData icon;

  BottomIcon({
    required this.onTap,
    required this.icon,
  });
}
