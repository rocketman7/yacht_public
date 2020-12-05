import 'dart:math';

import 'package:stacked/stacked.dart';

import '../models/user_model.dart';
import '../locator.dart';
import '../services/navigation_service.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/sharedPreferences_service.dart';
import '../models/sharedPreferences_const.dart';

List<String> surveyTitles = [
  '주식투자에 대해 어느정도 지식을 가지고 계신가요?',
  '주식투자 경험이 어떻게 되시나요?',
  '주식투자 경험이 없으신 이유는 무엇인가요?',
  '성별이 어떻게 되시나요?',
  '연령대가 어떻게 되시나요?'
];
List<List<String>> surveyChoices = [
  [
    '대부분의 종목이름을 알고,\n전문 서적에 등장할 만한 어려운 수준의 금융용어를 안다.',
    '어느 정도 종목이름을 알고,\n뉴스에 주로 언급되는 수준의 금융 용어를 안다.',
    '종목이름을 잘 모르고,\n주식 용어도 거의 모른다.'
  ],
  ['투자경험 없음', '코로나사태 이후', '1년 이상 3년 미만', '3년 이상'],
  [
    '자금(시드머니)가 부족해서',
    '투자에 대한 두려움(손실에 대한 두려움, 잘 모르는 것에 대한 두려움)',
    '주식보다는 다른 재테크를 선호해서',
    '현재는 주식투자하기 좋은 시기가 아니라고 생각해서',
    '주식투자 경험있음'
  ],
  ['남성', '여성', '대답 안할래요'],
  ['10대', '20대', '30대', '40대', '50대', '60대 이상', '대답 안할래요'],
];

//DB로 옮길것
List<Map<String, String>> tier1 = [
  {'tier': 'tier1', 'code': '068270', 'name': '셀트리온'},
  {'tier': 'tier1', 'code': '091990', 'name': '셀트리온헬스케어'},
  {'tier': 'tier1', 'code': '019170', 'name': '신풍제약'},
  {'tier': 'tier1', 'code': '068760', 'name': '셀트리온제약'},
  {'tier': 'tier1', 'code': '035720', 'name': '카카오'},
  {'tier': 'tier1', 'code': '005380', 'name': '현대차'},
  {'tier': 'tier1', 'code': '000660', 'name': 'SK하이닉스'},
  {'tier': 'tier1', 'code': '096530', 'name': '씨젠'},
  {'tier': 'tier1', 'code': '009830', 'name': '한화솔루션'},
  {'tier': 'tier1', 'code': '008930', 'name': '한미사이언스'},
  {'tier': 'tier1', 'code': '000270', 'name': '기아차'},
  {'tier': 'tier1', 'code': '096770', 'name': 'SK이노베이션'},
  {'tier': 'tier1', 'code': '285130', 'name': 'SK케미칼'},
  {'tier': 'tier1', 'code': '066570', 'name': 'LG전자'},
  {'tier': 'tier1', 'code': '035420', 'name': 'NAVER'},
  {'tier': 'tier1', 'code': '010140', 'name': '삼성중공업'},
  {'tier': 'tier1', 'code': '004020', 'name': '현대제철'},
  {'tier': 'tier1', 'code': '003670', 'name': '포스코케미칼'},
  {'tier': 'tier1', 'code': '005490', 'name': 'POSCO'},
  {'tier': 'tier1', 'code': '034730', 'name': 'SK'},
  {'tier': 'tier1', 'code': '051910', 'name': 'LG화학'},
  {'tier': 'tier1', 'code': '095700', 'name': '제넥신'},
  {'tier': 'tier1', 'code': '005930', 'name': '삼성전자'},
  {'tier': 'tier1', 'code': '034220', 'name': 'LG디스플레이'},
  {'tier': 'tier1', 'code': '009150', 'name': '삼성전기'},
  {'tier': 'tier1', 'code': '011070', 'name': 'LG이노텍'},
  {'tier': 'tier1', 'code': '207940', 'name': '삼성바이오로직스'},
  {'tier': 'tier1', 'code': '128940', 'name': '한미약품'},
  {'tier': 'tier1', 'code': '006400', 'name': '삼성SDI'},
  {'tier': 'tier1', 'code': '000720', 'name': '현대건설'},
  {'tier': 'tier1', 'code': '055550', 'name': '신한지주'},
  {'tier': 'tier1', 'code': '015760', 'name': '한국전력'},
];

List<Map<String, String>> tier2 = [
  {'tier': 'tier2', 'code': '028260', 'name': '삼성물산'},
  {'tier': 'tier2', 'code': '003410', 'name': '쌍용양회'},
  {'tier': 'tier2', 'code': '012330', 'name': '현대모비스'},
  {'tier': 'tier2', 'code': '011200', 'name': 'HMM'},
  {'tier': 'tier2', 'code': '071050', 'name': '한국금융지주'},
  {'tier': 'tier2', 'code': '003490', 'name': '대한항공'},
  {'tier': 'tier2', 'code': '293490', 'name': '카카오게임즈'},
  {'tier': 'tier2', 'code': '251270', 'name': '넷마블'},
  {'tier': 'tier2', 'code': '006280', 'name': '녹십자'},
  {'tier': 'tier2', 'code': '105560', 'name': 'KB금융'},
  {'tier': 'tier2', 'code': '011170', 'name': '롯데케미칼'},
  {'tier': 'tier2', 'code': '036570', 'name': '엔씨소프트'},
  {'tier': 'tier2', 'code': '086790', 'name': '하나금융지주'},
  {'tier': 'tier2', 'code': '017670', 'name': 'SK텔레콤'},
  {'tier': 'tier2', 'code': '086280', 'name': '현대글로비스'},
  {'tier': 'tier2', 'code': '000810', 'name': '삼성화재'},
  {'tier': 'tier2', 'code': '090430', 'name': '아모레퍼시픽'},
  {'tier': 'tier2', 'code': '003550', 'name': 'LG'},
  {'tier': 'tier2', 'code': '009540', 'name': '한국조선해양'},
  {'tier': 'tier2', 'code': '352820', 'name': '빅히트'},
  {'tier': 'tier2', 'code': '051900', 'name': 'LG생활건강'},
  {'tier': 'tier2', 'code': '032830', 'name': '삼성생명'},
  {'tier': 'tier2', 'code': '033780', 'name': 'KT&G'},
  {'tier': 'tier2', 'code': '028300', 'name': '에이치엘비'},
  {'tier': 'tier2', 'code': '000210', 'name': '대림산업'},
  {'tier': 'tier2', 'code': '016360', 'name': '삼성증권'},
  {'tier': 'tier2', 'code': '032640', 'name': 'LG유플러스'},
  {'tier': 'tier2', 'code': '326030', 'name': 'SK바이오팜'},
  {'tier': 'tier2', 'code': '034020', 'name': '두산중공업'},
  {'tier': 'tier2', 'code': '097950', 'name': 'CJ제일제당'},
  {'tier': 'tier2', 'code': '018880', 'name': '한온시스템'},
  {'tier': 'tier2', 'code': '196170', 'name': '알테오젠'},
];

List<Map<String, String>> tier3 = [
  {'tier': 'tier3', 'code': '008770', 'name': '호텔신라'},
  {'tier': 'tier3', 'code': '018260', 'name': '삼성에스디에스'},
  {'tier': 'tier3', 'code': '237690', 'name': '에스티팜'},
  {'tier': 'tier3', 'code': '010130', 'name': '고려아연'},
  {'tier': 'tier3', 'code': '010950', 'name': 'S-Oil'},
  {'tier': 'tier3', 'code': '006360', 'name': 'GS건설'},
  {'tier': 'tier3', 'code': '139480', 'name': '이마트'},
  {'tier': 'tier3', 'code': '030200', 'name': 'KT'},
  {'tier': 'tier3', 'code': '011780', 'name': '금호석유'},
  {'tier': 'tier3', 'code': '011790', 'name': 'SKC'},
  {'tier': 'tier3', 'code': '078340', 'name': '컴투스'},
  {'tier': 'tier3', 'code': '005940', 'name': 'NH투자증권'},
  {'tier': 'tier3', 'code': '316140', 'name': '우리금융지주'},
  {'tier': 'tier3', 'code': '024110', 'name': '기업은행'},
  {'tier': 'tier3', 'code': '240810', 'name': '원익IPS'},
  {'tier': 'tier3', 'code': '336260', 'name': '두산퓨얼셀'},
  {'tier': 'tier3', 'code': '028050', 'name': '삼성엔지니어링'},
  {'tier': 'tier3', 'code': '035250', 'name': '강원랜드'},
  {'tier': 'tier3', 'code': '021240', 'name': '코웨이'},
  {'tier': 'tier3', 'code': '145020', 'name': '휴젤'},
  {'tier': 'tier3', 'code': '039490', 'name': '키움증권'},
  {'tier': 'tier3', 'code': '161390', 'name': '한국타이어앤테크놀로지'},
  {'tier': 'tier3', 'code': '204320', 'name': '만도'},
  {'tier': 'tier3', 'code': '000100', 'name': '유한양행'},
  {'tier': 'tier3', 'code': '032500', 'name': '케이엠더블유'},
  {'tier': 'tier3', 'code': '247540', 'name': '에코프로비엠'},
  {'tier': 'tier3', 'code': '271560', 'name': '오리온'},
  {'tier': 'tier3', 'code': '180640', 'name': '한진칼'},
  {'tier': 'tier3', 'code': '267250', 'name': '현대중공업지주'},
  {'tier': 'tier3', 'code': '185750', 'name': '종근당'},
  {'tier': 'tier3', 'code': '263750', 'name': '펄어비스'},
  {'tier': 'tier3', 'code': '047040', 'name': '대우건설'},
  {'tier': 'tier3', 'code': '307950', 'name': '현대오토에버'},
  {'tier': 'tier3', 'code': '003090', 'name': '대웅'},
  {'tier': 'tier3', 'code': '002790', 'name': '아모레G'},
  {'tier': 'tier3', 'code': '253450', 'name': '스튜디오드래곤'},
];

class SurveyViewModel extends FutureViewModel {
  // Services Setting
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  final SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();

  // 변수 Setting
  String uid;
  UserModel user;

  // 얘는 아는 주식들 고르는거 관리
  bool didBubbleSurvey = false;
  bool allChoice = false;
  final _random = new Random();
  List<int> randomList = [];
  List<String> randomStocks = [];
  List<bool> itemsChoiced = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  // 총 4단계
  List<int> pointsAtStep = [0, 0, 0, 0];
  int bubbleSurveyStep = 0;
  // 얘네는 그 뒤에 basic한 서베이들 관리. 위에꺼가 true가 되어야 발동
  int surveyTotalStep = surveyTitles.length - 1; //5-1 = 4
  int surveyCurrentStep = 0;
  // 아는 주식들 위한 로컬 변수
  List tier1s;
  List tier2s;
  List tier3s;
  // 아는 주식들 답변 디비에 올리기 위한 변수
  int currentTier;
  List<Map<String, String>> bubbleSurveysAnswer = [];
  // basic 서베이 로컬 변수
  Map<String, List> basicSurveys = {
    'title': surveyTitles,
    'choices': surveyChoices
  };
  // basic 서베이 답변 디비에 올리기 위한 변수
  Map<String, List> surveysAnswer = {
    'title': surveyTitles,
    'answer': [],
  };

  // method
  SurveyViewModel() {
    uid = _authService.auth.currentUser.uid;
  }

  // 아는 주식들 서베이 위해, 일정 티어에서 랜덤으로 8개 종목을 픽 (더 이상 모르겠어요 누르거나 최초 실행 시에 트리거됨)
  Future bubbleSurveyRandomPick() async {
    allChoice = false;
    bubbleSurveyStep += 1;
    //고른애들을 넣어준다.
    if (currentTier == 1) {
      for (int i = 0; i < 8; i++) {
        if (itemsChoiced[i]) bubbleSurveysAnswer.add(tier1s[randomList[i]]);
      }
    } else if (currentTier == 2) {
      for (int i = 0; i < 8; i++) {
        if (itemsChoiced[i]) bubbleSurveysAnswer.add(tier2s[randomList[i]]);
      }
    } else if (currentTier == 3) {
      for (int i = 0; i < 8; i++) {
        if (itemsChoiced[i]) bubbleSurveysAnswer.add(tier3s[randomList[i]]);
      }
    }

    //1단계
    if (bubbleSurveyStep == 1) {
      //0단계에서 쓰인 1티어 애들 8개 지워주고
      for (int i = 0; i < randomList.length; i++) {
        tier1s.removeWhere((item) => item['name'] == randomStocks[i]);
      }

      // 점수를 세어준다.
      for (int i = 0; i < itemsChoiced.length; i++) {
        if (itemsChoiced[i]) pointsAtStep[0] += 1;
      }

      // 이제 랜덤리스트 다시 뽑아준다.
      randomList = [];
      randomStocks = [];
      itemsChoiced = [
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
      ];
      // 4점 이하면, 1티어에서 또 8개.
      if (pointsAtStep[0] <= 4) {
        for (int i = 0; i < 8; i += 0) {
          int r = _random.nextInt(tier1s.length);
          print(r);
          if (!randomList.contains(r)) {
            randomList.add(r);
            randomStocks.add(tier1s[r]['name']);
            i++;
          }
        }
        currentTier = 1;
      }
      // 5점 이상이면, 2티어에서 8개
      else {
        for (int i = 0; i < 8; i += 0) {
          int r = _random.nextInt(tier2s.length);
          print(r);
          if (!randomList.contains(r)) {
            randomList.add(r);
            randomStocks.add(tier2s[r]['name']);
            i++;
          }
        }
        currentTier = 2;
      }
    }
    //2단계
    else if (bubbleSurveyStep == 2) {
      //1단계에서 쓰인 1티어 혹은 2티어 애들 8개 지워주고
      if (pointsAtStep[0] <= 4) {
        for (int i = 0; i < randomList.length; i++) {
          tier1s.removeWhere((item) => item['name'] == randomStocks[i]);
        }
      }
      // 5점 이상이면, 2티어에서 지웠을테니 2티어에서 8개 쓴거 지워주고
      else {
        for (int i = 0; i < randomList.length; i++) {
          tier2s.removeWhere((item) => item['name'] == randomStocks[i]);
        }
      }

      // 점수를 세어준다.
      for (int i = 0; i < itemsChoiced.length; i++) {
        if (itemsChoiced[i]) pointsAtStep[1] += 1;
      }

      // 이제 랜덤리스트 다시 뽑아준다.
      randomList = [];
      randomStocks = [];
      itemsChoiced = [
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
      ];

      // 1단계,2단계 모두 점수가 5점 이상이였으면 3티어에서 8개.
      if (pointsAtStep[0] >= 5 && pointsAtStep[1] >= 5) {
        for (int i = 0; i < 8; i += 0) {
          int r = _random.nextInt(tier3s.length);
          print(r);
          if (!randomList.contains(r)) {
            randomList.add(r);
            randomStocks.add(tier3s[r]['name']);
            i++;
          }
        }
        currentTier = 3;
      }
      // 1단계,2단계 모두 4점 이하면 다시 1티어에서 8개
      else if (pointsAtStep[0] <= 4 && pointsAtStep[1] <= 4) {
        for (int i = 0; i < 8; i += 0) {
          int r = _random.nextInt(tier1s.length);
          print(r);
          if (!randomList.contains(r)) {
            randomList.add(r);
            randomStocks.add(tier1s[r]['name']);
            i++;
          }
        }
        currentTier = 1;
      }
      // 그 외에는 2단계에서 8개
      else {
        for (int i = 0; i < 8; i += 0) {
          int r = _random.nextInt(tier2s.length);
          print(r);
          if (!randomList.contains(r)) {
            randomList.add(r);
            randomStocks.add(tier2s[r]['name']);
            i++;
          }
        }
        currentTier = 2;
      }
    } else if (bubbleSurveyStep == 3) {
      //2단계에서 쓰인 1티어 혹은 2티어 혹은 3티어 애들 8개 지워주고
      // 1단계,2단계 모두 점수가 5점 이상이였으면 3티어에서 8개 지워줘야
      if (pointsAtStep[0] >= 5 && pointsAtStep[1] >= 5) {
        for (int i = 0; i < randomList.length; i++) {
          tier3s.removeWhere((item) => item['name'] == randomStocks[i]);
        }
      }
      // 1단계,2단계 모두 4점 이하면 다시 1티어에서 8개 지워줘야
      else if (pointsAtStep[0] <= 4 && pointsAtStep[1] <= 4) {
        for (int i = 0; i < randomList.length; i++) {
          tier1s.removeWhere((item) => item['name'] == randomStocks[i]);
        }
      }
      // 그 외에는 2단계에서 8개 지워줘야
      else {
        for (int i = 0; i < randomList.length; i++) {
          tier2s.removeWhere((item) => item['name'] == randomStocks[i]);
        }
      }

      // 점수를 세어준다.
      for (int i = 0; i < itemsChoiced.length; i++) {
        if (itemsChoiced[i]) pointsAtStep[2] += 1;
      }

      // 이제 랜덤리스트 다시 뽑아준다.
      randomList = [];
      randomStocks = [];
      itemsChoiced = [
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
      ];

      // 1단계,2단계,3단계 모두 점수가 4점 이하였으면 1티어에서 8개.
      int tempPoint = ((pointsAtStep[0] >= 5) ? 1 : -1) +
          ((pointsAtStep[1] >= 5) ? 1 : -1) +
          ((pointsAtStep[2] >= 5) ? 1 : -1);
      if (tempPoint == -3) {
        for (int i = 0; i < 8; i += 0) {
          int r = _random.nextInt(tier1s.length);
          print(r);
          if (!randomList.contains(r)) {
            randomList.add(r);
            randomStocks.add(tier1s[r]['name']);
            i++;
          }
        }
        currentTier = 1;
      }
      // 1~3단계 중 5점 이상인 게 두 개 이상 있으면 3티어에서 8개
      else if (tempPoint >= 1) {
        for (int i = 0; i < 8; i += 0) {
          int r = _random.nextInt(tier3s.length);
          print(r);
          if (!randomList.contains(r)) {
            randomList.add(r);
            randomStocks.add(tier3s[r]['name']);
            i++;
          }
        }
        currentTier = 3;
      }
      // 2티어에서 8개
      else {
        for (int i = 0; i < 8; i += 0) {
          int r = _random.nextInt(tier2s.length);
          print(r);
          if (!randomList.contains(r)) {
            randomList.add(r);
            randomStocks.add(tier2s[r]['name']);
            i++;
          }
        }
        currentTier = 2;
      }
    } else if (bubbleSurveyStep == 4) {
      // 1단계,2단계,3단계 모두 점수가 4점 이하였으면 1티어에서 8개.
      int tempPoint = ((pointsAtStep[0] >= 5) ? 1 : -1) +
          ((pointsAtStep[1] >= 5) ? 1 : -1) +
          ((pointsAtStep[2] >= 5) ? 1 : -1);
      if (tempPoint == -3) {
        for (int i = 0; i < randomList.length; i++) {
          tier1s.removeWhere((item) => item['name'] == randomStocks[i]);
        }
      }
      // 1~3단계 중 5점 이상인 게 두 개 이상 있으면 3티어에서 8개
      else if (tempPoint >= 1) {
        for (int i = 0; i < randomList.length; i++) {
          tier3s.removeWhere((item) => item['name'] == randomStocks[i]);
        }
      }
      // 2티어에서 8개
      else {
        for (int i = 0; i < randomList.length; i++) {
          tier2s.removeWhere((item) => item['name'] == randomStocks[i]);
        }
      }

      // 점수를 세어준다.
      for (int i = 0; i < itemsChoiced.length; i++) {
        if (itemsChoiced[i]) pointsAtStep[3] += 1;
      }

      // 이제 끝. DB에 올려주자
      await _databaseService.updateBubbleSurvey(uid, bubbleSurveysAnswer);

      didBubbleSurvey = true;
    }

    print(pointsAtStep);
    print(bubbleSurveysAnswer);

    notifyListeners();
  }

  // 아는 주식들을 누르는 행위를 하면
  bubbleChoice(int index) {
    itemsChoiced[index] = !itemsChoiced[index];
    allChoice = true;
    for (int i = 0; i < 8; i++) {
      if (!itemsChoiced[i]) {
        allChoice = false;
      }
    }

    notifyListeners();
  }

  // basic서베이 단계 진행할 때마다 호출, & 끝나면,
  Future surveyStepPlus(int answer) async {
    if (surveyCurrentStep < surveyTotalStep) {
      surveysAnswer['answer'].add(answer);
      surveyCurrentStep += 1;
    } else {
      //db업데이트 후 종료
      surveysAnswer['answer'].add(answer);
      await _databaseService.updateSurvey(uid, surveysAnswer);
      await _sharedPreferencesService.setSharedPreferencesValue(
          didSurveyKey, true);

      _navigationService.popAndNavigateWithArgTo('initial');
    }

    notifyListeners();
  }

  @override
  Future futureToRun() async {
    tier1s = tier1;
    tier2s = tier2;
    tier3s = tier3;

    //중복되지 않게 8개의 리스트를 뽑아내야함 (티어 1에서. 최초니까)
    for (int i = 0; i < 8; i += 0) {
      int r = _random.nextInt(tier1s.length);
      print(r);
      if (!randomList.contains(r)) {
        randomList.add(r);
        randomStocks.add(tier1s[r]['name']);
        i++;
      }
    }
    currentTier = 1;
  }
}
