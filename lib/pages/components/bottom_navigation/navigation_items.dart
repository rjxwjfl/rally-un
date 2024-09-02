import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rally/configs/style_config.dart';
import 'package:rally/main.dart';
import 'package:rally/pages/daily/today_schedule_view.dart';
import 'package:rally/pages/schedule/schedule_month_view.dart';
import 'package:rally/pages/schedule/schedule_view.dart';
import 'package:rally/pages/settings/settings_view.dart';
import 'package:rally/widget/custom_bottom_navigation_bar/components/navigation_item.dart';

List<Widget> viewList = [
  const TodayScheduleView(),
  const ScheduleView(),
  const ScheduleMonthView(),
  const SettingsView(),
];

List<NavigationItem> navigationItems = [
  NavigationItem(
    icon: Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: Container(
        constraints: const BoxConstraints(minWidth: 22.0),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(width: 1.5, color: Theme.of(navigatorKey.currentContext!).colorScheme.outline),
            right: BorderSide(width: 1.5, color: Theme.of(navigatorKey.currentContext!).colorScheme.outline),
            bottom: BorderSide(width: 1.5, color: Theme.of(navigatorKey.currentContext!).colorScheme.outline),
            top: BorderSide(width: 4.0, color: Theme.of(navigatorKey.currentContext!).colorScheme.outline),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Text(
            '${DateTime.now().day}',
            style: StyleConfigs.notificationBadge.copyWith(color: Theme.of(navigatorKey.currentContext!).colorScheme.outline),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
    activeIcon: Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: Container(
        constraints: const BoxConstraints(minWidth: 22.0),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(width: 1.5, color: Theme.of(navigatorKey.currentContext!).colorScheme.onSurface),
            right: BorderSide(width: 1.5, color: Theme.of(navigatorKey.currentContext!).colorScheme.onSurface),
            bottom: BorderSide(width: 1.5, color: Theme.of(navigatorKey.currentContext!).colorScheme.onSurface),
            top: BorderSide(width: 4.0, color: Theme.of(navigatorKey.currentContext!).colorScheme.onSurface),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Text(
            '${DateTime.now().day}',
            style: StyleConfigs.notificationBadge.copyWith(color: Theme.of(navigatorKey.currentContext!).colorScheme.outline),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
    label: '오늘'
  ),
  NavigationItem(icon: const Icon(CupertinoIcons.calendar_today), label: '달력'),
  NavigationItem(icon: const Icon(CupertinoIcons.calendar_today)),
  NavigationItem(icon: const Icon(CupertinoIcons.gear_alt)),
];
