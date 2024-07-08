import 'package:flutter/material.dart';
import 'package:rally/pages/schedule/schedule_view.dart';
import 'package:rally/go_router/root_router.dart';

class AppInit extends StatelessWidget {
  const AppInit({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(
      builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling), child: child!),
      title: 'Rally',
      scrollBehavior: ScrollGlowRemover(),
      debugShowCheckedModeBanner: false,
      routerConfig: rootRouter,
    );
  }
}

class ScrollGlowRemover extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details){
    return child;
  }
}