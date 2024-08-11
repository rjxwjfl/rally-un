import 'dart:async';

import 'package:calendar_view/calendar_view.dart';
import 'package:rally/database/sqf_storage_repository.dart';
import 'package:rally/database/sqf_todo_repository.dart';
import 'package:rally/dto/schedule/storage_req_dto.dart';
import 'package:rally/dto/schedule/storage_resp_dto.dart';
import 'package:rally/dto/schedule/todo/internal_todo_resp_dto.dart';
import 'package:rally/dto/schedule/todo/todo_req_dto.dart';
import 'package:rally/main.dart';

class SqfliteBloc {
  int? _storageId;
  List<InternalTodoRespDto> _todoData = [];
  List<InternalTodoRespDto> _today = [];
  List<StorageRespDto> _storageData = [];

  final SqfTodoRepository _todoRepository = SqfTodoRepository();
  final SqfStorageRepository _storageRepository = SqfStorageRepository();

  final StreamController<List<StorageRespDto>> _storageStreamController = StreamController<List<StorageRespDto>>.broadcast();
  final StreamController<List<InternalTodoRespDto>> _todoStreamController =
      StreamController<List<InternalTodoRespDto>>.broadcast();
  final StreamController<List<InternalTodoRespDto>> _todayStreamController =
      StreamController<List<InternalTodoRespDto>>.broadcast();
  final StreamController<List<InternalTodoRespDto>> _searchStreamController =
      StreamController<List<InternalTodoRespDto>>.broadcast();

  Stream<List<StorageRespDto>> get storageStream => _storageStreamController.stream;

  Stream<List<InternalTodoRespDto>> get todoStream => _todoStreamController.stream;

  Stream<List<InternalTodoRespDto>> get todayStream => _todayStreamController.stream;

  Stream<List<InternalTodoRespDto>> get searchStream => _todayStreamController.stream;

  dispose() {
    _storageStreamController.close();
    _todoStreamController.close();
  }


  SqfliteBloc(){
    initStorage();
  }

  initStorage() async {
    await getStorageList();

    // 보관함이 존재하지 않는 경우 기본 보관함 생성
    if (_storageData.isEmpty) {
      final id = await createStorage(data: StorageReqDto(title: '기본 보관함', icon: 0, type: 0));
      await prefs.setInt('default_storage', id);
    }
    await prefs.setInt('default_storage', 1);
    int defaultStorage = prefs.getInt('default_storage')!;
    print(defaultStorage);
    setStorage(defaultStorage);

  }

  getTodoCalendar() async {
    if (_storageId == null){
      await initStorage();
    }
    _todoData = await _todoRepository.getTodoList(storageId: _storageId!);
    print(_todoData.length);
    _todoStreamController.sink.add(_todoData);
    getTodayTodos();
  }

  getTodayTodos() async {
    DateTime today = DateTime.now();

    _today = _todoData
        .where((e) => e.startDate.withoutTime == today.withoutTime || e.endDate.withoutTime == today.withoutTime)
        .toList();
    _todayStreamController.sink.add(_today);
  }

  setStorage(int storageId) {
    if (_storageId != storageId) {
      _storageId = storageId;
    }
  }

  getStorage() async{

  }

  getStorageList() async {
    _storageData = await _storageRepository.getStorageList();

    _storageStreamController.sink.add(_storageData);
  }

  createTodo({required int storageId, required TodoReqDto todo}) async {
    await _todoRepository.createTodo(storageId: storageId, data: todo);
    getTodoCalendar();
  }

  Future<int> createStorage({required StorageReqDto data}) async {
    int id = await _storageRepository.createStorage(data: data);
    await prefs.setInt('default_storage', id);
    setStorage(id);
    getStorageList();

    return id;
  }

  updateTodo({required int todoId, required TodoReqDto data}) async {
    await _todoRepository.updateTodo(todoId: todoId, data: data);
    getTodoCalendar();
  }

  updateTodoState({required int todoId, required int state}) async {
    await _todoRepository.updateTodoState(todoId: todoId, state: state);
    getTodoCalendar();
  }

  updateStorage({required int storageId, required StorageReqDto data}) async {
    await _storageRepository.updateStorage(storageId: storageId, data: data);
    getStorageList();
  }

  deleteTodo({required int todoId}) async {
    await _todoRepository.deleteTodo(todoId: todoId);
    getTodoCalendar();
  }

  deleteStorage({required int storageId}) async {
    await _storageRepository.deleteStorage(storageId: storageId);
    getStorageList();
    getTodoCalendar();
  }

  todoSearch({required String? keyword}) async {
    List<InternalTodoRespDto> list;
    if (keyword == null && keyword!.isNotEmpty) {
      list = _todoData.where((item) => item.title.toLowerCase().contains(keyword)).toList();
    } else {
      list = _todoData;
    }
    _searchStreamController.sink.add(list);
  }
}
