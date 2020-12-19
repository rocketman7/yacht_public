class UserRewardModel {
  final String id; // 리워드콜렉션의 하위 다큐먼트 아이디.
  final String rewardTitle; // 받은 상금의 타이틀 ex) '시즌1 우승', '시즌2 베스트댓글'
  final String awardDate; // 상금 받은 시점 ex) '20201221';
  final bool isTax; // 원천징수해야하는지;
  final int deliveryStatus; // 상금의 출고 상태를 표현, 1 = 아직 출고 전, 0 = 출고 중, -1 = 출고됨
  final List<RewardModel> listOfAward; // 상금포트폴리오의 리스트

  UserRewardModel(this.id, this.rewardTitle, this.awardDate, this.isTax,
      this.deliveryStatus, this.listOfAward);

  UserRewardModel.fromData(
      String docId, Map<String, dynamic> data, List<RewardModel> listOfAward)
      : id = docId ?? null,
        rewardTitle = data['rewardTitle'] ?? null,
        awardDate = data['awardDate'] ?? null,
        isTax = data['isTax'] ?? null,
        deliveryStatus = data['deliveryStatus'] ?? null,
        listOfAward = listOfAward ?? null;
}

class RewardModel {
  final String issueCode; // = '018880';
  final String stockName; // = '한온시스템';
  final int sharesNum; // = 6;
  final double priceAtAward; // = 15250.0;
  // priceAtAward는 두 가지 방식으로 작동.
  // 출고되기 전 주식의 경우는 실제 상금을 받았을 때의 최초 가치 (보관한 동안의 수익률을 구해주기 위함), 수익률은 historicalPrice에서 매번 접근해주면 될듯
  // 출고된 후의 주식의 경우는 출고할 때의 가치, 이 때는 수익률 구하기 위해 historicalPrice 갈 필요 없음.

  RewardModel(
      this.issueCode, this.stockName, this.sharesNum, this.priceAtAward);

  RewardModel.fromData(Map<String, dynamic> data)
      : issueCode = data['issueCode'] ?? null,
        stockName = data['stockName'] ?? null,
        sharesNum = data['sharesNum'] ?? null,
        priceAtAward = data['priceAtAward'].toDouble() ?? null;
}
