import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rally/configs/style_config.dart';
import 'package:rally/dto/user/todo_author.dart';
import 'package:rally/pages/components/sample/todo_sample.dart';
import 'package:rally/pages/schedule/search/components/search_bar.dart';
import 'package:rally/widget/buttons/default_button.dart';
import 'package:rally/widget/indicator/user/author_user_indicator.dart';
import 'package:rally/widget/indicator/user/pick_user_indicator.dart';

class SharingDialog extends StatefulWidget {
  const SharingDialog({this.pickedList, super.key});

  final List<AuthorRespDto>? pickedList;

  @override
  State<SharingDialog> createState() => _SharingDialogState();
}

class _SharingDialogState extends State<SharingDialog> {
  late final TextEditingController _textEditController;
  late final FocusNode _focusNode;
  List<AuthorRespDto> _sampleUsers = [author1st, author2nd, author3rd];
  late List<AuthorRespDto> _init;
  late List<AuthorRespDto> _list;
  late List<AuthorRespDto> _res;
  String? _keyword;

  bool _dataExist(AuthorRespDto user) {
    return _res.any((element) => element.userId == user.userId);
  }

  void _setSearchKeyword(String keyword) {
    if (_keyword != keyword) {
      setState(() {
        _keyword = keyword;
        _updateUserList();
      });
    }
  }

  void _removeKeyword() {
    _textEditController.clear();
    setState(() {
      _keyword = null;
      _updateUserList();
    });
  }

  void _updateUserList() {
    if (_keyword == null || _keyword!.isEmpty) {
      _list = List.from(_init);
    } else {
      _list = _init.where((user) => user.displayName.toLowerCase().contains(_keyword!.toLowerCase())).toList();
    }
  }

  void _onSelect(AuthorRespDto data) {
    if (_res.any((element) => element.userId == data.userId)) {
      _res.removeWhere((element) => element.userId == data.userId);
    } else {
      _res.add(data);
    }
    _res.sort((a, b) => a.displayName.compareTo(b.displayName));
    _removeKeyword();
  }

  void _onRemove(AuthorRespDto data) {
    _res.removeWhere((element) => element.userId == data.userId);
  }

  // 초기화 시 나의 팔로워, 팔로잉 유저 데이터를 불러온다.
  @override
  void initState() {
    _textEditController = TextEditingController();
    _focusNode = FocusNode();
    _init = _sampleUsers;
    _updateUserList();
    _res = widget.pickedList ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SearchBarUI(
              controller: _textEditController,
              focusNode: _focusNode,
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              hintText: '검색할 사용자 이름',
              onChanged: _setSearchKeyword,
              onRemove: _removeKeyword,
            ),
            if (_res.isNotEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 25.0),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _res.length,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    separatorBuilder: (context, index) => SizedBox(width: 4.0),
                    itemBuilder: (context, index) => _selectedUserUI(
                      onTap: () => setState(() {
                        _onRemove(_res[index]);

                      }),
                      user: _res[index],
                    ),
                  ),
                ),
              ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: Scrollbar(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _list.length,
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                  separatorBuilder: (context, index) => SizedBox(height: 1.0),
                  itemBuilder: (context, index) => PickUserIndicator(
                    onTap: () => _onSelect(_init[index]),
                    userData: _init[index],
                    isSelected: _dataExist(_init[index]),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomFilledButton(
                    onTap: () => Navigator.of(context).pop(),
                    color: scheme.background,
                    padding: EdgeInsets.zero,
                    child: Text(
                      '취소',
                      style: StyleConfigs.bodyNormal.copyWith(color: scheme.primary),
                    ),
                  ),
                  CustomFilledButton(
                    onTap: () => Navigator.of(context).pop(_res),
                    color: scheme.background,
                    padding: EdgeInsets.zero,
                    child: Text(
                      '추가',
                      style: StyleConfigs.bodyNormal.copyWith(color: scheme.primary),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _selectedUserUI({required void Function() onTap, required AuthorRespDto user}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      child: Ink(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer, borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Row(
            children: [
              Text(
                user.displayName,
                style: StyleConfigs.captionNormal,
              ),
              SizedBox(width: 4.0),
              const Icon(
                CupertinoIcons.xmark,
                size: 14.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
