import 'package:get/get.dart';
import 'package:yachtOne/models/quest_model.dart';

import 'package:yachtOne/models/stats_model.dart';
import 'package:yachtOne/screens/stock_info/stock_info_kr_view_model.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:quiver/iterables.dart' as quiver;

class StatsViewModel extends GetxController {
  InvestAddressModel investAddressModel;

  StatsViewModel({
    required this.investAddressModel,
  });

  FirestoreService _firestoreService = FirestoreService();

  List<StatsModel> _stats = [];
  List<StatsModel> _quarterStats = [];
  List<StatsModel> _yearStats = [];
  RxList<StatsModel>? chartStats = RxList<StatsModel>();

  List<StatsModel>? get stats => _stats;
  List<StatsModel>? get quarterStats => _quarterStats;
  List<StatsModel> get yearStats => _yearStats;
  // List<StatsModel> get chartStats => chartStats;

  double? _maxSales, _minSales, _maxOperatingIncome, _minOperatingIncome, _maxNetIncome, _minNetIncome;

  double? get maxSales => _maxSales;
  double? get minSales => _minSales;
  double? get maxOperatingIncome => _maxOperatingIncome;
  double? get minOperatingIncome => _minOperatingIncome;
  double? get maxNetIncome => _maxNetIncome;
  double? get minNetIncome => _minNetIncome;

  // 연간, 분기 토글 스위치 요소들
  List<String> toggleTerms = ["연간", "분기"];
  RxInt selectedTerm = 0.obs;

  // Bar Chart 가로폭
  double width = .7;
  double spacing = 0;
  RxBool isLoading = true.obs;

  void changeInvestAddressModel(InvestAddressModel investAddresses) {
    newStockAddress!(investAddresses);
    // print('name: ${newStockAddress!.value.name}');
    // update();
  }

  @override
  onInit() {
    // TODO: implement onInit
    super.onInit();
    // newStockAddress = investAddressModel.obs;

    // StockInfoKRViewModel().newStockAddress.listen(() { })

    newStockAddress!.listen((value) {
      getStats(value);
    });
    getStats(investAddressModel);
  }

  Future getStats(InvestAddressModel investAddressModel) async {
    isLoading(true);
    List<int> toBeRemoved = [];
    // TODO: 분기, 연간을 토글 스위치로 (캔들차트처럼) 바꿔서 볼 수 있게. 10,11월엔 어떻게 할지?
    // TODO: 막대그래프  스케일 조정
    _stats = [];
    _stats = await _firestoreService.getStats(investAddressModel);
    // print(_statsList);
    // term이 Y이면 같은 year의 Q들의 합을 Y에서 빼주어야 함.
    // 만약 중간에 상장한 기업은 어떻게 처리하나?
    // SK바이오팜으로 체크해봐야 함
    int idx = 0;
    // 1) 4년 전 날짜를 얻어서
    DateTime fourYearsAgo = DateTime.now().subtract(Duration(days: 1460));

    _stats.forEach((element) {
      // print(int.parse(element.year!));
      int temp = int.parse(element.year!);
      // 2) 4년 전 1월 1일보다 이전 데이터의 인덱스들을 저장하고
      if (temp < fourYearsAgo.year) {
        toBeRemoved.add(idx);
      }
      idx++;
    });

    // print(toBeRemoved);
    // 3) 데이터에서 필요 없는 연도 데이터를 지워준다
    if (toBeRemoved.length > 0) _stats.removeRange(toBeRemoved[0], toBeRemoved.last + 1);
    // dateTime 오름차순으로 정렬
    _stats.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
    // print(_statsList![0]);
    // 사업 보고서에서 같은 해 3분기까지 누적치 빼서 4분기 IS data로 생성
    _yearStats = [];
    _quarterStats = [];
    for (int i = 0; i < _stats.length; i++) {
      // if 사업보고서,
      if (_stats[i].term == "Y") {
        _yearStats.add(_stats[i]);
        // 1) 같은 해 3분기 데이터가 있는지 체크하고
        // 2) 있다면 사업보고서 IS 데이터에서 3분기 IS 데이터의 누적치를 빼서 4분기 생성
        // 3) 없다면 상장 해에 보고서가 사업보고서만 있다는 뜻,
        if (i == 0) {
          // 텀이 "Y"인데 맨 첫 인덱스면 그냥 쿼터에 넣는 것.
          _quarterStats.add(_stats[i]);
        } else {
          print('stats check: ${_stats[i]}');
          StatsModel temp = _stats[i].copyWith(
              salesIS: (_stats[i].salesIS == null || _stats[i - 1].salesAccIS == null)
                  ? null
                  : _stats[i].salesIS! - _stats[i - 1].salesAccIS!,
              operatingIncomeIS: (_stats[i].operatingIncomeIS == null || _stats[i - 1].operatingIncomeIS == null)
                  ? null
                  : _stats[i].operatingIncomeIS! - _stats[i - 1].operatingIncomeAccIS!,
              incomeBeforeTaxesIS: (_stats[i].incomeBeforeTaxesIS == null || _stats[i - 1].incomeBeforeTaxesIS == null)
                  ? null
                  : _stats[i].incomeBeforeTaxesIS! - _stats[i - 1].incomeBeforeTaxesAccIS!,
              netIncomeIS: (_stats[i].netIncomeIS == null || _stats[i - 1].netIncomeIS == null)
                  ? null
                  : _stats[i].netIncomeIS! - _stats[i - 1].netIncomeAccIS!,
              term: "Q",
              dateTime: _stats[i].year! + "1231");
          _quarterStats.add(temp);
        }
      } else {
        _quarterStats.add(_stats[i]);
      }
    }
    // print(_yearStatsList[0].toJson());
    // var a = _yearStats[0].toMap();
    // print(a['salesIS']);
    isLoading(false);
    changeTerm();
    // print(chartStats);
    update();
  }

  void changeTerm() {
    switch (toggleTerms[selectedTerm.value]) {
      case "분기":
        chartStats!(_quarterStats);
        // print(chartStats);
        Set<String> temp = Set();
        for (StatsModel chartStat in chartStats!) {
          temp.add(chartStat.year!);
        }

        switch (temp.length) {
          case 5:
            width = .7;
            break;
          case 4:
            width = .65;
            break;
          case 3:
            width = .6;
            break;
          case 2:
            width = .5;
            break;
          default:
            width = .5;
        }
        // 분기 width:
        // year length가 5 -> .7
        // 4 -> .65 , 3-> .6
        // 2- > .5 , 1-> .5
        calculateMaxMin();
        update();
        break;
      case "연간":
        chartStats!(_yearStats);
        switch (chartStats!.length) {
          case 5:
            width = .5;
            break;
          case 4:
            width = .5;
            break;
          case 3:
            width = .4;
            break;
          case 2:
            width = .35;
            break;
          default:
            width = .15;
        }
        // 연간 width;
        // length가 1 => .15
        //         4 => .5  linear하게

        calculateMaxMin();
        update();
        break;
    }
  }

  void calculateMaxMin() {
    List<num> sales = [];
    List<num> opeartingIncomes = [];
    List<num> netIncomes = [];

    chartStats!.forEach((element) {
      if (element.salesIS != null) {
        sales.add(element.salesIS!);
      }
      if (element.operatingIncomeIS != null) {
        opeartingIncomes.add(element.operatingIncomeIS!);
      }
      if (element.netIncomeIS != null) {
        netIncomes.add(element.netIncomeIS!);
      }
    });
    print(opeartingIncomes);

    _maxSales = quiver.max(sales)! * 1.00;
    _minSales = quiver.min(sales)! * 1.00;
    // print(_minSales);
    _maxOperatingIncome = quiver.max(opeartingIncomes)! * 1.00;

    _minOperatingIncome = quiver.min(opeartingIncomes)! * 1.00;
    print(_minOperatingIncome);
    _maxNetIncome = quiver.max(netIncomes)! * 1.00;
    _minNetIncome = quiver.min(netIncomes)! * 1.00;
  }

  // 연간 width;
  // length가 1 => .15
  //         4 => .5  linear하게

  // 분기 width:
  // year length가 5 -> .7
  // 4 -> .65 , 3-> .6
  // 2- > .5 , 1-> .5
}
