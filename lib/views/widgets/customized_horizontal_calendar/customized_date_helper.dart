import 'package:yachtOne/views/constants/holiday.dart';

List<DateTime> getDateList(DateTime firstDate, DateTime lastDate) {
  List<DateTime> list = [];
  int count = daysCount(toDateMonthYear(firstDate), toDateMonthYear(lastDate));
  for (int i = 0; i < count; i++) {
    String firstDateStr = stringDate.format(firstDate.add(Duration(days: i)));
    if (firstDate.add(Duration(days: i)).weekday == 6 ||
        firstDate.add(Duration(days: i)).weekday == 7 ||
        holidayListKr.contains(firstDateStr)) {
    } else {
      list.add(toDateMonthYear(firstDate).add(Duration(days: i)));
    }
  }
  return list;
}

DateTime toDateMonthYear(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day);
}

int daysCount(DateTime first, DateTime last) =>
    last.difference(first).inDays + 1;

enum LabelType {
  date,
  month,
  weekday,
}
