import 'package:intl/intl.dart';
import 'package:yachtOne/models/temp_address_constant.dart';
import 'package:yachtOne/views/constants/holiday.dart';

class DateTimeModel {
  // HOUR24_MINUTE_SECOND
  String hms(DateTime dateTime) {
    return DateFormat.Hms().format(dateTime);
  }

  // yyyyMMdd
  String yyyyMMdd(DateTime dateTime) {
    return DateFormat("yyyyMMdd").format(dateTime);
  }

// 오늘 날짜가 평일이면 오늘 반환, 주말이면 다음 월요일 반환
  DateTime weekDay(DateTime dateTime) {
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
  List<DateTime> marketOpeningPeriod(String category) {
    switch (category) {
      case 'koreaStockStandard':
        // 지금 시간이 평일인지 체크하고 평일이면 그대로 반환, 주말이면 가장 가까운 월요일 반환
        DateTime _timeNow = DateTime.now();
        DateTime _nearestWeekDay = closestBusinessDay(_timeNow);
        DateTime _marketStart = DateTime(_nearestWeekDay.year,
            _nearestWeekDay.month, _nearestWeekDay.day, 08, 50, 00);
        DateTime _marketEnd = DateTime(_nearestWeekDay.year,
            _nearestWeekDay.month, _nearestWeekDay.day, 16, 00, 00);

        return [_marketStart, _marketEnd];

        break;
      default:
        return throw 'Category Unknown';
    }
  }

// 투표 가능시간인지 가능이면 true, 불가능(장중)이면 false
  bool isVoteAvailable(String category) {
    List<DateTime> dateTime = marketOpeningPeriod(category);
    switch (category) {
      case 'koreaStockStandard':
        DateTime _timeNow = DateTime.now();

        // 지금이 장중 시간일 때 (08:50 ~ 16:00)
        if (_timeNow.isAfter(dateTime[0]) && _timeNow.isBefore(dateTime[1])) {
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
  String baseDate(String category) {
    List<DateTime> dateTime = marketOpeningPeriod(category);
    bool votingNow = isVoteAvailable(category);
    DateTime _timeNow = DateTime.now();

    //투표 불가능할 때 (=장중일 때)
    if (!votingNow) {
      // T일로 반환
      return yyyyMMdd(_timeNow);
    } else {
      // 투표 가능일 때 (=장중 아닐 때)
      if (_timeNow.isBefore(dateTime[0])) {
        // 가장 빠른 장 열리는 날로 반환
        return yyyyMMdd(dateTime[0]);
      } else if (_timeNow.isAfter(dateTime[1])) {
        // 오늘 평일이고 다음날도 평일이면 다음날 반환
        // 오늘 평일이고 다음날 주말/휴일이면 nextBuinewssDay함수에 의해 다음 월요일 반환
        // 오늘 토요일이고 다음날 일요일이면 weekDay함수에 의해 다음 월요일 반환
        return yyyyMMdd(closestBusinessDay(_timeNow.add(Duration(days: 1))));
      }
    }
    throw "DateTimeERROR";
  }
}
