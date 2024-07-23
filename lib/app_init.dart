import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rally/configs/theme_data.dart';
import 'package:rally/go_router/root_router.dart';
import 'package:rally/main.dart';

class AppInit extends StatelessWidget {
  const AppInit({super.key});

  @override
  Widget build(BuildContext context) {

    return Consumer(
      builder: (context, ref, _) {
        return MaterialApp.router(
          builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling), child: child!),
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ref.watch(themeProvider).currentMode,
          title: 'Rally',
          scrollBehavior: ScrollGlowRemover(),
          debugShowCheckedModeBanner: false,
          routerConfig: rootRouter,
        );
      }
    );
  }
}

class ScrollGlowRemover extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details){
    return child;
  }
}