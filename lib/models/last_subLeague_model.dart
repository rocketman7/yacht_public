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
  });

  factory LastSubLeagueModel.fromMap(Map<String, dynamic> map) {
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
    );
  }
}
