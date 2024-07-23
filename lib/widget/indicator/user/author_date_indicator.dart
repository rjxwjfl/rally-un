import 'package:flutter/material.dart';
import 'package:rally/configs/style_config.dart';
import 'package:rally/dto/user/todo_author.dart';
import 'package:rally/util/datetime_convert.dart';
import 'package:rally/widget/indicator/user/user_image_indicator.dart';

class AuthorDateIndicator extends StatelessWidget {
  const AuthorDateIndicator({required this.data, required this.date, super.key});

  final AuthorRespDto data;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        UserImageIndicator(imageUrl: data.userImage, imageSize: 24.0,),
        const SizedBox(width: 8.0),
        Column(
          children: [
            Text(
              data.displayName,
              style: StyleConfigs.captionNormal.copyWith(
                color: scheme.outline,
              ),
            ),
            Text(defaultFormat(date))
          ],
        ),
      ],
    );
  }
}
