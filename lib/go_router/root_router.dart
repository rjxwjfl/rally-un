import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:rally/main.dart';
import 'package:rally/pages/daily/today_schedule_view.dart';
import 'package:rally/pages/navi_home.dart';

final GoRouter rootRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const TodayScheduleView(),
      routes: [],
    ),
  ],
);
