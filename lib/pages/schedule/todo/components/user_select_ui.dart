
import 'package:flutter/material.dart';
import 'package:rally/dto/user/user_data_resp_dto.dart';
import 'package:rally/widget/indicator/user/user_image_indicator.dart';
import 'package:rally/widget/non_glow_inkwell.dart';

class UserSelectUI extends StatelessWidget {
  const UserSelectUI({required this.data, required this.onPressAdd, required this.isExist, super.key});

  final UserDataRespDto data;
  final VoidCallback onPressAdd;
  final bool isExist;

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return NonGlowInkWell(
      onTap: onPressAdd,
      child: Container(
        decoration: BoxDecoration(
            color: isExist ? scheme.primary.withOpacity(0.1) : Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(10.0))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          child: Row(
            children: [
              UserImageIndicator(
                imageUrl: data.imageUrl,
                imageSize: 28.0,
              ),
              const SizedBox(width: 15.0),
              Text(data.displayName),
              const Expanded(child: SizedBox()),
              isExist
                  ? const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
              )
                  : Icon(
                Icons.circle_outlined,
                color: scheme.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
