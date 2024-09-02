import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rally/configs/style_config.dart';
import 'package:rally/main.dart';
import 'package:rally/pages/components/bottom_navigation/navigation_items.dart';
import 'package:rally/pages/schedule/todo/todo_add_bottom_sheet.dart';
import 'package:rally/widget/bottom_sheet/schedule_todo_bottom_sheet.dart';
import 'package:rally/widget/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';

class NaviHome extends StatefulWidget {
  const NaviHome({super.key});

  @override
  State<NaviHome> createState() => _NaviHomeState();
}

class _NaviHomeState extends State<NaviHome> {
  late final PageController _pageController;
  late int _currentIndex;
  late final List<Widget> _actionButtonItems;

  Future<bool> _onWillPop(BuildContext context) async {
    bool? res = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
        content: Text('# Teminate message'),
        contentTextStyle: StyleConfigs.bodyNormal,
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'),
          ),
        ],
      ),
    );

    if (res != null && res) {
      return true;
    }

    return false;
  }

  void _pageRouter(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(_currentIndex);
  }

  @override
  void initState() {
    _currentIndex = 0;
    _pageController = PageController(initialPage: _currentIndex);
    _actionButtonItems = [];
    sqflite.initStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme
        .of(context)
        .colorScheme;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final NavigatorState navigatorState = Navigator.of(context);
        final bool res = await _onWillPop(context);
        if (res) {
          if (navigatorState.canPop()) {
            navigatorState.maybePop();
          } else {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: viewList,
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          elevation: 2.0,
          iconSize: 24.0,
          pageController: _pageController,
          items: navigationItems,
        ),
      ),
    );
  }
}
