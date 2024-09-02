import 'package:flutter/material.dart';
import 'package:rally/widget/custom_bottom_navigation_bar/components/navigation_component.dart';
import 'package:rally/widget/custom_bottom_navigation_bar/components/navigation_item.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar(
      {required this.pageController,
        required this.items,
        this.elevation = 1.0,
        this.iconSize,
        this.activeIconSize,
        this.activeIconColor,
        this.inactiveIconColor,
        super.key});

  final PageController pageController;
  final List<NavigationItem> items;
  final double elevation;
  final double? iconSize;
  final double? activeIconSize;
  final Color? activeIconColor;
  final Color? inactiveIconColor;

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    IconThemeData defaultIconTheme = IconThemeData(
        size: widget.activeIconSize ?? widget.iconSize ?? 24.0, color: widget.activeIconColor ?? scheme.onSurface, opacity: 0.8);
    return Container(
      height: kToolbarHeight * 1.3,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: scheme.background,
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withOpacity(0.2),
            blurRadius: 24.0 * (widget.elevation * 0.1),
            spreadRadius: (widget.elevation * 0.1),
            offset: Offset(
              0.0,
              -2.0 * (widget.elevation * 0.1),
            ),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          widget.items.length,
              (index) => Expanded(
            child: NavigationComponent(
              onTap: () {
                setState(() {
                  _currentIndex = index;
                });
                widget.pageController.jumpToPage(index);
              },
              item: widget.items[index],
              isSelected: _currentIndex == index,
              activeColor: defaultIconTheme,
              inactiveColor: defaultIconTheme.copyWith(
                size: widget.iconSize ?? 24.0,
                color: widget.inactiveIconColor ?? scheme.outline,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
