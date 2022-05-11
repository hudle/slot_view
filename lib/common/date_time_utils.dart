// Dart imports:
import 'dart:developer';

// Package imports:
import 'package:intl/intl.dart';

const REPORT_DISPLAY_DATE = "MMMM, yyyy";
const REPORT_RANGE_DISPLAY_DATE = "dd MMMM, yyyy";
const API_DATE_FORMAT = "yyyy-MM-dd";
const API_TIME_FORMAT = "HH:mm";
const API_FORMAT = "yyyy-MM-dd HH:mm:ss";

const DISPLAY_DATE = "dd MMM, yyyy";
const DISPLAY_TIME = "hh:mm a";
const SLOT_TIMING = "hh:mm:ss";

String displayDate(DateTime dateTime, String format) {
  return DateFormat(format).format(dateTime);
}

String displayDateWithString(String dateTime) {
  return convertFormat(
      time: dateTime, newFormat: DISPLAY_DATE, oldFormat: API_FORMAT);
}

String displayTimeWithString(String dateTime) {
  return convertFormat(
      time: dateTime, newFormat: DISPLAY_TIME, oldFormat: API_FORMAT);
}

String displayDateWithDateTime(DateTime dateTime) {
  return DateFormat(DISPLAY_DATE).format(dateTime);
}

String displayTimeAppWithDateTime(DateTime dateTime) {
  return DateFormat(DISPLAY_TIME).format(dateTime);
}

String formatDate(DateTime dateTime, String format) {
  return DateFormat(format).format(dateTime);
}

String displayDateStr(String dateTime, String format) {
  return DateFormat(format).parse(dateTime).toString();
}

String displayTime(String? time) {
  if (time == null) {
    return "N/a";
  }
  return convertFormat(time: time, newFormat: "hh:mm a", oldFormat: "HH:mm:ss");
}

String convertFormat(
    {required String time,
    required String newFormat,
    required String oldFormat}) {
  if (time.isEmpty) return time;

  final input = DateFormat(oldFormat).parse(time);
  final output = DateFormat(newFormat).format(input);
  return output.toString();
}

String displayStartAndEndTime(String? startTime, String? endTime) {
  final start = displayTime(startTime);
  final end = displayTime(endTime);
  return startTime == null && endTime == null
      ? "N/A"
      : start == end
          ? "24x7"
          : "$start to $end";
}

String dobDisplay(String date) {
  log("Convert Date format: $date");
  try {
    return convertFormat(
        time: date, newFormat: DISPLAY_DATE, oldFormat: API_DATE_FORMAT);
  } catch (e) {
    return "--";
  }
}

int minusLeft(String dateString) {
  //print(dateString);
  final now = DateTime.now();
  final comparisonDate = DateFormat(API_FORMAT).parse(dateString);
  final x = comparisonDate.difference(now).inMinutes;
  return x;
}
