import 'package:calendar_view/calendar_view.dart';
import 'package:rally/dto/schedule/schedule_resp_dto.dart';
import 'package:rally/dto/schedule/todo/todo_resp_dto.dart';
import 'package:rally/dto/user/todo_author.dart';
import 'package:rally/util/todo_state.dart';

class SampleTodoData {
  SampleTodoData._();

  static DateTime now = DateTime.now();
  static DateTime endOfDay = DateTime(now.year, now.month, now.day, 24, 59, 59);

  static List<ScheduleRespDto> scheduleList = <ScheduleRespDto>[
    ScheduleRespDto(
      schId: 1,
      author: author3rd,
      title: 'Sample schedule',
      desc: '"Lorem ipsum dolor sit amet, '
          'consectetur adipiscing elit, '
          'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
          'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. '
          'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. '
          'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."',
      priority: 1,
      startDate: now.withoutTime,
      endDate: now.add(const Duration(days: 1)).withoutTime,
      createdDate: now,
      updatedDate: now,
      repeatFlag: false,
      repeatType: 0,
      specFlag: false,
      frequency: 1,
      allDayFlag: false,
      todayFlag: true,
    ),
    ScheduleRespDto(
      schId: 2,
      author: author1st,
      title: 'Sample schedule #2',
      priority: 1,
      startDate: now.add(const Duration(days: 2, hours: 3)),
      endDate: now.add(const Duration(days: 2, hours: 3)),
      createdDate: now,
      updatedDate: now,
      repeatFlag: false,
      repeatType: 0,
      specFlag: false,
      frequency: 1,
      allDayFlag: false,
      todayFlag: true,
    ),
    ScheduleRespDto(
      schId: 3,
      author: author1st,
      title: 'Sample schedule #3',
      priority: 1,
      startDate: now.subtract(const Duration(hours: 1, minutes: 25)),
      endDate: now.add(const Duration(hours: 2)),
      createdDate: now,
      updatedDate: now,
      repeatFlag: false,
      repeatType: 0,
      specFlag: false,
      frequency: 1,
      allDayFlag: false,
      todayFlag: true,
    ),
    ScheduleRespDto(
      schId: 4,
      author: author2nd,
      title: 'Sample schedule #4',
      priority: 1,
      startDate: now.subtract(const Duration(hours: 2, minutes: 25)),
      endDate: now.add(const Duration(days: 1, hours: 5)),
      createdDate: now,
      updatedDate: now,
      repeatFlag: false,
      repeatType: 0,
      specFlag: false,
      frequency: 1,
      allDayFlag: false,
      todayFlag: true,
    ),
    ScheduleRespDto(
      schId: 5,
      author: author2nd,
      title: 'Sample schedule #5',
      priority: 1,
      startDate: now.withoutTime,
      endDate: now.add(const Duration(days: 4)).withoutTime,
      createdDate: now,
      updatedDate: now,
      repeatFlag: false,
      repeatType: 0,
      specFlag: false,
      frequency: 1,
      allDayFlag: false,
      todayFlag: true,
    ),
    ScheduleRespDto(
      schId: 6,
      author: author1st,
      title: 'Sample schedule #6',
      priority: 1,
      startDate: DateTime(2024, 8, 16, 16),
      endDate: now.add(const Duration(days: 1)).withoutTime,
      createdDate: now,
      updatedDate: now,
      repeatFlag: false,
      repeatType: 0,
      specFlag: false,
      frequency: 1,
      allDayFlag: false,
      todayFlag: true,
    ),
  ];

  static List<TodoRespDto> sampleList = <TodoRespDto>[
    TodoRespDto(
      todoId: 1,
      author: author2nd,
      title: 'Lorem ipsum length sample',
      desc:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco Laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in rerehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est labum.',
      priority: 0,
      state: 1,
      startDate: now,
      endDate: now.add(const Duration(hours: 5)),
      completeDate: now.add(const Duration(hours: 2)),
      createdDate: DateTime(2024, 7, 1),
      updatedDate: DateTime(2024, 7, 1),
    ),
    TodoRespDto(
      todoId: 5,
      author: author1st,
      title: 'Sample #5',
      desc: 'sample contents',
      priority: 1,
      state: 0,
      startDate: now,
      endDate: endOfDay,
      createdDate: DateTime(2024, 7, 1),
      updatedDate: DateTime(2024, 7, 1),
    ),
    TodoRespDto(
      todoId: 6,
      author: author1st,
      title: 'Sample #6',
      desc: 'sample contents',
      priority: 2,
      state: 0,
      startDate: now,
      endDate: endOfDay,
      createdDate: DateTime(2024, 7, 1),
      updatedDate: DateTime(2024, 7, 1),
    ),
    TodoRespDto(
      todoId: 7,
      author: author1st,
      title: 'Sample #7',
      desc: 'sample contents',
      priority: 1,
      state: 0,
      startDate: now,
      endDate: endOfDay,
      createdDate: DateTime(2024, 7, 1),
      updatedDate: DateTime(2024, 7, 1),
    ),
    TodoRespDto(
      todoId: 8,
      author: author1st,
      title: 'Sample #8',
      desc: 'sample contents',
      priority: 1,
      state: 1,
      startDate: now,
      endDate: endOfDay,
      createdDate: DateTime(2024, 7, 1),
      updatedDate: DateTime(2024, 7, 1),
    ),
    TodoRespDto(
      todoId: 9,
      author: author1st,
      title: 'Sample #9',
      desc: 'sample contents',
      priority: 0,
      state: 0,
      startDate: now,
      endDate: endOfDay,
      createdDate: DateTime(2024, 7, 1),
      updatedDate: DateTime(2024, 7, 1),
    ),
    TodoRespDto(
      todoId: 10,
      author: author1st,
      title: 'Sample #10',
      desc: 'sample contents',
      priority: 0,
      state: 0,
      startDate: now,
      endDate: endOfDay,
      createdDate: DateTime(2024, 7, 1),
      updatedDate: DateTime(2024, 7, 1),
    ),
    TodoRespDto(
      todoId: 2,
      author: author1st,
      title: 'Sample day#2',
      desc: 'sample contents',
      priority: 0,
      state: 0,
      startDate: DateTime.now().add(const Duration(days: 1)),
      endDate: endOfDay,
      createdDate: DateTime(2024, 7, 1),
      updatedDate: DateTime(2024, 7, 1),
    ),
    TodoRespDto(
      todoId: 3,
      author: author3rd,
      title: 'Sample day#3',
      desc: 'sample contents',
      priority: 1,
      state: 0,
      startDate: DateTime.now().add(const Duration(days: 3)),
      endDate: endOfDay,
      createdDate: DateTime(2024, 7, 1),
      updatedDate: DateTime(2024, 7, 1),
    ),
    TodoRespDto(
      todoId: 4,
      author: author2nd,
      title: 'Sample day#4',
      desc: 'sample contents',
      priority: 2,
      state: 0,
      startDate: DateTime.now().add(const Duration(days: 4)),
      endDate: endOfDay,
      createdDate: DateTime(2024, 7, 1),
      updatedDate: DateTime(2024, 7, 1),
    ),
    TodoRespDto(
      todoId: 11,
      author: author3rd,
      title: '주식은 어렵다. 오늘은 월간옵션 만기라 더욱 어렵다.',
      desc: '삼성전자가 월요일에 그렇게 드라마틱하게 오를꺼라곤 생각하지 않는다.'
          '남은 자산을 어떻게 굴려야하는가, 어떤 종목에 투자하는가 정말 고민이 많다.',
      priority: 0,
      state: 0,
      startDate: now.add(const Duration(days: 2)),
      endDate: endOfDay,
      createdDate: DateTime(2024, 7, 1),
      updatedDate: DateTime(2024, 7, 1),
    ),
  ];
}

AuthorRespDto author1st = AuthorRespDto(
  userId: 1,
  username: 'rjxwjfl@gmail.com',
  displayName: 'Administrator',
  privateFlag: false,
  latestAccess: DateTime.now(),
);
AuthorRespDto author2nd = AuthorRespDto(
  userId: 2,
  username: 'rallydev@gmail.com',
  displayName: 'Manager',
  privateFlag: false,
  latestAccess: DateTime.now(),
);
AuthorRespDto author3rd = AuthorRespDto(
  userId: 3,
  username: 'kjk4009@gmail.com',
  displayName: 'User #1',
  privateFlag: true,
  latestAccess: DateTime.now(),
);
