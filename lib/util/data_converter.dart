import 'package:flutter/material.dart';
import 'package:rally/util/todo_state.dart';

bool intToBool (int val){
  const map = {0: false, 1: true};
  return map[val]!;
}

int boolToInt (bool flag){
  const map = {false: 0, true: 1};
  return map[flag]!;
}

Color priorityColorBuilder({required int priority}) {
  const map = {
    0: Color(0xFF3191D9), // Low Priority (연한 그린)
    1: Color(0xFFEFA018), // Medium Priority (연한 노랑)
    2: Color(0xFFE8645A) // High Priority (연한 빨강)
  };

  return map[priority]!;
}

Icon stateIcon({required int state, double? size}) {
  var map = {
    0: Icon(
      Icons.more_horiz_rounded,
      color: Colors.black87,
      size: size ?? 32.0,
    ),
    1: Icon(
      Icons.check,
      color: Colors.black87,
      size: size ?? 32.0,
    )
  };
  return map[state]!;
}