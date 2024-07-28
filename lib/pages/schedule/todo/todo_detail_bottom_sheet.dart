import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rally/configs/style_config.dart';
import 'package:rally/dto/schedule/todo/todo_resp_dto.dart';
import 'package:rally/util/data_converter.dart';
import 'package:rally/util/datetime_convert.dart';
import 'package:rally/util/todo_state.dart';
import 'package:rally/widget/drag_handle.dart';
import 'package:rally/widget/flexible_text_box.dart';
import 'package:rally/widget/icon_text_box.dart';
import 'package:rally/widget/lead_widget_text_box.dart';
import 'package:rally/widget/text_field/title_text_field.dart';

class TodoDetailBottomSheet extends StatefulWidget {
  const TodoDetailBottomSheet({required this.data, required this.controller, super.key});

  final TodoRespDto data;
  final ScrollController controller;

  @override
  State<TodoDetailBottomSheet> createState() => _TodoDetailBottomSheetState();
}

class _TodoDetailBottomSheetState extends State<TodoDetailBottomSheet> {
  late final TextEditingController _titleEditor;
  late final TextEditingController _descEditor;
  late final TextEditingController _commentEditor;
  late final FocusNode _titleNode;
  late final FocusNode _descNode;
  late final FocusNode _commentNode;

  String? validator(String? text) {
    if (text == null || text.isEmpty) {
      return '내용을 입력해주세요.';
    }
    return null;
  }

  @override
  void initState() {
    _titleEditor = TextEditingController(text: widget.data.title);
    _descEditor = TextEditingController(text: widget.data.desc ?? '상세 설명이 없습니다.');
    _commentEditor = TextEditingController();
    _titleNode = FocusNode();
    _descNode = FocusNode();
    _commentNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    TextStyle timeStyle = StyleConfigs.captionNormal.copyWith(color: Theme.of(context).colorScheme.outline);
    String text = ymdFormatter(widget.data.updatedDate);
    if (widget.data.createdDate != widget.data.updatedDate) {
      text = '$text (수정됨)';
    }
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        controller: widget.controller,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            const DragHandle(
              padding: EdgeInsets.only(bottom: 12.0),
            ),
            LeadWidgetTextBox(
              text: widget.data.state == TodoState.complete
                  ? '완료 (${ymdFormatter(DateTime.now())})'
                  : '${todoTimeFormat(widget.data.endDate)} 까지',
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              widget: InkWell(
                onTap: () {
                  print(DateTime.now());
                },
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                child: Container(
                  decoration: BoxDecoration(
                    color: priorityColorBuilder(priority: widget.data.priority),
                    border: Border.all(color: Colors.white30),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: stateIcon(state: widget.data.state, size: 18.0),
                  ),
                ),
              ),
            ),
            // 작성자가 본인일 경우 편집이 가능해야함.
            if (widget.data.author.userId == 1)
              Column(
                children: [
                  TitleTextField(
                    controller: _titleEditor,
                    focusNode: _titleNode,
                    hintText: '제목',
                    icon: Icons.edit_calendar_rounded,
                    style: StyleConfigs.leadNormal.copyWith(color: scheme.primary),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  TitleTextField(
                    controller: _descEditor,
                    focusNode: _descNode,
                    hintText: '세부 설명 (선택)',
                    style: StyleConfigs.bodyNormal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                ],
              )
            else
              // 본인이 아닐 경우 읽기 전용
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  IconTextBox(
                    text: widget.data.title,
                    icon: Icons.edit_calendar_rounded,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    style: StyleConfigs.leadMed.copyWith(color: scheme.primary),
                  ),
                  if (widget.data.desc != null)
                    FlexibleTextBox(
                      text: widget.data.desc!,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    )
                ],
              ),
            if (widget.data.author.userId != 1)
              IconTextBox(
                text: widget.data.author.displayName,
                icon: Icons.person_pin_outlined,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
            // FormedWidgetComponent(
            //   title: Text('하위 일정 추가', style: StyleConfigs.bodyMed),
            //   suffix: IconButton(onPressed: () {}, icon: const Icon(Icons.add, size: 18.0)),
            //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
            // ),
            Divider(thickness: 8.0, color: scheme.outline.withOpacity(0.1)),
            const IconTextBox(
              icon: CupertinoIcons.chat_bubble_text,
              text: '코멘트 (0)',
              padding: EdgeInsets.symmetric(horizontal: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
