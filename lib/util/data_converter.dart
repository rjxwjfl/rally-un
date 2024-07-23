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

Color priorityColor({required int priority}) {
  const map = {
    0: Color(0xFFA5D6F3), // Low Priority (연한 그린)
    1: Color(0xFFFFE082), // Medium Priority (연한 노랑)
    2: Color(0xFFFF8A80) // High Priority (연한 빨강)
  };

  return map[priority]!;
}

Icon stateIcon({required TodoState state}) {
  const map = {
    TodoState.pending: Icon(
      Icons.more_horiz_rounded,
      color: Colors.grey,
      size: 32.0,
    ),
    TodoState.complete: Icon(
      Icons.check,
      color: Colors.green,
      size: 32.0,
    )
  };
  return map[state]!;
}