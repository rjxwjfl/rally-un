
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rally/configs/style_config.dart';
import 'package:rally/widget/indicator/user/user_image_indicator.dart';

class HorizontalUserIndicator extends StatelessWidget {
  const HorizontalUserIndicator({this.imageUrl, required this.displayName, required this.checkInfo, required this.onRemove, super.key});

  final String? imageUrl;
  final String displayName;
  final Future<void> Function() checkInfo;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    TextStyle style = StyleConfigs.captionNormal;
    return Row(
      children: [
        UserImageIndicator(imageUrl: imageUrl, imageSize: 32.0,),
        const SizedBox(width: 15.0),
        Text(displayName, style: style, maxLines: 1, overflow: TextOverflow.ellipsis),
        const Expanded(child: SizedBox()),
        IconButton(onPressed: checkInfo, icon: Icon(CupertinoIcons.info_circle, size: 18.0, color: Theme.of(context).colorScheme.outline.withOpacity(0.8))),
        IconButton(onPressed: onRemove, icon: const Icon(CupertinoIcons.xmark, size: 18.0, color: Colors.red,)),
      ],
    );
  }
}
