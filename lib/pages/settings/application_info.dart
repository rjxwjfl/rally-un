import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rally/configs/style_config.dart';

class ApplicationInfo extends StatelessWidget {
  const ApplicationInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('애플리케이션 정보'),
      ),
      body: Column(
        children: [
          itemUI(text: '오픈소스 라이선스', onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => const LicensePage()))),
          itemUI(text: '개인정보 처리방침', onTap: (){}),
          itemUI(text: '이용 약관', onTap: (){}),
        ],
      ),
    );
  }

  Widget itemUI({required String text, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
          child: Row(
            children: [
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
}
