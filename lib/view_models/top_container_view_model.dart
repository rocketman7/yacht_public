import 'dart:async';

import 'package:stacked/stacked.dart';
import '../services/api/customized_ntp.dart';

class TopContainerViewModel extends FutureViewModel {
  DateTime nowFromNetwork;
  Timer timer;
  // TopContainerViewModel() {}

  Future getModel() async {
    nowFromNetwork = await CustomizedNTP.now();
    notifyListeners();
    // renewTime();
  }

  Future renewTime() async {
    // print("TIMER");
    nowFromNetwork = await CustomizedNTP.now();
  }

  // Future renewTime() async {
  //   timer = Timer.periodic(Duration(seconds: 1), (Timer t) async {
  //     print("TIMER");
  //     nowFromNetwork = await NTP.now();
  //   });
  // }

  @override
  Future futureToRun() {
    return getModel();
    // TODO: implement futureToRun
  }
}
