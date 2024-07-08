bool intToBool (int val){
  const map = {0: false, 1: true};
  return map[val]!;
}

int boolToInt (bool flag){
  const map = {false: 0, true: 1};
  return map[flag]!;
}