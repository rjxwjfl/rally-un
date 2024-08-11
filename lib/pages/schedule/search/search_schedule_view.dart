import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rally/dto/schedule/todo/internal_todo_resp_dto.dart';
import 'package:rally/dto/schedule/todo/todo_resp_dto.dart';
import 'package:rally/main.dart';
import 'package:rally/pages/components/sample/todo_sample.dart';
import 'package:rally/pages/schedule/todo/todo_ui.dart';
import 'package:rally/pages/schedule/search/components/search_bar.dart';

class SearchScheduleView extends StatefulWidget {
  const SearchScheduleView({super.key});

  @override
  State<SearchScheduleView> createState() => _SearchScheduleViewState();
}

class _SearchScheduleViewState extends State<SearchScheduleView> {
  late final StreamController<List<InternalTodoRespDto>> _streamController;
  late final TextEditingController _controller;
  late final FocusNode _node;
  List<InternalTodoRespDto> _todoList = [];
  String? _keyword;

  void _setSearchKeyword(String keyword) {
    if (_keyword != keyword) {
      setState(() {
        _keyword = keyword;
      });
      // _fetchData(keyword);
    }
  }

  @override
  void initState() {
    _streamController = StreamController();
    _controller = TextEditingController();
    _node = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.background,
        title: SearchBarUI(
          controller: _controller,
          focusNode: _node,
          hintText: '일정 검색',
          onSubmit: (value) {
            if (value.isNotEmpty) {
              _setSearchKeyword(_controller.text.trim());
              sqflite.todoSearch(keyword: _keyword);
              FocusScope.of(context).unfocus();
            }
          },
          onRemove: () {
            _controller.clear();
            setState(() {
              _keyword = null;
            });
            sqflite.todoSearch(keyword: _keyword);
          },
        ),
      ),
      body: StreamBuilder<List<InternalTodoRespDto>>(
        stream: sqflite.searchStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('${SampleTodoData.sampleList.length}개의 일정이 있습니다.'));
          } else {
            return Column(
              children: [
                Expanded(
                  child: Scrollbar(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      physics: const ClampingScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final todo = snapshot.data![index];
                        return TodoUi(data: todo);
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
