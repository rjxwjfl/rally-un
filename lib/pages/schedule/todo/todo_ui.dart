import 'package:flutter/material.dart';
import 'package:rally/configs/style_config.dart';
import 'package:rally/dto/schedule/todo/todo_resp_dto.dart';
import 'package:rally/pages/schedule/todo/todo_detail_bottom_sheet.dart';
import 'package:rally/util/data_converter.dart';
import 'package:rally/util/datetime_convert.dart';
import 'package:rally/util/todo_state.dart';
import 'package:rally/widget/bottom_sheet/schedule_todo_bottom_sheet.dart';
import 'package:rally/widget/indicator/user/author_user_indicator.dart';
import 'package:rally/widget/notification/notification_snack_bar.dart';

class TodoUi extends StatefulWidget {
  const TodoUi({required this.data, super.key});

  final TodoRespDto data;

  @override
  State<TodoUi> createState() => _TodoUiState();
}

class _TodoUiState extends State<TodoUi> {
  Future<void> _completeTodo() async {
    NotificationSnackBar snackBar = NotificationSnackBar(context);

    if (widget.data.state != 1) {
      return snackBar.notification(text: '일정을 완료했습니다.');
    }
    return;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 80.0),
      child: InkWell(
        onTap: () => FormedBottomSheet.flexibleBottomSheet(context: context, builder: (context, ctrl, offset) => TodoDetailBottomSheet(data: widget.data, controller: ctrl)),
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        child: Ink(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 내가 작성한 경우 작성자는 표시되지 않아야 한다.
                        if (widget.data.author.userId != 1)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: AuthorUserIndicator(data: widget.data.author),
                          ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              widget.data.title,
                              style: StyleConfigs.leadMed.copyWith(color: scheme.primary),
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (widget.data.desc != null)
                              Text(
                                widget.data.desc!,
                                overflow: TextOverflow.ellipsis,
                              ),
                            if (widget.data.setTimeFlag) getTimeIndicator(widget.data),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                InkWell(
                  onTap: () {
                    print(DateTime.now());
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  child: Ink(
                    decoration: BoxDecoration(
                        color: priorityColorBuilder(priority: widget.data.priority),
                        border: Border.all(color: Colors.white30),
                        shape: BoxShape.circle
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: stateIcon(state: widget.data.state, size: 24.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getTimeIndicator(TodoRespDto data) {
    TextStyle timeStyle = StyleConfigs.captionNormal.copyWith(color: Theme.of(context).colorScheme.error);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text('${todoTimeFormat(data.endDate)} 까지', style: timeStyle),
    );
  }
}
