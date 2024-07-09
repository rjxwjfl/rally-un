import 'package:flutter/material.dart';
import 'package:rally/dto/schedule/todo/todo_resp_dto.dart';
import 'package:rally/util/todo_state.dart';
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

    if (widget.data.state != TodoState.complete) {
        return snackBar.notification(text: '일정을 완료했습니다.');
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            getTimeIndicator(widget.data),
            const SizedBox(width: 16.0),
          ],
        ),
      ),
    );
  }

  Widget getTimeIndicator(TodoRespDto data) {
    return SizedBox(
      width: 65.0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(Icons.alarm_on_outlined, size: 18.0, color: Theme.of(context).colorScheme.outline),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(int priority) {
    const map = {
      0: Color(0xff4fb4f5),
      1: Color(0xffe8b729),
      2: Color(0xffbe3e3e),
    };
    return map[priority]!;
  }
}
