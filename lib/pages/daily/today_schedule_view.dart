import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rally/configs/style_config.dart';
import 'package:rally/dto/schedule/schedule_resp_dto.dart';
import 'package:rally/dto/schedule/todo/internal_todo_resp_dto.dart';
import 'package:rally/dto/schedule/todo/todo_resp_dto.dart';
import 'package:rally/main.dart';
import 'package:rally/pages/components/sample/todo_sample.dart';
import 'package:rally/pages/schedule/components/schedule_ui.dart';
import 'package:rally/pages/schedule/todo/todo_add_bottom_sheet.dart';
import 'package:rally/pages/schedule/todo/todo_ui.dart';
import 'package:rally/pages/settings/settings_view.dart';
import 'package:rally/util/datetime_convert.dart';
import 'package:rally/widget/bottom_sheet/schedule_todo_bottom_sheet.dart';

class TodayScheduleView extends StatefulWidget {
  const TodayScheduleView({super.key});

  @override
  State<TodayScheduleView> createState() => _TodayScheduleViewState();
}

class _TodayScheduleViewState extends State<TodayScheduleView> {
  late List<ScheduleRespDto> _schedule;
  late List<TodoRespDto> _todo;

  void _scheduleFilter() {
    DateTime now = DateTime.now();
    _schedule = SampleTodoData.scheduleList
        .where((sch) =>
            sch.endDate.year == now.year && sch.endDate.month == now.month && sch.endDate.day == now.day ||
            sch.startDate.year == now.year && sch.startDate.month == now.month && sch.startDate.day == now.day ||
            (now.isAfter(sch.startDate) && now.isBefore(sch.endDate)))
        .toList();
    _schedule.sort((a, b) => a.startDate.compareTo(b.startDate));
  }

  void _todoFilter() {
    DateTime now = DateTime.now();
    _todo = SampleTodoData.sampleList
        .where((todo) =>
            todo.endDate.year == now.year && todo.endDate.month == now.month && todo.endDate.day == now.day ||
            todo.startDate.year == now.year && todo.startDate.month == now.month && todo.startDate.day == now.day ||
            (now.isAfter(todo.startDate) && now.isBefore(todo.endDate)))
        .toList();
    _todo.sort((a, b) => a.state.compareTo(b.state));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: scheme.surface,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        title: Text(
          mdwFormatter(DateTime.now()),
          style: StyleConfigs.titleBold,
        ),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.of(context).push(CupertinoPageRoute(builder: (context) => const SettingsView())),
              icon: const Icon(Icons.settings_outlined)),
          IconButton(
              onPressed: () =>
                  Navigator.of(context).push(CupertinoPageRoute(builder: (context) => const SettingsView())),
              icon: const Icon(Icons.settings_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        child: Scrollbar(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 일정이 존재하지 않는 경우 표시되지 않는다.
              // TODO :: 일반 일정, 공유 일정 UI, 2개의 정형화된 높이 (공유자 정보)
              StreamBuilder(
                stream: null,
                builder: (context, snapshot) {
                  if (!snapshot.hasData){
                    _scheduleFilter();
                  }
                  return _groupedWidget(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                      child: Row(
                        children: [
                          Text('일정', style: StyleConfigs.leadMed.copyWith(color: scheme.onSurface)),
                          SizedBox(width: 8.0),
                          Text('${SampleTodoData.scheduleList.length}',
                              style: StyleConfigs.bodyNormal.copyWith(color: scheme.outline)),
                        ],
                      ),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: _schedule.length,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => Divider(
                        height: 2.0,
                        color: scheme.outline.withOpacity(0.1),
                      ),
                      itemBuilder: (context, index) => ScheduleUi(data: _schedule[index]),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32.0),
              // 할 일이 존재하지 않는 경우 표시되지 않는다.
              // TODO :: 일반 및 공유된 할 일 UI, 2개의 정형화된 높이 (공유자 정보)
              StreamBuilder<List<InternalTodoRespDto>>(
                  stream: sqflite.todayStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      sqflite.getTodayTodos();
                      _todoFilter();
                    }

                    List<InternalTodoRespDto> data = snapshot.data ?? [];
                    return _groupedWidget(
                      title: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                        child: Row(
                          children: [
                            Text('일정', style: StyleConfigs.leadMed.copyWith(color: scheme.onSurface)),
                            SizedBox(width: 8.0),
                            Text('${_todo.length}', style: StyleConfigs.bodyNormal.copyWith(color: scheme.outline)),
                          ],
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: data.length,
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder: (context, index) => const Divider(height: 0.0, thickness: 0.1),
                            itemBuilder: (context, index) => TodoUi(data: data[index]),
                          ),
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => FormedBottomSheet.defaultBottomSheet(
          context: context,
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _getActionButton(onTap: () {}, icon: Icons.edit_outlined, text: '메모'),
              _getActionButton(
                onTap: () {
                  Navigator.of(context).pop();
                  FormedBottomSheet.defaultBottomSheet(
                      context: context, builder: (context) => TodoAddBottomSheet(selectedDate: DateTime.now()));
                },
                icon: Icons.add_task_outlined,
                text: '할 일',
              ),
              _getActionButton(onTap: () {}, icon: Icons.edit_calendar_outlined, text: '일정'),
            ],
          ),
        ),
        mini: true,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _groupedWidget({required Widget title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [title, const SizedBox(height: 4.0), child],
    );
  }

  Widget _getActionButton({required void Function() onTap, required IconData icon, required String text}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: StyleConfigs.bodyNormal),
          ],
        ),
      ),
    );
  }
}
