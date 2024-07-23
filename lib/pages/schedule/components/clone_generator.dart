import 'package:rally/dto/schedule/todo/replica_gen_model.dart';
import 'package:rally/dto/schedule/todo/replica_date_model.dart';

class CloneGenerator {
  // 정확한 시간에 대한 replica 생성 부분
  ReplicaDateModel generateRep(RepGenerateModel model, ReplicaDateModel form, DateTime current) {
    ReplicaDateModel result;
    List<DateTime> activeDate;

    if (model.allDayFlag) {
      result = form.copyWith(
          executionDate: current.copyWith(hour: 0, minute: 0, second: 0),
          expirationDate: current.copyWith(hour: 23, minute: 59, second: 59));
    } else if (model.todayFlag) {
      result = form.copyWith(
          executionDate: current.copyWith(hour: model.scheduleStart.hour, minute: model.scheduleStart.minute),
          expirationDate: current.copyWith(hour: 23, minute: 59, second: 59));
    } else {
      result = form.copyWith(
          executionDate: current.copyWith(hour: model.scheduleStart.hour, minute: model.scheduleStart.minute),
          expirationDate: current.copyWith(hour: model.scheduleEnd.hour, minute: model.scheduleEnd.minute));
    }

    if (model.reminders != null) {
      activeDate = model.reminders!.map((e) => result.startDate.add(e)).toList();
      result = result.copyWith(activeDate: activeDate);
    }

    return result;
  }

  List<ReplicaDateModel> generator({required RepGenerateModel model}) {
    ReplicaDateModel form = ReplicaDateModel(
      startDate: model.scheduleStart,
      endDate: model.scheduleEnd,
    );

    switch (model.repeatType) {
      case 0:
        return daily(model, form);
      case 1:
        return weekly(model, form);
      case 2:
        return monthly(model, form);
      case 3:
        return yearly(model, form);
      default:
      // 반복 없음
        return singleTodo(model, form);
    }
  }

  List<ReplicaDateModel> singleTodo(RepGenerateModel model, ReplicaDateModel form) {
    List<ReplicaDateModel> data = [];
    data.add(generateRep(model, form, model.scheduleStart));
    return data;
  }

  List<ReplicaDateModel> daily(RepGenerateModel model, ReplicaDateModel form) {
    List<ReplicaDateModel> data = [];
    DateTime current = model.scheduleStart;
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    while (current.isBefore(model.scheduleEnd)) {
      ReplicaDateModel rep = generateRep(model, form, current);
      if (rep.startDate.isAfter(today)) {
        data.add(rep);
      }
      current = current.add(Duration(days: model.frequency!));
    }

    return data;
  }

  List<ReplicaDateModel> weekly(RepGenerateModel model, ReplicaDateModel form) {
    List<ReplicaDateModel> data = [];
    DateTime current = model.scheduleStart;
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day, 0, 0, 0);

    while (current.isBefore(model.scheduleEnd)) {
      if (model.weekday!.contains(current.weekday)) {
        ReplicaDateModel rep = generateRep(model, form, current);
        if (rep.startDate.isAfter(today) || rep.startDate == today) {
          data.add(rep);
        }
      }

      if (current.weekday == 7) {
        current = current.add(Duration(days: 7 * (model.frequency! - 1)));
      }
      current = current.add(const Duration(days: 1));
    }

    return data;
  }

  List<ReplicaDateModel> monthly(RepGenerateModel model, ReplicaDateModel form) {
    List<ReplicaDateModel> data = [];
    DateTime current = model.scheduleStart;
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    int weekday = model.scheduleStart.weekday;
    int wom = weekOfMonth(model.scheduleStart);
    int pre = model.scheduleStart.month;

    while (current.isBefore(model.scheduleEnd.add(const Duration(days: 1)))) {
      if ((model.specFlag ? current.weekday == weekday && weekOfMonth(current) == wom : current.day == model.scheduleStart.day) &&
          (pre - model.scheduleStart.month) % model.frequency! == 0) {
        ReplicaDateModel rep = generateRep(model, form, current);
        if (rep.startDate.isAfter(today)) {
          data.add(rep);
        }
      }

      current = current.add(const Duration(days: 1));

      if (12 * (current.year - model.scheduleStart.year) + current.month != pre) {
        pre++;
      }
    }

    return data;
  }

  List<ReplicaDateModel> yearly(RepGenerateModel model, ReplicaDateModel form) {
    List<ReplicaDateModel> data = [];
    DateTime current = model.scheduleStart;
    int weekday = model.scheduleStart.weekday;
    int wom = weekOfMonth(model.scheduleStart);
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    while (current.isBefore(model.scheduleEnd.add(const Duration(days: 1)))) {
      if (current.month == model.scheduleStart.month &&
          (model.specFlag ? current.weekday == weekday && weekOfMonth(current) == wom : current.day == model.scheduleStart.day) &&
          (current.year - model.scheduleStart.year) % model.frequency! == 0) {
        ReplicaDateModel date = generateRep(model, form, current);
        if (date.startDate.isAfter(today)) {
          data.add(date);
        }
      }

      current = current.add(const Duration(days: 1));
    }

    return data;
  }
}

int weekOfMonth(DateTime date) {
  DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
  int weeks = ((date.difference(firstDayOfMonth).inDays + 1) / 7).ceil();

  return weeks;
}

