import 'package:intl/intl.dart';

var stringDate = DateFormat("yyyyMMdd");
DateTime strToDate(String strDate) {
  return DateTime(
    int.parse(strDate.substring(0, 4)),
    int.parse(strDate.substring(4, 6)),
    int.parse(strDate.substring(6)),
  );
}

bool checkHoliday(DateTime dateTime) {
  String dateTimeStr = stringDate.format(dateTime);
  return holidayListKr.contains(dateTimeStr);
}

DateTime nextBusinessDay(DateTime dateTime) {
  // holiday랑 주말 거르고 다음 영업일 return
  String dateTimeStr = stringDate.format(dateTime);
  if (dateTime.weekday == 6 ||
      dateTime.weekday == 7 ||
      holidayListKr.contains(dateTimeStr)) {
    return nextBusinessDay(dateTime.add(Duration(days: 1)));
  } else {
    return dateTime;
  }

  // return dateTime;
}

const List<String> holidayListKr = [
  '20200930',
  '20201001',
  '20201002',
  '20201009',
  '20201225',
  '20201231',
];
