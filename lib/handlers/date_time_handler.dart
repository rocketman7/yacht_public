// String 형식의 DateTime을 DateTime으로 변환
// 타임존 처리 필요
import 'package:intl/intl.dart';

DateFormat dateInString = DateFormat("yyyyMMdd");
DateFormat dateTimeInString = DateFormat("yyyyMMddHHmmSS");

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
      int.parse(date.substring(0, 4)),
      int.parse(date.substring(4, 6)),
      int.parse(date.substring(6, 8)),
      09,
      00,
      00);
  return marketStart;
}

DateTime marketEndKR(String date) {
  DateTime marketStart = DateTime(
      int.parse(date.substring(0, 4)),
      int.parse(date.substring(4, 6)),
      int.parse(date.substring(6, 8)),
      15,
      30,
      00);
  return marketStart;
}

