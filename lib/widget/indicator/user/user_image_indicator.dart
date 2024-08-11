import 'package:flutter/material.dart';
import 'package:rally/generated/assets.dart';

class UserImageIndicator extends StatelessWidget {
  const UserImageIndicator(
      {required this.imageUrl,
      this.imageSize = 18.0,
      this.borderThickness = 1.0,
      this.borderColor = Colors.transparent,
      super.key});

  final String? imageUrl;
  final double imageSize;
  final double borderThickness;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
      width: imageSize,
      height: imageSize,
      decoration: BoxDecoration(color: Colors.transparent, shape: BoxShape.circle, border: Border.all(color: borderColor, width: borderThickness)),
      child: Center(
        child: Container(
          width: imageSize,
          height: imageSize,
          decoration: BoxDecoration(
            color: scheme.outline.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: imageUrl != null
              ? ClipOval(child: Image.network(imageUrl!, fit: BoxFit.cover))
              : ClipOval(
                  child: Image.asset(Assets.imagesUserProfileIcon, color: scheme.outline, colorBlendMode: BlendMode.srcIn)),
        ),
      ),
    );
  }
}
