import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rally/dto/schedule/todo/internal_todo_resp_dto.dart';
import 'package:rally/dto/schedule/todo/todo_resp_dto.dart';
import 'package:rally/main.dart';
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
          children: [
            Text('할 일(${_dataList.length})'),
            Divider(),
            StreamBuilder<List<InternalTodoRespDto>>(
              stream: sqflite.todayStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData){
                  sqflite.getTodayTodos();
                }

                List<InternalTodoRespDto> data = snapshot.data?? [];
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: data.length,
                  separatorBuilder: (context, index) => Divider(height: 0.0, thickness: 0.1),
                  itemBuilder: (context, index) => TodoUi(data: data[index]),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}
