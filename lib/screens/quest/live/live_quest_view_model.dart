import 'package:get/get.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/models/chart_price_model.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/models/live_quest_price_model.dart';
import 'package:yachtOne/repositories/repository.dart';

import 'package:yachtOne/screens/home/home_view_model.dart';
import 'package:yachtOne/services/firestore_service.dart';

import '../../../locator.dart';

class LiveQuestViewModel extends GetxController {
  final HomeViewModel homeViewModel;
  LiveQuestViewModel({
    required this.homeViewModel,
  });

  //// 라이브 위젯에 가격을 받아오기 위해서 해야 하는 것들
  /// 1. livePrices를 List of List로 설정
  /// 라이브 퀘스트 i개, 각 i번 째 퀘스트의 j개 AddressModel
  /// initial 함수는 Rx value에 스트림을 binding하기 위해 널 데이터로 자리를 만들어주는 것
  /// 2. investAddresses를 List of List로 설정
  /// investAddress 들 역시 뷰 생성 과정에서 livePrices와 같은 모양으로 만들어준다.
  /// 이러면 realTimePriceStream을 실행할 때 각 리스트 주소에 맞게 binding을 할 수 있고
  /// 이를 바탕으로 라이브 위젯에서 각 가격 데이터들을 가져와서 차트로 뿌릴 수 있음

  List<List<Rx<LiveQuestPriceModel>>> livePrices = <List<Rx<LiveQuestPriceModel>>>[];

  List<List<InvestAddressModel>> investAddresses = [];
  RxList<int> eachQuestLiveDays = <int>[].obs;
  final FirestoreService _firestoreService = locator<FirestoreService>();

  LiveQuestPriceModel initial(InvestAddressModel investAddressModel) {
    return LiveQuestPriceModel(issueCode: investAddressModel.issueCode, chartPrices: [
      ChartPriceModel(
        dateTime: "20210101",
        cycle: "10M",
      )
    ]);
  }

  @override
  void onInit() async {
    getListStreamPriceModel(homeViewModel.liveQuests);
    // realTimePriceStream(homeViewModel.liveQuests[0].investAddresses);
    // homeViewModel.liveQuests.listen((val) {
    //   if (val.length > 0) {
    //     print('get live');
    //     getListStreamPriceModel(homeViewModel.liveQuests);
    //   }
    // });
    // getListStreamPriceModel(homeViewModel.liveQuests[0].investAddresses);

    super.onInit();
  }

  // 라이브 퀘스트에 쓰일 모든 종목 정보들 가져오기
  void makeInvestAddressList() {
    for (int i = 0; i < homeViewModel.liveQuests.length; i++) {
      List<InvestAddressModel> tempAddress = [];
      List<Rx<LiveQuestPriceModel>> tempPrices = [];
      for (int j = 0; j < homeViewModel.liveQuests[i].investAddresses!.length; j++) {
        // print(j);
        tempAddress.add(homeViewModel.liveQuests[i].investAddresses![j]);
        tempPrices.add(Rx<LiveQuestPriceModel>(initial(tempAddress[j])));
      }
      investAddresses.add(tempAddress);
      livePrices.add(tempPrices);
    }
  }

  // Stream<List<LiveQuestPriceModel>> realTimePriceStream(List<InvestAddressModel> investAddresses) {
  //   // print('live stream started: $investAddresses');
  //   // Stream<List<LiveQuestPriceModel>> livePrices = _firestoreService.getLiveQuestPrices(investAddresses);
  //   return _firestoreService.getLiveQuestPrices(investAddresses);
  // }

  getListStreamPriceModel(List<QuestModel> liveQuests) {
    print("get stream price model");

    // print('stream triggered');
    // print(liveQuests);
    makeInvestAddressList();
    // livePrices = List.generate(investAddresses.length, (index) {
    //   return Rx<LiveQuestPriceModel>(initial(investAddresses[index]));
    // });
    // print(livePrices);
    // print(liveQuests);
    // print(liveQuests[0].investAddresses![0].name);
    for (int i = 0; i < liveQuests.length; i++) {
      for (int j = 0; j < liveQuests[i].investAddresses!.length; j++) {
        livePrices[i][j].bindStream(_firestoreService.getStreamLiveQuestPrice(
          investAddresses[i][j],
          liveQuests[i],
        ));
        livePrices[i][j].refresh();

        // print(livePrices[i][j]);

        print(numberOfBusinessDay(liveQuests[i].liveStartDateTime.toDate(), liveQuests[i].liveEndDateTime.toDate()));
      }
    }

    // 1. 한 카드에 보여줄 InvestAddress List 필요 (n개 가정) Map 이용
    // 2. 각 종목의 realtime price Stream으로 받아와야 함
    // 3. 해당 리스트트들을 normalise 해서 새롭게 노말라이즈 된 리스트 n개 만들어야 함 (RxList)
    // 4. View에서 그 리스트들을 dataSource로 각각 색으로 그리기

    // live quest에 넣을 length: n
    // 각 위젯에 List<LiveQuestPriceModel>를 Rx로 만든다
    //
    // [{issueCode: '005930', chartPrices: List<PRICES>},
    // {issueCode: '000030', chartPrices: List<PRICES>},
    // {issueCode: '005310', chartPrices: List<PRICES>},]

    // {'005930' : List<PRICES>, '001230' : List<PRICES>, }
  }
}
