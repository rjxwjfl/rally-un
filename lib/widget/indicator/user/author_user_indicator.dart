import 'package:flutter/material.dart';
import 'package:rally/configs/style_config.dart';
import 'package:rally/dto/user/todo_author.dart';
import 'package:rally/widget/indicator/user/user_image_indicator.dart';

class AuthorUserIndicator extends StatelessWidget {
  const AuthorUserIndicator({required this.data, super.key});

  final AuthorRespDto data;

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        UserImageIndicator(imageUrl: data.userImage),
        const SizedBox(width: 8.0),
        Text(
          data.displayName,
          style: StyleConfigs.captionNormal.copyWith(
            color: scheme.outline,
          ),
        ),
      ],
    );
  }
}
