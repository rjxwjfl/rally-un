import 'dart:io';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rally/configs/style_config.dart';
import 'package:rally/dto/schedule/schedule_resp_dto.dart';
import 'package:rally/util/datetime_convert.dart';

class ScheduleUi extends StatefulWidget {
  const ScheduleUi({required this.data, super.key});

  final ScheduleRespDto data;

  @override
  State<ScheduleUi> createState() => _ScheduleUiState();
}

class _ScheduleUiState extends State<ScheduleUi> {
  String formatSchedule(DateTime startDate, DateTime endDate) {
    DateTime now = DateTime.now();
    String result = '';

    if (startDate.isDayStart &&
        endDate.isDayStart &&
        endDate.isAtSameMomentAs(startDate.add(const Duration(days: 1)))) {
      result = '종일';
    }

    if (endDate.withoutTime == now.withoutTime) {}

    return result;
  }

  String formatCustomDate(DateTime date) {
    final String locale = Platform.localeName;
    final DateTime now = DateTime.now();
    bool sameYear = now.year == date.year;
    bool sameMonth = sameYear && now.month == date.month;

    if (sameMonth) {
      return DateFormat('d', locale).format(date);
    } else if (sameYear) {
      return DateFormat('MMM d', locale).format(date);
    } else {
      return DateFormat('yMMM d', locale).format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () {},
      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Ink(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.folder_shared_outlined, size: 16.0, color: scheme.outline),
                        const SizedBox(width: 4.0),
                        Text('Storage #1', style: StyleConfigs.captionNormal.copyWith(color: scheme.outline))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(widget.data.title,
                              style: StyleConfigs.leadMed.copyWith(color: scheme.primary),
                              overflow: TextOverflow.ellipsis),
                          if (widget.data.desc != null)
                            Text(widget.data.desc!,
                                style: StyleConfigs.bodyNormal.copyWith(color: scheme.outline),
                                overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 4.0),
                          child: Icon(Icons.repeat, size: 16.0),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 4.0),
                          child: Icon(Icons.notifications_active_outlined, size: 16.0),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              _timeIndicator(controlTime: DateTime.now(),start: widget.data.startDate, end: widget.data.endDate),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timeIndicator({required DateTime controlTime, required DateTime start, required DateTime end}) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    TextStyle defaultText = StyleConfigs.captionNormal.copyWith(color: scheme.secondary);

    // 일자만 지정된 상태
    if (start.isDayStart && end.isDayStart) {
      if (start.add(const Duration(days: 1))== end) {
        return Text('종일', style: defaultText);
      } else {
        return Row(
          children: [
            if (controlTime.isBefore(start))Text('aa${formatCustomDate(start)}', style: defaultText),
            if (controlTime.isAfter(start))Text('dd${formatCustomDate(end)}', style: defaultText)
          ],
        );
      }
    } else {
      // 정확한 시간이 지정된 상태
      // 시작일자가 오늘과 같은 경우, 지정된 시각과 현재를 비교하여 이전일 경우에는 표시하지 않는다.
      // 종료일자가 오늘과 같은 경우, 지정된 시각과 현재를 비교하여
      return Row(
        children: [
          // start
          if (controlTime.isBefore(start))Column(
            children: [
              if (controlTime.isBefore(start))Text(formatCustomDate(start), style: defaultText),
              if (controlTime.isAfter(start))Text(hmFormatter(start), style: defaultText),
            ],
          ),
          // end
          if (controlTime.isAfter(start))Column(
            children: [
              Text(formatCustomDate(end), style: defaultText),
              Text(hmFormatter(end), style: defaultText),
            ],
          )
        ],
      );
    }
  }
}
