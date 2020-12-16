import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimezoneService {
  // 현지 시간 now를 한국시간으로 맞춰야함

  TimezoneService() {
    // setup();
    tz.initializeTimeZones();
  }

  var seoul = tz.getLocation('Asia/Seoul');

  DateTime koreaTime(DateTime local) {
    // var seoul = tz.getLocation('Asia/Seoul');
    var timezoneApplied = tz.TZDateTime.from(local, seoul);
    return timezoneApplied;
  }

  // Future setup() {
  //   await tz.initializeTimeZone();
  //   var detroit = tz.getLocation('America/Detroit');
  //   tz.setLocalLocation(detroit);
  // }
}
