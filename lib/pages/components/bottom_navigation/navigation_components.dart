import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rally/configs/style_config.dart';
import 'package:rally/main.dart';
import 'package:rally/pages/daily/today_schedule_view.dart';
import 'package:rally/pages/schedule/schedule_view.dart';
import 'package:rally/pages/settings/settings_view.dart';
import 'package:rally/widget/custom_bottom_navigation_bar/components/navigation_item.dart';

List<Widget> viewList = [const TodayScheduleView(), const ScheduleView(), const SettingsView()];

List<NavigationItem> navigationItems = [
  NavigationItem(
    icon: Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
              left: BorderSide(width: 2.0, color: Theme.of(navigatorKey.currentContext!).colorScheme.outline),
              right: BorderSide(width: 2.0, color: Theme.of(navigatorKey.currentContext!).colorScheme.outline),
              bottom: BorderSide(width: 2.0, color: Theme.of(navigatorKey.currentContext!).colorScheme.outline),
              top: BorderSide(width: 5.0, color: Theme.of(navigatorKey.currentContext!).colorScheme.outline),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(4.0))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Text(
            '${DateTime.now().day}',
            style: StyleConfigs.notificationBadge.copyWith(color: Theme.of(navigatorKey.currentContext!).colorScheme.outline),
          ),
        ),
      ),
    ),
  ),
  NavigationItem(icon: const Icon(CupertinoIcons.calendar_today)),
  NavigationItem(icon: const Icon(CupertinoIcons.gear_alt)),
];
