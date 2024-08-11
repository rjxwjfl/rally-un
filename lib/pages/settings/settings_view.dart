import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rally/configs/style_config.dart';
import 'package:rally/main.dart';
import 'package:rally/pages/settings/application_info.dart';
import 'package:rally/state_manager/riverpod/theme_provider.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.background,
      ),
      body: Consumer(builder: (context, ref, _) {
        var themeRef = ref.watch(themeProvider);
        return Column(
          children: [
            getTitleUI(context: context, text: '애플리케이션 설정'),
            itemUI(context: context, text: '알림', icon: Icons.notifications_active_outlined, onTap: () {}),
            getBrightnessSwitch(context: context, themeRef: themeRef),
            getTitleUI(context: context, text: '기타'),
            itemUI(
              context: context,
              text: '애플리케이션 정보',
              icon: Icons.info_outline_rounded,
              onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const ApplicationInfo(),
                ),
              ),
            ),
            itemUI(context: context, text: '도움말', icon: Icons.help_outline_rounded, onTap: () {}),
            itemUI(
              context: context,
              isEnd: true,
              text: '로그아웃',
              icon: Icons.logout_rounded,
              onTap: () {},
              // () => _repository.googleSignOut(),
            ),
          ],
        );
      }),
    );
  }

  Widget getTitleUI({required BuildContext context, required String text}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 24.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: StyleConfigs.bodyNormal,
          ),
        ),
      ),
    );
  }

  Widget itemUI(
      {required BuildContext context,
      required String text,
      required IconData icon,
      required VoidCallback? onTap,
      bool isEnd = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: isEnd
                ? Border(
                    bottom: BorderSide(color: Theme.of(context).colorScheme.secondary),
                  )
                : null),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 24.0),
          child: Row(
            children: [
              Icon(icon, size: 18.0),
              const SizedBox(width: 15.0),
              Expanded(
                child: Text(
                  text,
                  style: StyleConfigs.bodyNormal,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14.0,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getBrightnessSwitch({required BuildContext context, required ThemeProvider themeRef}) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).colorScheme.secondary),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 8.0, 5.0, 8.0),
        child: Row(
          children: [
            const Icon(Icons.dark_mode_rounded, size: 18.0),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text('밝기', style: StyleConfigs.bodyNormal),
            ),
            AnimatedToggleSwitch.size(
              height: 40.0,
              indicatorSize: const Size.fromWidth(38.0),
              current: themeRef.modeToInt(themeRef.currentMode),
              values: const [0, 1, 2],
              onChanged: (value) {
                themeRef.switchThemeMode(value);
              },
              iconList: [
                Icon(Icons.light_mode, color: Colors.yellow.shade800, size: 18.0),
                Icon(Icons.dark_mode, color: Colors.blue.shade800, size: 18.0),
                Icon(Icons.brightness_auto_rounded, color: Colors.deepPurple.shade800, size: 18.0),
              ],
              borderWidth: 1.0,

            ),
          ],
        ),
      ),
    );
  }
}
