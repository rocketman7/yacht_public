import 'package:intl/intl.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

var stringDate = DateFormat("yyyyMMdd");

String dateToStr(DateTime dateTime) {
  return stringDate.format(dateTime);
}

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

DateTime closestBusinessDay(DateTime dateTime) {
  // holiday랑 주말 거르고 다음 영업일 return
  dateTime = tz.TZDateTime.from(dateTime, tz.getLocation('Asia/Seoul'));
  String dateTimeStr = stringDate.format(dateTime);
  if (dateTime.weekday == 6 ||
      dateTime.weekday == 7 ||
      holidayListKr.contains(dateTimeStr)) {
    return closestBusinessDay(dateTime.add(Duration(days: 1)));
  } else {
    return dateTime;
  } // return dateTime;
}

DateTime nextNthBusinessDay(DateTime dateTime, int n) {
  // holiday랑 주말 거르고 다음 영업일 return
  // if n = 3, i = 0
  DateTime tempDate = dateTime;

  for (int i = 0; i < n; i++) {
    dateTime = closestBusinessDay(dateTime.add(Duration(days: 1)));
    print(dateTime);
  }

  return dateTime;
}

DateTime previousBusinessDay(DateTime dateTime) {
  // 랭킹페이지를 위한 전영업일 불러오기
  DateTime previousDay = dateTime.add(Duration(days: -1));
  String previousDayStr = stringDate.format(previousDay);

  if (previousDay.weekday == 6 ||
      previousDay.weekday == 7 ||
      holidayListKr.contains(previousDayStr)) {
    return previousBusinessDay(previousDay);
  } else {
    return previousDay;
  }
}

const List<String> holidayListKr = [
  '20200930',
  '20201001',
  '20201002',
  '20201009',
  '20201225',
  '20201231',
  '20210101',
  '20210211',
  '20210212',
  '20210301'
];
