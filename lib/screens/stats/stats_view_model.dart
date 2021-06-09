import 'package:get/get.dart';
import 'package:yachtOne/models/stats_model.dart';
import 'package:yachtOne/services/firestore_service.dart';

class StatsViewModel extends GetxController {
  FirestoreService _firestoreService = FirestoreService();
  List<StatsModel>? _statsList;
  List<StatsModel> _quarterStatsList = [];
  List<StatsModel> _yearStatsList = [];

  List<StatsModel>? get statsList => _statsList;
  List<StatsModel>? get quarterStatsList => _quarterStatsList;
  List<StatsModel> get yearStatsList => _yearStatsList;

  bool isFetching = true;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    return fetchStats();
  }

  void fetchStats() async {
    List<int> toBeRemoved = [];
    _statsList = await _firestoreService.getStats();
    // print(_statsList);
    // term이 Y이면 같은 year의 Q들의 합을 Y에서 빼주어야 함.
    // 만약 중간에 상장한 기업은 어떻게 처리하나?
    // SK바이오팜으로 체크해봐야 함
    int idx = 0;
    // 1) 3년 전 날짜를 얻어서
    DateTime threeYearsAgo = DateTime.now().subtract(Duration(days: 1095));

    _statsList!.forEach((element) {
      // print(int.parse(element.year!));
      int temp = int.parse(element.year!);
      // 2) 3년 전 1월 1일보다 이전 데이터의 인덱스들을 저장하고
      if (temp < threeYearsAgo.year) {
        toBeRemoved.add(idx);
      }
      idx++;
    });
    // print(toBeRemoved);
    // 3) 데이터에서 필요 없는 연도 데이터를 지워준다
    if (toBeRemoved.length > 0)
      _statsList!.removeRange(toBeRemoved[0], toBeRemoved.last + 1);
    // dateTime 오름차순으로 정렬
    _statsList!.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
    // print(_statsList![0]);
    // 사업 보고서에서 같은 해 3분기까지 누적치 빼서 4분기 IS data로 생성
    for (int i = 0; i < _statsList!.length; i++) {
      // if 사업보고서,
      if (_statsList![i].term == "Y") {
        _yearStatsList.add(_statsList![i]);
        // 1) 같은 해 3분기 데이터가 있는지 체크하고
        // 2) 있다면 사업보고서 IS 데이터에서 3분기 IS 데이터의 누적치를 빼서 4분기 생성
        // 3) 없다면 상장 해에 보고서가 사업보고서만 있다는 뜻,
        if (i == 0) {
          _quarterStatsList.add(_statsList![i]);
        } else {
          StatsModel temp = _statsList![i].copyWith(
              salesIS: _statsList![i].salesIS! - _statsList![i - 1].salesAccIS!,
              operatingIncomeIS: _statsList![i].operatingIncomeIS! -
                  _statsList![i - 1].operatingIncomeAccIS!,
              incomeBeforeTaxesIS: _statsList![i].incomeBeforeTaxesIS! -
                  _statsList![i - 1].incomeBeforeTaxesAccIS!,
              netIncomeIS: _statsList![i].netIncomeIS! -
                  _statsList![i - 1].netIncomeAccIS!,
              term: "Q",
              dateTime: _statsList![i].year! + "1231");
          _quarterStatsList.add(temp);
        }
      } else {
        _quarterStatsList.add(_statsList![i]);
      }
    }
    // print(_yearStatsList[0].toJson());
    var a = _yearStatsList[0].toMap();
    print(a['salesIS']);
    isFetching = false;
    update();
  }
}
