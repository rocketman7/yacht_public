import 'package:intl/intl.dart';

import 'package:yachtOne/models/temp_address_constant.dart';
import 'package:yachtOne/services/timezone_service.dart';
import 'package:yachtOne/views/constants/holiday.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../locator.dart';

class DateTimeModel {
  final TimezoneService? _timezoneService = locator<TimezoneService>();
  // HOUR24_MINUTE_SECOND
  String hms(DateTime dateTime) {
    dateTime = _timezoneService!.koreaTime(dateTime);
    return DateFormat.Hms().format(dateTime);
  }

  // yyyyMMdd
  String yyyyMMdd(DateTime dateTime) {
    print("YYYY" + dateTime.toString());
    dateTime = _timezoneService!.koreaTime(dateTime);
    print("YYYY AFTER" + dateTime.toString());
    return DateFormat("yyyyMMdd").format(dateTime);
  }

// 오늘 날짜가 평일이면 오늘 반환, 주말이면 다음 월요일 반환
  DateTime weekDay(DateTime dateTime) {
    dateTime = _timezoneService!.koreaTime(dateTime);

    if (dateTime.weekday >= 1 && dateTime.weekday <= 5) {
      return (dateTime);
    } else if (dateTime.weekday == 6) {
      return dateTime.add(Duration(days: 2));
    } else if (dateTime.weekday == 7) {
      return dateTime.add(Duration(days: 1));
    }
    throw "DateTime Error";
  }

// Today의 장 오픈, 클로즈 시간 DateTime 리스트로 반환, 주말이면 다음 월요일로 반환
  List<DateTime> marketOpeningPeriod(String? category, DateTime now) {
    switch (category) {
      case 'KR':
        // 지금 시간이 평일인지 체크하고 평일이면 그대로 반환, 주말이면 가장 가까운 월요일 반환
        // DateTime _now = DateTime.now();
        DateTime _timeNow = _timezoneService!.koreaTime(now);
        DateTime _nearestWeekDay = closestBusinessDay(_timeNow);
        DateTime _marketStart = tz.TZDateTime(
            _timezoneService!.seoul,
            _nearestWeekDay.year,
            _nearestWeekDay.month,
            _nearestWeekDay.day,
            08,
            50,
            00);
        DateTime _marketEnd = tz.TZDateTime(
            _timezoneService!.seoul,
            _nearestWeekDay.year,
            _nearestWeekDay.month,
            _nearestWeekDay.day,
            16,
            00,
            00);

        return [_marketStart, _marketEnd];

        break;
      default:
        return throw 'Category Unknown';
    }
  }

// 투표 가능시간인지 가능이면 true, 불가능(장중)이면 false
  bool isVoteAvailable(String? category, DateTime now) {
    // DateTime _now = DateTime.now();
    DateTime koreaNow = _timezoneService!.koreaTime(now);

    print("ISVOTEAVAILABLE" + koreaNow.toString());

    List<DateTime> dateTime = marketOpeningPeriod(category, now);
    print("MARKET OPEN" + dateTime.toString());
    switch (category) {
      case 'KR':
        // DateTime _timeNow = DateTime.now();
        print("KR_TIMENOW" + koreaNow.toString());
        // 지금이 장중 시간일 때 (08:50 ~ 16:00)
        if (koreaNow.isAfter(dateTime[0]) && koreaNow.isBefore(dateTime[1])) {
          print("IS IN THE MARKET");
          return false; //투표 불가능
        } else {
          return true; //투표 가능
        }
        break;
      default:
        return throw 'Category Unknown';
    }
  }

// 기준일자 8자리 String으로 반환하는 함수
  Future<String> baseDate(String? category, DateTime now) async {
    // DateTime now = await NTP.now();
    DateTime _timeNow = _timezoneService!.koreaTime(now);
    List<DateTime> dateTime = marketOpeningPeriod(category, now);
    bool votingNow = isVoteAvailable(category, now);
    print("TIME FOR BASEDATE" + _timeNow.toString());
    //투표 불가능할 때 (=장중일 때)
    if (!votingNow) {
      // T일로 반환
      return yyyyMMdd(_timeNow);
    } else {
      // 투표 가능일 때 (=장중 아닐 때)
      if (_timeNow.isBefore(dateTime[0])) {
        print("TIME FOR BASEDATE BEFORE OPEN" + _timeNow.toString());
        // 가장 빠른 장 열리는 날로 반환
        return yyyyMMdd(dateTime[0]);
      } else if (_timeNow.isAfter(dateTime[1])) {
        print("TIME FOR BASEDATE AFTER CLOSE" + _timeNow.toString());
        // 오늘 평일이고 다음날도 평일이면 다음날 반환
        // 오늘 평일이고 다음날 주말/휴일이면 nextBuinewssDay함수에 의해 다음 월요일 반환
        // 오늘 토요일이고 다음날 일요일이면 weekDay함수에 의해 다음 월요일 반환
        print("FINAL BASEDATE AFTER CLOSE" +
            yyyyMMdd(closestBusinessDay(_timeNow.add(Duration(days: 1)))));
        return yyyyMMdd(closestBusinessDay(_timeNow.add(Duration(days: 1))));
      }
    }
    throw "DateTimeERROR";
  }
}
