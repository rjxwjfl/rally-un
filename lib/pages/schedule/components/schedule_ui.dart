import 'package:flutter/material.dart';
import 'package:rally/configs/style_config.dart';
import 'package:rally/dto/schedule/schedule_resp_dto.dart';
import 'package:rally/util/datetime_convert.dart';
import 'package:rally/util/todo_state.dart';
import 'package:rally/widget/indicator/user/author_user_indicator.dart';

class ScheduleUi extends StatefulWidget {
  const ScheduleUi({required this.data, super.key});

  final ScheduleRespDto data;

  @override
  State<ScheduleUi> createState() => _ScheduleUiState();
}

class _ScheduleUiState extends State<ScheduleUi> {
  Color _priorityColor({required int priority}) {
    const map = {
      0: Color(0xFFA5D6F3), // Low Priority (연한 그린)
      1: Color(0xFFFFE082), // Medium Priority (연한 노랑)
      2: Color(0xFFFF8A80) // High Priority (연한 빨강)
    };

    return map[priority]!;
  }

  Icon _stateIcon({required TodoState state}) {
    const map = {
      TodoState.pending: Icon(
        Icons.more_horiz_rounded,
        color: Colors.grey,
        size: 32.0,
      ),
      TodoState.complete: Icon(
        Icons.check,
        color: Colors.green,
        size: 32.0,
      )
    };
    return map[state]!;
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 80.0),
      child: InkWell(
        onTap: () {},
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        child: Ink(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Container(
                  width: 12.0,
                  height: 12.0,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                          ],
                        ),
                      ],
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

  Widget getTimeIndicator(ScheduleRespDto data) {
    TextStyle timeStyle = StyleConfigs.captionNormal.copyWith(color: Theme.of(context).colorScheme.error);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text('${todoTimeFormat(data.endDate!)} 까지', style: timeStyle),
    );
  }
}
