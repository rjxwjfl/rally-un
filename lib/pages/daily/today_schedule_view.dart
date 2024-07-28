import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rally/dto/schedule/todo/todo_resp_dto.dart';
import 'package:rally/pages/components/sample/todo_sample.dart';
import 'package:rally/pages/schedule/todo/todo_add_bottom_sheet.dart';
import 'package:rally/pages/schedule/todo/todo_ui.dart';
import 'package:rally/pages/settings/settings_view.dart';
import 'package:rally/widget/bottom_sheet/schedule_todo_bottom_sheet.dart';

class TodayScheduleView extends StatefulWidget {
  const TodayScheduleView({super.key});

  @override
  State<TodayScheduleView> createState() => _TodayScheduleViewState();
}

class _TodayScheduleViewState extends State<TodayScheduleView> {
  late List<TodoRespDto> _dataList;

  void _initialize() {
    DateTime now = DateTime.now();
    _dataList = SampleTodoData.sampleList
        .where((todo) =>
            todo.endDate.year == now.year && todo.endDate.month == now.month && todo.endDate.day == now.day ||
            todo.startDate.year == now.year && todo.startDate.month == now.month && todo.startDate.day == now.day)
        .toList();
    _dataList.sort((a, b) => a.state.compareTo(b.state));
  }

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: scheme.background,
        scrolledUnderElevation: 0.0,
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).push(CupertinoPageRoute(builder: (context) => const SettingsView())),
              icon: Icon(Icons.settings_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: _dataList.map((e) => TodoUi(data: e)).toList(),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Ink(
          height: kToolbarHeight,
          decoration: BoxDecoration(
            color: scheme.background,
            boxShadow: [
              BoxShadow(
                color: scheme.shadow.withOpacity(0.2),
                blurRadius: 2.4,
                spreadRadius: 0.1,
                offset: const Offset(0.0, -0.2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: InkWell(
              onTap: () => FormedBottomSheet.defaultBottomSheet(context: context, builder: (context) => const TodoAddBottomSheet()),
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              child: Ink(
                decoration: BoxDecoration(
                  border: Border.all(color: scheme.outline, width: 0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                  child: Row(
                    children: [
                      Icon(Icons.add, size: 20.0),
                      SizedBox(width: 4.0),
                      Text('새로운 할 일 추가'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
