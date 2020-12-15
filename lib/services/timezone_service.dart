import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimezoneService {
  // 현지 시간 now를 한국시간으로 맞춰야함

  TimezoneService() {
    // setup();
    tz.initializeTimeZones();
  }

  DateTime koreaTime(DateTime local) {
    var seoul = tz.getLocation('Asia/Seoul');
    return tz.TZDateTime.now(seoul);
  }

  // Future setup() {
  //   await tz.initializeTimeZone();
  //   var detroit = tz.getLocation('America/Detroit');
  //   tz.setLocalLocation(detroit);
  // }
}
