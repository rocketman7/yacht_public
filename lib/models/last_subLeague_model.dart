import 'subLeague_model.dart';

class LastSubLeagueModel {
  final String name;
  final String description;
  final String comment;
  final List<String> rules;
  final List<SubLeagueStocksModel> stocks;
  final String leagueName;
  final String leagueEndDateTime;
  final String leagueUid;
  final String subLeagueUid;
  final String docId;
  double? totalValue;

  LastSubLeagueModel({
    required this.name,
    required this.description,
    required this.comment,
    required this.rules,
    required this.stocks,
    required this.leagueName,
    required this.leagueEndDateTime,
    required this.leagueUid,
    required this.subLeagueUid,
    required this.docId,
  });

  factory LastSubLeagueModel.fromMap(Map<String, dynamic> map, String id) {
    return LastSubLeagueModel(
      name: map['name'],
      description: map['description'],
      comment: map['comment'],
      rules: List<String>.from(map['rules']),
      stocks: List<SubLeagueStocksModel>.from(
          map['stocks']?.map((x) => SubLeagueStocksModel.fromMap(x))),
      leagueName: map['leagueName'],
      leagueEndDateTime: map['leagueEndDateTime'],
      leagueUid: map['leagueUid'],
      subLeagueUid: map['subLeagueUid'],
      docId: id,
    );
  }
}

class FinalRankModel {
  final String uid;
  final String userName;
  final String? avatarImage;
  final num todayRank;
  final num todayPoint;
  final bool awarded;
  final List<AwardModel> award;

  FinalRankModel({
    required this.uid,
    required this.userName,
    this.avatarImage,
    required this.todayRank,
    required this.todayPoint,
    required this.awarded,
    required this.award,
  });

  factory FinalRankModel.fromMap(Map<String, dynamic> map) {
    return FinalRankModel(
      uid: map['uid'],
      userName: map['userName'],
      avatarImage: map['avatarImage'] ?? null,
      todayRank: map['todayRank'],
      todayPoint: map['todayPoint'],
      awarded: map['awarded'],
      award: List<AwardModel>.from(
          map['award']?.map((x) => AwardModel.fromMap(x))),
    );
  }
}

class AwardModel {
  final bool isStock;
  final num? stocksIndex;
  final num? sharesNum;
  final num? yachtPoint;

  AwardModel({
    required this.isStock,
    this.stocksIndex,
    this.sharesNum,
    this.yachtPoint,
  });

  factory AwardModel.fromMap(Map<String, dynamic> map) {
    return AwardModel(
      isStock: map['isStock'],
      stocksIndex: map['stocksIndex'] ?? 0,
      sharesNum: map['sharesNum'] ?? 0,
      yachtPoint: map['yachtPoint'] ?? 0,
    );
  }
}
