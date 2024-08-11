import 'package:flutter/material.dart';
import 'package:rally/configs/style_config.dart';
import 'package:rally/dto/user/todo_author.dart';
import 'package:rally/util/datetime_convert.dart';
import 'package:rally/widget/indicator/user/user_image_indicator.dart';
import 'package:rally/widget/non_glow_inkwell.dart';

class PickUserIndicator extends StatelessWidget {
  const PickUserIndicator({required this.onTap, required this.userData, required this.isSelected, super.key});

  final void Function() onTap;
  final AuthorRespDto userData;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      child: Ink(
        decoration: BoxDecoration(
          color: isSelected ? scheme.outline.withOpacity(0.2) : Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Row(
            children: [
              UserImageIndicator(
                imageUrl: userData.userImage,
                imageSize: 36.0,
                borderColor: scheme.primary,
              ),
              const SizedBox(width: 12.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userData.displayName, style: StyleConfigs.bodyMed),
                  Text(updatedDateIndicator(userData.latestAccess), style: StyleConfigs.captionNormal.copyWith(color: scheme.outline)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
