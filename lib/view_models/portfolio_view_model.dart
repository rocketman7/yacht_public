import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'dart:math' as math;

import '../locator.dart';
import '../models/portfolio_model.dart';
import '../models/database_address_model.dart';
import '../models/season_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';

class PortfolioViewModel extends FutureViewModel {
  // Services Setting
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();

  // 변수 Setting
  DatabaseAddressModel addressModel;
  PortfolioModel portfolioModel;
  SeasonModel seasonModel;
  String uid;

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

  PortfolioViewModel() {
    uid = _authService.auth.currentUser.uid;
  }

  // method
  // 포트폴리오 DB로부터 얻어오기 + UI용 변수들 계산
  Future getPortfolio() async {
    addressModel = await _databaseService.getAddress(uid);
    portfolioModel = await _databaseService.getPortfolio(addressModel);
    seasonModel = await _databaseService.getSeasonInfo(addressModel);

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
      if (maxOfMaxMin >= 0) {
        valueIncreaseRatio[i] = 2 + valueIncreaseRatio[i] / maxOfMaxMin;
      } else {
        valueIncreaseRatio[i] = 2 - valueIncreaseRatio[i] / maxOfMaxMin;
      }
    }

    // Arc의 시작점을 설정해주고, 나머지도 초기비중에 맞게 호의 길이만큼 설정해주는 작업
    final random = math.Random();

    startPercentage.add(random.nextInt(100).toDouble());

    for (int i = 1; i < portfolioModel.subPortfolio.length; i++) {
      startPercentage.add(startPercentage[i - 1] + initialValueRatio[i - 1]);
    }

    startPercentage.add(startPercentage[0]);

    // 글자수에 맞게 아이템을 그릴 순서를 정렬해주자.
    // List<int> orderDrawingItemTemp = [];
    // for (int i = 0; i < portfolioModel.subPortfolio.length; i++) {
    //   if (portfolioModel.subPortfolio[i].stockName.length >
    //       maxItemsNameLength + 1) {
    //     orderDrawingItemTemp.add(i + portfolioModel.subPortfolio.length);
    //   } else {
    //     orderDrawingItemTemp.add(i);
    //   }
    // }

    // for (int i = 0; i < portfolioModel.subPortfolio.length; i++) {
    //   if (orderDrawingItemTemp[i] < portfolioModel.subPortfolio.length) {
    //     orderDrawingItem.add(i);
    //     drawingMaxLength.add(false);
    //   }
    // }

    // for (int i = 0; i < portfolioModel.subPortfolio.length; i++) {
    //   if (orderDrawingItemTemp[i] >= portfolioModel.subPortfolio.length) {
    //     orderDrawingItem.add(i);
    //     drawingMaxLength.add(true);
    //   }
    // }

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
      print(portfolioModel.subPortfolio[i].stockName);
    }
    print(initialValueTemp);
    print(orderDrawingItem);
    print(drawingMaxLength);

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

    for (int i = 0; i < portfolioModel.subPortfolio.length; i++) {
      print(portfolioModel.subPortfolio[i].stockName);
    }
    print(initialValueTemp);
    print(orderDrawingItem);
    print(drawingMaxLength);

    // for (int i = 0; i < portfolioModel.subPortfolio.length; i++) {
    //   print(initialValueTemp[i]);
    //   print(drawingMaxLength[i]);
    // }

    // print(orderDrawingItem);

    // orderDrawingItem.add(0);
    // orderDrawingItem.add(1);
    // orderDrawingItem.add(2);
    // orderDrawingItem.add(3);
    // orderDrawingItem.add(4);

    notifyListeners();
  }

  // 어드레스모델이 가리키는 날짜를 가져와서 xxxx.xx.xx 형식으로 변환
  String getDateFormChange() {
    return addressModel.date.substring(0, 4) +
        '.' +
        addressModel.date.substring(4, 6) +
        '.' +
        addressModel.date.substring(6, 8);
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

  @override
  Future futureToRun() => getPortfolio();
}
