import 'package:flutter/material.dart';
import 'package:rally/configs/style_config.dart';
import 'package:rally/dto/schedule/todo/todo_resp_dto.dart';
import 'package:rally/util/data_converter.dart';
import 'package:rally/util/datetime_convert.dart';
import 'package:rally/widget/drag_handle.dart';
import 'package:rally/widget/indicator/priority_indicator.dart';
import 'package:rally/widget/indicator/user/author_user_indicator.dart';

class TodoDetailBottomSheet extends StatefulWidget {
  const TodoDetailBottomSheet({required this.data, super.key});

  final TodoRespDto data;

  @override
  State<TodoDetailBottomSheet> createState() => _TodoDetailBottomSheetState();
}

class _TodoDetailBottomSheetState extends State<TodoDetailBottomSheet> {
  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return DraggableScrollableSheet(
      expand: true,
      snap: true,
      initialChildSize: 1.0,
      maxChildSize: 1.0,
      builder: (context, controller) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const DragHandle(
              padding: EdgeInsets.symmetric(vertical: 12.0),
            ),
            if (widget.data.author.userId != 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: AuthorUserIndicator(
                        data: widget.data.author,
                      ),
                    ),
                    timeIndicator(widget.data)
                  ],
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            PriorityIndicator(priority: widget.data.priority, width: 24.0, height: 24.0, textGap: 12.0,),
                            Text(
                              widget.data.title,
                              style: StyleConfigs.leadMed.copyWith(color: scheme.primary),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (widget.data.desc != null)
                        Text(
                          widget.data.desc!,
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: InkWell(
                    onTap: () {
                      print(DateTime.now());
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    child: Ink(
                      decoration: BoxDecoration(
                        border: Border.all(color: scheme.outline, width: 0.2),
                        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: stateIcon(state: widget.data.state),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget timeIndicator(TodoRespDto data) {
    TextStyle timeStyle = StyleConfigs.captionNormal.copyWith(color: Theme.of(context).colorScheme.outline);
    String text = defaultFormat(data.updatedDate);
    if (data.createdDate != data.updatedDate) {
      text = '$text (수정됨)';
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(text, style: timeStyle),
    );
  }
}
