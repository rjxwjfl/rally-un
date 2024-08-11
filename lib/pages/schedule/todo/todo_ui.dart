import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:rally/configs/style_config.dart';
import 'package:rally/dto/schedule/todo/internal_todo_resp_dto.dart';
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

  final InternalTodoRespDto data;

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
      constraints: const BoxConstraints(minHeight: 50.0),
      child: InkWell(
        onTap: () => FormedBottomSheet.flexibleBottomSheet(
            context: context, builder: (context, ctrl, offset) => TodoDetailBottomSheet(data: widget.data, controller: ctrl)),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: StyleConfigs.menuTitleFocus(color: priorityColorBuilder(priority: widget.data.priority), height: 50.0),
            ),
            // InkWell(
            //   onTap: () {
            //     print(DateTime.now());
            //   },
            //   borderRadius: const BorderRadius.all(Radius.circular(28.0)),
            //   child: Ink(
            //     decoration: BoxDecoration(
            //         color: priorityColorBuilder(priority: widget.data.priority),
            //         border: Border.all(color: Colors.white30),
            //         shape: BoxShape.circle
            //     ),
            //     child: stateIcon(state: widget.data.state, size: 14.0),
            //   ),
            // ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // // 내가 작성한 경우 작성자는 표시되지 않아야 한다.
                  // if (widget.data.author.userId != 1)
                  //   Padding(
                  //     padding: const EdgeInsets.only(bottom: 8.0),
                  //     child: AuthorUserIndicator(data: widget.data.author),
                  //   ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        widget.data.title,
                        style: widget.data.state == 1 ? StyleConfigs.leadBoldComplete : StyleConfigs.leadBold,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: scheme.primary), borderRadius: BorderRadius.all(Radius.circular(4.0))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: todoTimeIndicator(widget.data),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget todoTimeIndicator(InternalTodoRespDto data) {
    DateTime now = DateTime.now();
    TextStyle timeStyle = StyleConfigs.captionNormal;
    if (data.startDate.withoutTime == data.endDate.withoutTime ||
        data.startDate.add(const Duration(days: 1)) == data.endDate) {
      if (data.startDate.isDayStart && data.endDate.isDayStart) {
        return Text('종일', style: timeStyle);
      } else if (data.startDate.isDayStart) {
        return Text(todoTimeFormat(data.endDate), style: timeStyle);
      } else {
        return Row(
          children: [
            Text(todoTimeFormat(data.startDate), style: timeStyle),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Icon(Icons.more_horiz_rounded, size: 10.0),
            ),
            Text(todoTimeFormat(data.endDate), style: timeStyle),
          ],
        );
      }
    } else {
      return Row(
        children: [
          Text(todoTimeFormat(data.startDate), style: timeStyle),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Icon(Icons.more_horiz_rounded, size: 10.0),
          ),
          Text(todoTimeFormat(data.endDate), style: timeStyle),
        ],
      );
    }
  }
}
