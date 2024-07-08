import 'package:intl/intl.dart';

String defaultFormat(DateTime date) =>
    DateFormat('yyyy. MM. dd. hh:mm').format(date);

String sqlDateFormat(DateTime date) {
  DateTime utcTime = date.toUtc();
  DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

  return formatter.format(utcTime);
}

DateTime sqlToDateTime(String date) => DateTime.parse(date).toLocal();

String updatedDateIndicator(DateTime date) {
  DateTime now = DateTime.now();
  Duration diff = now.difference(date);

  if (diff.inMinutes < 1) {
    return '방금전';
  }

  if (diff.inHours < 1) {
    return '${diff.inMinutes}분 전';
  }

  if (diff.inDays < 1) {
    return '${diff.inHours}시간 전';
  }

  return defaultFormat(date);
}
