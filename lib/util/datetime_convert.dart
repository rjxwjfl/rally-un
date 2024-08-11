import 'dart:io';

import 'package:intl/intl.dart';

String mdFormatter(DateTime date) => DateFormat(DateFormat.MONTH_DAY, Platform.localeName).format(date);

String mdwFormatter(DateTime date) => DateFormat(DateFormat.MONTH_WEEKDAY_DAY, Platform.localeName).format(date);

String hmFormatter(DateTime date) => DateFormat(DateFormat.HOUR24_MINUTE).format(date);

String ymdFormatter(DateTime date) =>
    DateFormat(DateFormat.YEAR_MONTH_DAY, Platform.localeName).format(date);

String ahmFormatter(DateTime date) =>
    DateFormat(DateFormat.HOUR_MINUTE_TZ, Platform.localeName).format(date);

String mdahmFormatter(DateTime date) => DateFormat('MM. dd. a hh:mm', Platform.localeName).format(date);

String todoTimeFormat(DateTime date) => DateFormat('a hh:mm', Platform.localeName).format(date);

String todoDateAndTimeFormat(DateTime date) => DateFormat('d a hh:mm', Platform.localeName).format(date);

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

  return ymdFormatter(date);
}
