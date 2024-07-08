import 'package:flutter/cupertino.dart';
import 'package:rally/pages/schedule/schedule_view.dart';
import 'package:rally/widget/custom_bottom_navigation_bar/components/navigation_item.dart';

List<Widget> viewList = [
  ScheduleView(),
];

List<NavigationItem> navigationItems = [
  NavigationItem(icon: Icon(CupertinoIcons.calendar_today)),
];