import 'package:flutter/cupertino.dart';
import 'package:rally/pages/schedule/schedule_view.dart';
import 'package:rally/pages/settings/settings_view.dart';
import 'package:rally/widget/custom_bottom_navigation_bar/components/navigation_item.dart';

List<Widget> viewList = [
  ScheduleView(),
  SettingsView()
];

List<NavigationItem> navigationItems = [
  NavigationItem(icon: Icon(CupertinoIcons.calendar_today)),
  NavigationItem(icon: Icon(CupertinoIcons.gear_alt)),
];