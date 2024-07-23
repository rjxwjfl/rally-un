import 'package:flutter/material.dart';
import 'package:rally/widget/custom_bottom_navigation_bar/components/navigation_item.dart';
import 'package:rally/widget/non_glow_inkwell.dart';

class NavigationComponent extends StatelessWidget {
  const NavigationComponent(
      {required this.onTap,
      required this.item,
      required this.isSelected,
      required this.activeColor,
      required this.inactiveColor,
      super.key});

  final VoidCallback onTap;
  final NavigationItem item;
  final bool isSelected;
  final IconThemeData activeColor;
  final IconThemeData inactiveColor;

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return NonGlowInkWell(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            height: 4.0,
            width: isSelected ? 25.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            decoration:
                BoxDecoration(color: scheme.secondary, borderRadius: const BorderRadius.all(Radius.circular(2.0))),
          ),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: IconTheme(
                  data: isSelected ? activeColor : inactiveColor,
                  child: item.icon!,
                ),
              ),
              if (item.notification != null)
                Positioned(
                  top: 4.0,
                  right: 4.0,
                  child: item.notification!,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
