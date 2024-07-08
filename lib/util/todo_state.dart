
enum TodoState { pending, complete }

TodoState intToState(int val){
  const map = {
    0: TodoState.pending,
    1: TodoState.complete
  };

  return map[val]!;
}

int stateToInt(TodoState state){
  const map = {
    TodoState.pending: 0,
    TodoState.complete: 1,
  };

  return map[state]!;
}