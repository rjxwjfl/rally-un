import 'package:flutter/material.dart';
import 'package:rally/widget/non_glow_inkwell.dart';

class WeekdaySelectIndicator extends StatelessWidget {
  const WeekdaySelectIndicator({required this.index, required this.isSelected, required this.onTap, super.key});

  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    const map = {0: '월', 1: '화', 2: '수', 3: '목', 4: '금', 5: '토', 6: '일'};
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: NonGlowInkWell(
        onTap: onTap,
        child: Container(
          height: 35.0,
          width: 35.0,
          decoration: BoxDecoration(color: isSelected ? scheme.primary : scheme.outline, shape: BoxShape.circle, boxShadow: [
            BoxShadow(color: scheme.shadow.withOpacity(0.3), spreadRadius: 0.0, blurRadius: 2.0, offset: const Offset(0, 2.0))
          ]),
          child: Center(
            child: Text(
              map[index]!,
              style: TextStyle(color: isSelected ? scheme.onPrimary : scheme.onSurface),
            ),
          ),
        ),
      ),
    );
  }
}
