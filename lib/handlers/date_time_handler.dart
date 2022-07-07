// String 형식의 DateTime을 DateTime으로 변환
// 타임존 처리 필요
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:yachtOne/repositories/repository.dart';

DateFormat shortDate = DateFormat("M/d");
DateFormat dateInString = DateFormat("yyyyMMdd");
DateFormat dateTimeInString = DateFormat("yyyyMMddHHmmSS");
DateFormat feedDateTimeInString = DateFormat("yyyy.MM.dd HH:mm");
DateFormat dateTimeShortened = DateFormat("yy.MM.dd");

DateTime? stringToDateTime(String dateTimeInString) {
  int length = dateTimeInString.length;
  switch (length) {
    case 8: // YYYYMMDD 형식의 8자리 String
      return DateTime(
        int.parse(dateTimeInString.substring(0, 4)),
        int.parse(dateTimeInString.substring(4, 6)),
        int.parse(dateTimeInString.substring(6)),
      );

    case 14: // YYYYMMDDHHmmSS 형식의 14자리 String
      return DateTime(
        int.parse(dateTimeInString.substring(0, 4)),
        int.parse(dateTimeInString.substring(4, 6)),
        int.parse(dateTimeInString.substring(6, 8)),
        int.parse(dateTimeInString.substring(8, 10)),
        int.parse(dateTimeInString.substring(10, 12)),
        int.parse(dateTimeInString.substring(12)),
      );
    default:
      print("stringToDateTime returns null!");
      break;
  }
}

String? dateTimeToString(DateTime dateTime, int digit) {
  switch (digit) {
    case 4:
      return shortDate.format(dateTime);
    case 8:
      return dateInString.format(dateTime);
    case 14:
      return dateTimeInString.format(dateTime);
    default:
      return dateInString.format(dateTime);
  }
}

DateTime marketStartKR(String date) {
  DateTime marketStart = DateTime(
      int.parse(date.substring(0, 4)), int.parse(date.substring(4, 6)), int.parse(date.substring(6, 8)), 09, 00, 00);
  return marketStart;
}

DateTime marketEndKR(String date) {
  DateTime marketStart = DateTime(
      int.parse(date.substring(0, 4)), int.parse(date.substring(4, 6)), int.parse(date.substring(6, 8)), 15, 30, 00);
  return marketStart;
}

String countDown(Duration duration) {
  if (duration > Duration(days: 1)) {
    return "${duration.inDays}일 ${duration.inHours.remainder(24)}시간 ${duration.inMinutes.remainder(60)}분 ${duration.inSeconds.remainder(60)}초";
  } else {
    return "${duration.inHours}시간 ${duration.inMinutes.remainder(60)}분 ${duration.inSeconds.remainder(60)}초";
  }
}

String shorterCountDown(Duration duration) {
  if (duration > Duration(days: 1)) {
    return "${duration.inDays}일 ${duration.inHours.remainder(24)}:${duration.inMinutes.remainder(60).toString().padLeft(2, "0")}:${duration.inSeconds.remainder(60).toString().padLeft(2, "0")}";
  } else {
    return "${duration.inHours}:${duration.inMinutes.remainder(60).toString().padLeft(2, "0")}:${duration.inSeconds.remainder(60).toString().padLeft(2, "0")}";
  }
}

String feedTimeHandler(DateTime writtenDateTime) {
  Duration _writtenDateTimeFromNow = DateTime.now().difference(writtenDateTime);

  if (_writtenDateTimeFromNow < Duration(minutes: 1)) {
    return "방금 전";
  } else if (_writtenDateTimeFromNow < Duration(hours: 1)) {
    return "${_writtenDateTimeFromNow.inMinutes}분 전";
  } else if (_writtenDateTimeFromNow < Duration(hours: 24)) {
    return "${_writtenDateTimeFromNow.inHours}시간 전";
  } else if (_writtenDateTimeFromNow < Duration(days: 7)) {
    return "${_writtenDateTimeFromNow.inDays}일 전";
  } else {
    return feedDateTimeInString.format(writtenDateTime);
  }
}

// 알림 데이트타임
String notificationTimeHandler(DateTime writtenDateTime) {
  Duration _writtenDateTimeFromNow = DateTime.now().difference(writtenDateTime);

  if (_writtenDateTimeFromNow < Duration(minutes: 1)) {
    return "방금 전";
  } else if (_writtenDateTimeFromNow < Duration(hours: 1)) {
    return "${_writtenDateTimeFromNow.inMinutes}분 전";
  } else if (_writtenDateTimeFromNow < Duration(hours: 24)) {
    return "${_writtenDateTimeFromNow.inHours}시간 전";
  } else if (_writtenDateTimeFromNow < Duration(days: 7)) {
    return "${_writtenDateTimeFromNow.inDays}일 전";
  } else {
    return "${_writtenDateTimeFromNow.inDays ~/ 7}주 전";
  }
}

// DB timeStamp형식을 xxxx년 0x월 0x일 형식으로 (상금 히스토리에서 쓰이는)
String timeStampToString(Timestamp time) {
  return '${time.toDate().year}년 ${time.toDate().month}월 ${time.toDate().day}일';
}

// DB timeStamp형식을 xxxx년 0x월 0x일 형식으로 (상금 히스토리에서 쓰이는)
String timeStampToStringWithHourMinute(Timestamp time) {
  return '${time.toDate().year}년 ${time.toDate().month}월 ${time.toDate().day}일 ${time.toDate().hour}시 ${time.toDate().minute}분';
}

String dateTimeToStringKorean(DateTime dateTime, bool toMinute) {
  if (toMinute == true) {
    return '${dateTime.year}.${dateTime.month}.${dateTime.day} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, "0")}';
  } else {
    return '${dateTime.year}.${dateTime.month}.${dateTime.day}';
  }
}

String dateTimeToStringShortened(Timestamp time) {
  return dateTimeShortened.format(time.toDate());
}

bool isHoliday(DateTime dateTime) {
  // dateTime = _timezoneService.koreaTime(dateTime);
  String dateTimeStr = dateTimeToString(dateTime, 8)!;
  return holidayListKR.contains(dateTimeStr);
}

bool isBusinessDay(DateTime dateTime) {
  // dateTime = _timezoneService.koreaTime(dateTime);
  String dateTimeStr = dateTimeToString(dateTime, 8)!;
  return !(dateTime.weekday == 6 || dateTime.weekday == 7 || holidayListKR.contains(dateTimeStr));
}

DateTime closestBusinessDay(DateTime dateTime) {
  // holiday랑 주말 거르고 다음 영업일 return
  String dateTimeStr = dateTimeToString(dateTime, 8)!;
  // print("BUSINESSDAYCHECK" + dateTime.weekday.toString());
  if (dateTime.weekday == 6 || dateTime.weekday == 7 || holidayListKR.contains(dateTimeStr)) {
    return closestBusinessDay(dateTime.add(Duration(days: 1)));
  } else {
    // print("RETURNED DATETIME" + dateTime.toString());
    return dateTime;
  } // return dateTime;
}

DateTime nextNthBusinessDay(DateTime dateTime, int n) {
  // holiday랑 주말 거르고 다음 영업일 return
  // if n = 3, i = 0

  // dateTime = _timezoneService.koreaTime(dateTime);
  for (int i = 0; i < n; i++) {
    dateTime = closestBusinessDay(dateTime.add(Duration(days: 1)));
  }

  return dateTime;
}

DateTime previousBusinessDay(DateTime dateTime) {
  // dateTime = _timezoneService.koreaTime(dateTime);
  // 랭킹페이지를 위한 전영업일 불러오기
  DateTime previousDay = dateTime.add(Duration(days: -1));
  String previousDayStr = dateTimeToString(dateTime, 8)!;

  if (previousDay.weekday == 6 || previousDay.weekday == 7 || holidayListKR.contains(previousDayStr)) {
    return previousBusinessDay(previousDay);
  } else {
    return previousDay;
  }
}

int numberOfBusinessDay(DateTime first, DateTime last) {
  int j = 0;
  int day = 1;
  for (int i = 0; i <= last.difference(first).inDays; i++) {
    if (isTwoDateSame(first.add(Duration(days: i)), last)) {
      day += j;
      break;
    } else {
      if (isBusinessDay(first.add(Duration(days: i)))) j++;
    }
  }
  return day;
}

List<DateTime> businessDaysBtwTwoDates(DateTime first, DateTime last) {
  List<DateTime> businessDays = [];

  for (int i = 0; i <= last.difference(first).inDays; i++) {
    if (isTwoDateSame(
      first.add(Duration(days: i)),
      last,
    )) {
      businessDays.add(
        DateTime(
            first.add(Duration(days: i)).year, first.add(Duration(days: i)).month, first.add(Duration(days: i)).day),
      );
      break;
    } else {
      if (isBusinessDay(first.add(Duration(days: i)))) {
        businessDays.add(
          DateTime(
              first.add(Duration(days: i)).year, first.add(Duration(days: i)).month, first.add(Duration(days: i)).day),
        );
      }
    }
  }
  return businessDays;
}

bool isTwoDateSame(DateTime dateTime1, DateTime dateTime2) {
  return dateTimeToString(dateTime1, 8)! == dateTimeToString(dateTime2, 8)!;
}
