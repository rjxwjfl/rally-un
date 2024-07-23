
import 'package:flutter/material.dart';
import 'package:rally/configs/style_config.dart';
import 'package:rally/dto/user/user_data_resp_dto.dart';
import 'package:rally/pages/schedule/todo/components/user_select_ui.dart';
import 'package:rally/pages/schedule/search/components/search_bar.dart';
import 'package:rally/widget/indicator/animated_progress_indicator.dart';
import 'package:rally/widget/non_glow_inkwell.dart';

class TodoUserAddView extends StatefulWidget {
  const TodoUserAddView({required this.pickedUserList, super.key});

  final List<UserDataRespDto> pickedUserList;

  @override
  State<TodoUserAddView> createState() => _TodoUserAddViewState();
}

class _TodoUserAddViewState extends State<TodoUserAddView> {
  late final List<UserDataRespDto> _initialData = widget.pickedUserList;
  late List<UserDataRespDto> _userList;
  late List<UserDataRespDto> _resultData;
  late final TextEditingController _controller;
  late FocusNode _node;
  String? _searchKeyword;

  bool _dataExist(UserDataRespDto user) {
    return _resultData.any((element) => element.userId == user.userId);
  }

  void _setSearchKeyword(String keyword) {
    if (_searchKeyword != keyword) {
      setState(() {
        _searchKeyword = keyword;
        _updateUserList();
      });
    }
  }

  void _removeKeyword() {
    _controller.clear();
    setState(() {
      _searchKeyword = null;
      _updateUserList();
    });
  }

  void _updateUserList() {
    if (_searchKeyword == null || _searchKeyword!.isEmpty) {
      _userList = List.from(_initialData);
    } else {
      _userList =
          _initialData.where((user) => user.displayName.toLowerCase().contains(_searchKeyword!.toLowerCase())).toList();
    }
  }

  void _onSelect(UserDataRespDto data) {
    if (_resultData.any((element) => element.userId == data.userId)) {
      _resultData.removeWhere((element) => element.userId == data.userId);
    } else {
      _resultData.add(data);
    }
    _resultData.sort((a, b) => a.displayName.compareTo(b.displayName));
    _removeKeyword();
  }

  void _onRemove(UserDataRespDto data) {
    _resultData.removeWhere((element) => element.userId == data.userId);
  }

  @override
  void initState() {
    _controller = TextEditingController();
    _node = FocusNode();
    _updateUserList();
    _resultData = List.from(widget.pickedUserList);
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
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<List<UserDataRespDto>>(
        stream: null,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const AnimatedProgressIndicator();
          }

          List<UserDataRespDto> list = snapshot.data!;

          return NonGlowInkWell(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text('인원 배정', style: StyleConfigs.subtitleBold)),
                      TextButton(onPressed: () => Navigator.pop(context, _resultData), child: const Text('적용'))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: SearchBarUI(
                      controller: _controller,
                      focusNode: _node,
                      hintText: '일정 검색',
                      onChanged: _setSearchKeyword,
                      onRemove: _removeKeyword
                    ),
                    // SearchInputField(
                    //   controller: _searchController,
                    //   focusNode: _searchFocus,
                    //   hintText: '이름으로 검색',
                    //   onChange: _setSearchKeyword,
                    //   onRemove: _removeKeyword,
                    // ),
                  ),
                  SizedBox(
                    height: size.height * 0.4,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: list.length,
                      padding: const EdgeInsets.only(top: 5.0, bottom: kToolbarHeight),
                      separatorBuilder: (context, index) => const SizedBox(height: 5.0),
                      itemBuilder: (context, index) {
                        UserDataRespDto user = list[index];
                        return UserSelectUI(
                          data: user,
                          onPressAdd: () => _onSelect(user),
                          isExist: _dataExist(user),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
