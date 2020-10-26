import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/database_service.dart';
import 'package:yachtOne/views/constants/holiday.dart';
import 'dart:math' as math;

import '../services/stateManager_service.dart';
import '../services/stateManager_service.dart' as global;

import '../locator.dart';
import '../models/portfolio_model.dart';
import '../models/database_address_model.dart';
import '../models/season_model.dart';
import '../services/sharedPreferences_service.dart';
import '../models/sharedPreferences_const.dart';

class PortfolioViewModel extends FutureViewModel {
  // Services Setting
  final SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  final StateManagerServiceService _stateManagerService =
      locator<StateManagerServiceService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  final AuthService _authService = locator<AuthService>();
  // 변수 Setting
  // 아래에 stateManagerService에 있는 놈들 중 사용할 모델들 설정
  DatabaseAddressModel addressModel;
  PortfolioModel portfolioModel;
  SeasonModel seasonModel;
  // 여기는 이 화면 고유의 모델 설정

  // UI용 변수
  List<double> startPercentage = []; // 실제 subPortfolio갯수보다 하나 많아야.
  List<double> initialValueRatio = [];
  List<double> valueIncreaseRatio = [];
  double maxValueIncreaseRatio = 0;
  double minValueIncreaseRatio = 0;
  double maxOfMaxMin = 0;

  int totalInitialValue = 0;

  int maxItemsNameLength = 7;
  List<int> orderDrawingItem = [];
  List<bool> drawingMaxLength = [];

  String uid;

  // 튜토리얼 변수
  bool portfolioTutorial;
  int tutorialStatus = 2; // 튜토리얼 내 단계만큼.. (나중에 쉐어드 프리퍼런스로 해야할 듯)
  int tutorialTotalStep = 2; // 튜토리얼 총 단계
  PortfolioViewModel() {
    uid = _authService.auth.currentUser.uid;
  }

  // method
  // 포트폴리오 DB로부터 얻어오기 + UI용 변수들 계산
  Future getPortfolio() async {
    //=======================stateManagerService이용하여 뷰모델 시작=======================
    // String myState = _stateManagerService.calcState();

    // if (_stateManagerService.hasLocalStateChange(myState)) {
    //   if (await _stateManagerService.hasDBStateChange(myState)) {
    //     // update needed. local & db 모두 변했기 때문
    //     // 아래처럼 stateManagerService에서 각 모델들을 모두 리로드해주고, 그걸 뷰모델 내 모델변수에 재입력해준다.
    //     await _stateManagerService.initStateManager();
    //   }
    // }
    // addressModel = global.localAddressModel;
    // portfolioModel = global.localPortfolioModel;
    // seasonModel = global.localSeasonModel;

    // //=======================stateManagerService이용하여 뷰모델 시작=======================

    addressModel = await _databaseService.getAddress(uid);
    portfolioModel = await _databaseService.getPortfolio(addressModel);
    seasonModel = await _databaseService.getSeasonInfo(addressModel);
    //튜토리얼을 위한
    portfolioTutorial = await _sharedPreferencesService
        .getSharedPreferencesValue(portfolioTutorialKey, bool);

    // 초기비중만큼 호를 나눠주기 위해 값 계산
    for (int i = 0; i < portfolioModel.subPortfolio.length; i++) {
      totalInitialValue += portfolioModel.subPortfolio[i].sharesNum *
          portfolioModel.subPortfolio[i].initialPrice;
    }

    for (int i = 0; i < portfolioModel.subPortfolio.length; i++) {
      initialValueRatio.add((portfolioModel.subPortfolio[i].sharesNum *
              portfolioModel.subPortfolio[i].initialPrice /
              totalInitialValue) *
          100.0);
    }

    // 얼마나 올랐는지(내렸는지) 보기 위한 값 계산. 최종적으로 1~3값으로 치환되어야함
    for (int i = 0; i < portfolioModel.subPortfolio.length; i++) {
      valueIncreaseRatio.add(portfolioModel.subPortfolio[i].currentPrice /
          portfolioModel.subPortfolio[i].initialPrice);

      valueIncreaseRatio[i] -= 1.0;
    }

    for (int i = 0; i < portfolioModel.subPortfolio.length; i++) {
      if (valueIncreaseRatio[i] > maxValueIncreaseRatio)
        maxValueIncreaseRatio = valueIncreaseRatio[i];

      if (valueIncreaseRatio[i] < minValueIncreaseRatio)
        minValueIncreaseRatio = valueIncreaseRatio[i];
    }

    maxValueIncreaseRatio.abs() > minValueIncreaseRatio.abs()
        ? maxOfMaxMin = maxValueIncreaseRatio
        : maxOfMaxMin = minValueIncreaseRatio;

    for (int i = 0; i < portfolioModel.subPortfolio.length; i++) {
      if (maxOfMaxMin > 0) {
        valueIncreaseRatio[i] = 2 + valueIncreaseRatio[i] / maxOfMaxMin;
      } else if (maxOfMaxMin < 0) {
        valueIncreaseRatio[i] = 2 - valueIncreaseRatio[i] / maxOfMaxMin;
      } else {
        valueIncreaseRatio[i] = 2;
      }
    }

    // Arc의 시작점을 설정해주고, 나머지도 초기비중에 맞게 호의 길이만큼 설정해주는 작업
    final random = math.Random();

    startPercentage.add(random.nextInt(100).toDouble());

    for (int i = 1; i < portfolioModel.subPortfolio.length; i++) {
      startPercentage.add(startPercentage[i - 1] + initialValueRatio[i - 1]);
    }

    startPercentage.add(startPercentage[0]);

    List<double> initialValueTemp = [];
    double temp;
    int iTemp;
    bool bTemp;
    for (int i = 0; i < portfolioModel.subPortfolio.length; i++) {
      initialValueTemp.add(getInitialRatioDouble(i));
      orderDrawingItem.add(i);

      if (portfolioModel.subPortfolio[i].stockName.length > maxItemsNameLength)
        drawingMaxLength.add(true);
      else
        drawingMaxLength.add(false);
    }

    for (int i = 0; i < portfolioModel.subPortfolio.length; i++) {
      for (int j = i; j < portfolioModel.subPortfolio.length; j++) {
        if (initialValueTemp[j] > initialValueTemp[i]) {
          temp = initialValueTemp[j];
          initialValueTemp[j] = initialValueTemp[i];
          initialValueTemp[i] = temp;

          bTemp = drawingMaxLength[j];
          drawingMaxLength[j] = drawingMaxLength[i];
          drawingMaxLength[i] = bTemp;

          iTemp = orderDrawingItem[j];
          orderDrawingItem[j] = orderDrawingItem[i];
          orderDrawingItem[i] = iTemp;
        }
      }
    }

    notifyListeners();
  }

  // 어드레스모델이 가리키는 날짜를 가져와서 xxxx.xx.xx 형식으로 변환
  String getDateFormChange() {
    DateTime baseDate = strToDate(addressModel.date);
    String previosBusinessDate = dateToStr(previousBusinessDay(baseDate));
    return previosBusinessDate.substring(0, 4) +
        '.' +
        previosBusinessDate.substring(4, 6) +
        '.' +
        previosBusinessDate.substring(6, 8);
  }

  // 어드레스모델이 가리키는 시즌을 가져와서 SEASON# 형식으로 변환
  String getSeasonUpperCase() {
    String result;
    int seasonNum;

    seasonNum = int.parse(addressModel.season.substring(6, 9));

    result = addressModel.season.toUpperCase().substring(0, 6) +
        ' ' +
        seasonNum.toString();

    return result;
  }

  // 전일종가 기준 포트폴리오 총 가치를 계산하여 ###,###,### 형태로 반환
  String getPortfolioValue() {
    int totalValue = 0;

    for (int i = 0; i < portfolioModel.subPortfolio.length; i++) {
      totalValue += portfolioModel.subPortfolio[i].sharesNum *
          portfolioModel.subPortfolio[i].currentPrice;
    }

    var f = NumberFormat("#,###", "en_US");

    return f.format(totalValue);
  }

  double getPortfolioReturn() {
    int totalValue = 0;
    int initialValue = 0;

    for (int i = 0; i < portfolioModel.subPortfolio.length; i++) {
      totalValue += portfolioModel.subPortfolio[i].sharesNum *
          portfolioModel.subPortfolio[i].currentPrice;
      initialValue += portfolioModel.subPortfolio[i].sharesNum *
          portfolioModel.subPortfolio[i].initialPrice;
    }

    var returnFormat = NumberFormat("##.##%", "en_US");

    return ((totalValue / initialValue) - 1);
    // return 0.123125;
  }

  // 포트폴리우 구성종목의 초기비중을 리턴
  double getInitialRatioDouble(int i) {
    double ratio = (portfolioModel.subPortfolio[i].initialPrice *
            portfolioModel.subPortfolio[i].sharesNum) /
        totalInitialValue.toDouble();

    return ratio;
  }

  // 포트폴리오 구성종목의 초기비중을 리턴 (반올림해서 String으로)
  String getInitialRatio(int i) {
    var f = NumberFormat("##", "en_US");

    return f.format(getInitialRatioDouble(i) * 100) + '%';
  }

  // 튜토리얼이 한 단계 진행되었을 때
  void tutorialStepProgress() {
    tutorialStatus--;

    if (tutorialStatus == 0) {
      _sharedPreferencesService.setSharedPreferencesValue(
          portfolioTutorialKey, true);
    }

    notifyListeners();
  }

  @override
  Future futureToRun() => getPortfolio();
}
