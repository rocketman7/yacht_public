import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

// enum Category { ONE, TWO, THREE }

class QuestModel {
  final String questId;
  final String category;
  final String? themeColor;
  final String? imageUrl;
  final dynamic uploadDateTime;
  final dynamic showHomeDateTime;
  final dynamic closeHomeDateTime;
  final dynamic questStartDateTime;
  final dynamic questEndDateTime;
  final dynamic liveStartDateTime;
  final dynamic liveEndDateTime;
  final dynamic resultDateTime;
  final String title;
  final String questDescription;
  final String selectInstruction;
  final String? rewardDescription;
//선택모드: updown, updownmany, pickone, pickmany, order, 로 나눠서
  final String selectMode;

  final num itemNeeded;
  final num? yachtPointReward;
  final num? leaguePointReward;
  final num? exp;

  final List<InvestAddressModel>? investAddresses;
  // final SurveyModel survey;

  //기본적으로 investAddresses element의 name
  //그러나 category 상승, 하락이면 따로 '상승', '하락' 표기
  final List<String>? choices;
  final List<int>? counts;
  final List<int>? results;
  QuestModel({
    required this.questId,
    required this.category,
    this.themeColor,
    this.imageUrl,
    required this.uploadDateTime,
    required this.showHomeDateTime,
    required this.closeHomeDateTime,
    required this.questStartDateTime,
    required this.questEndDateTime,
    required this.liveStartDateTime,
    required this.liveEndDateTime,
    required this.resultDateTime,
    required this.title,
    required this.questDescription,
    required this.selectInstruction,
    this.rewardDescription,
    required this.selectMode,
    required this.itemNeeded,
    this.yachtPointReward,
    this.leaguePointReward,
    this.exp,
    required this.investAddresses,
    this.choices,
    this.counts,
    this.results,
  });

  QuestModel copyWith({
    String? questId,
    String? category,
    String? term,
    String? themeColor,
    String? imageUrl,
    dynamic uploadDateTime,
    dynamic showHomeDateTime,
    dynamic closeHomeDateTime,
    dynamic questStartDateTime,
    dynamic questEndDateTime,
    dynamic liveStartDateTime,
    dynamic liveEndDateTime,
    dynamic resultDateTime,
    String? title,
    String? questDescription,
    String? selectInstruction,
    String? rewardDescription,
    String? selectMode,
    num? itemNeeded,
    num? yachtPointReward,
    num? leaguePointReward,
    num? exp,
    List<InvestAddressModel>? investAddresses,
    List<String>? choices,
    List<int>? counts,
    List<int>? results,
  }) {
    return QuestModel(
      questId: questId ?? this.questId,
      category: category ?? this.category,
      themeColor: themeColor ?? this.themeColor,
      imageUrl: imageUrl ?? this.imageUrl,
      uploadDateTime: uploadDateTime ?? this.uploadDateTime,
      showHomeDateTime: showHomeDateTime ?? this.showHomeDateTime,
      closeHomeDateTime: closeHomeDateTime ?? this.closeHomeDateTime,
      questStartDateTime: questStartDateTime ?? this.questStartDateTime,
      questEndDateTime: questEndDateTime ?? this.questEndDateTime,
      liveStartDateTime: liveStartDateTime ?? this.liveStartDateTime,
      liveEndDateTime: liveEndDateTime ?? this.liveEndDateTime,
      resultDateTime: resultDateTime ?? this.resultDateTime,
      title: title ?? this.title,
      questDescription: questDescription ?? this.questDescription,
      selectInstruction: selectInstruction ?? this.selectInstruction,
      rewardDescription: rewardDescription ?? this.rewardDescription,
      selectMode: selectMode ?? this.selectMode,
      itemNeeded: itemNeeded ?? this.itemNeeded,
      yachtPointReward: yachtPointReward ?? this.yachtPointReward,
      leaguePointReward: leaguePointReward ?? this.leaguePointReward,
      exp: exp ?? this.exp,
      investAddresses: investAddresses ?? this.investAddresses,
      choices: choices ?? this.choices,
      counts: counts ?? this.counts,
      results: results ?? this.results,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questId': questId,
      'category': category,
      'themeColor': themeColor,
      'imageUrl': imageUrl,
      'uploadDateTime': uploadDateTime,
      'showHomeDateTime': showHomeDateTime,
      'closeHomeDateTime': closeHomeDateTime,
      'questStartDateTime': questStartDateTime,
      'questEndDateTime': questEndDateTime,
      'liveStartDateTime': liveStartDateTime,
      'liveEndDateTime': liveEndDateTime,
      'resultDateTime': resultDateTime,
      'title': title,
      'questDescription': questDescription,
      'selectInstruction': selectInstruction,
      'rewardDescription': rewardDescription,
      'selectMode': selectMode,
      'itemNeeded': itemNeeded,
      'yachtPointReward': yachtPointReward,
      'leaguePointReward': leaguePointReward,
      'exp': exp,
      'investAddresses': investAddresses?.map((x) => x.toMap()).toList(),
      'choices': choices,
      'counts': counts,
      'results': results,
    };
  }

  String showResults() {
    if (results == null) {
      return "아직 결과 발표 전입니다.";
    } else {
      List<String> resultArray = results!.map((e) => choices![e]).toList();
      String temp = "";
      for (int i = 0; i < resultArray.length; i++) {
        if (i != resultArray.length - 1) {
          temp += "${resultArray[i]}, ";
        } else {
          temp += "${resultArray[i]}";
        }
      }

      return temp;
    }
  }

  factory QuestModel.fromMap(String questId, Map<String, dynamic> map, List<InvestAddressModel>? investAddress) {
    return QuestModel(
      questId: questId,
      category: map['category'],
      themeColor: map['themeColor'],
      imageUrl: map['imageUrl'],
      uploadDateTime: map['uploadDateTime'],
      showHomeDateTime: map['showHomeDateTime'],
      closeHomeDateTime: map['closeHomeDateTime'],
      questStartDateTime: map['questStartDateTime'],
      questEndDateTime: map['questEndDateTime'],
      liveStartDateTime: map['liveStartDateTime'],
      liveEndDateTime: map['liveEndDateTime'],
      resultDateTime: map['resultDateTime'],
      title: map['title'],
      questDescription: map['questDescription'],
      selectInstruction: map['selectInstruction'],
      rewardDescription: map['rewardDescription'],
      selectMode: map['selectMode'],
      itemNeeded: map['itemNeeded'],
      yachtPointReward: map['yachtPointReward'],
      leaguePointReward: map['leaguePointReward'],
      exp: map['exp'],
      investAddresses: investAddress,
      choices: map['choices'] == null ? null : List<String>.from(map['choices']),
      counts: map['counts'] == null ? null : List<int>.from(map['counts']),
      results: map['results'] == null ? null : List<int>.from(map['results']),
    );
  }

  String toJson() => json.encode(toMap());

  // factory QuestModel.fromJson(String source) => QuestModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'QuestModel(questId: $questId, category: $category, themeColor: $themeColor, imageUrl: $imageUrl, uploadDateTime: $uploadDateTime, showHomeDateTime: $showHomeDateTime, closeHomeDateTime: $closeHomeDateTime, questStartDateTime: $questStartDateTime, questEndDateTime: $questEndDateTime, liveStartDateTime: $liveStartDateTime, liveEndDateTime: $liveEndDateTime, resultDateTime: $resultDateTime, title: $title, questDescription: $questDescription, selectInstruction: $selectInstruction, rewardDescription: $rewardDescription, selectMode: $selectMode, itemNeeded: $itemNeeded, yachtPointReward: $yachtPointReward, leaguePointReward: $leaguePointReward, exp: $exp, investAddresses: $investAddresses, choices: $choices, counts: $counts, results: $results)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuestModel &&
        other.questId == questId &&
        other.category == category &&
        other.themeColor == themeColor &&
        other.imageUrl == imageUrl &&
        other.uploadDateTime == uploadDateTime &&
        other.showHomeDateTime == showHomeDateTime &&
        other.closeHomeDateTime == closeHomeDateTime &&
        other.questStartDateTime == questStartDateTime &&
        other.questEndDateTime == questEndDateTime &&
        other.liveStartDateTime == liveStartDateTime &&
        other.liveEndDateTime == liveEndDateTime &&
        other.resultDateTime == resultDateTime &&
        other.title == title &&
        other.questDescription == questDescription &&
        other.selectInstruction == selectInstruction &&
        other.rewardDescription == rewardDescription &&
        other.selectMode == selectMode &&
        other.itemNeeded == itemNeeded &&
        other.yachtPointReward == yachtPointReward &&
        other.leaguePointReward == leaguePointReward &&
        other.exp == exp &&
        listEquals(other.investAddresses, investAddresses) &&
        listEquals(other.choices, choices) &&
        listEquals(other.counts, counts) &&
        listEquals(other.results, results);
  }

  @override
  int get hashCode {
    return questId.hashCode ^
        category.hashCode ^
        themeColor.hashCode ^
        imageUrl.hashCode ^
        uploadDateTime.hashCode ^
        showHomeDateTime.hashCode ^
        closeHomeDateTime.hashCode ^
        questStartDateTime.hashCode ^
        questEndDateTime.hashCode ^
        liveStartDateTime.hashCode ^
        liveEndDateTime.hashCode ^
        resultDateTime.hashCode ^
        title.hashCode ^
        questDescription.hashCode ^
        selectInstruction.hashCode ^
        rewardDescription.hashCode ^
        selectMode.hashCode ^
        itemNeeded.hashCode ^
        yachtPointReward.hashCode ^
        leaguePointReward.hashCode ^
        exp.hashCode ^
        investAddresses.hashCode ^
        choices.hashCode ^
        counts.hashCode ^
        results.hashCode;
  }
}

class InvestAddressModel {
  final String market;
  final String country;
  final bool isIndex;
  final String issueCode;
  final String name;
  final String? indexIncluded;
  final String? logoUrl;
  final String? basePrice;
  InvestAddressModel({
    required this.market,
    required this.country,
    required this.isIndex,
    required this.issueCode,
    required this.name,
    this.indexIncluded,
    this.logoUrl,
    this.basePrice,
  });

  InvestAddressModel copyWith({
    String? market,
    String? country,
    bool? isIndex,
    String? issueCode,
    String? name,
    String? indexIncluded,
    String? logoUrl,
    String? basePrice,
  }) {
    return InvestAddressModel(
      market: market ?? this.market,
      country: country ?? this.country,
      isIndex: isIndex ?? this.isIndex,
      issueCode: issueCode ?? this.issueCode,
      name: name ?? this.name,
      indexIncluded: indexIncluded ?? this.indexIncluded,
      logoUrl: logoUrl ?? this.logoUrl,
      basePrice: basePrice ?? this.basePrice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'market': market,
      'country': country,
      'isIndex': isIndex,
      'issueCode': issueCode,
      'name': name,
      'indexIncluded': indexIncluded,
      'logoUrl': logoUrl,
      'basePrice': basePrice,
    };
  }

  factory InvestAddressModel.fromMap(Map<String, dynamic> map) {
    return InvestAddressModel(
      market: map['market'],
      country: map['country'],
      isIndex: map['isIndex'],
      issueCode: map['issueCode'],
      name: map['name'],
      indexIncluded: map['indexIncluded'],
      logoUrl: map['logoUrl'],
      basePrice: map['basePrice'],
    );
  }

  String toJson() => json.encode(toMap());

  factory InvestAddressModel.fromJson(String source) => InvestAddressModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'InvestAddressModel(market: $market, country: $country, isIndex: $isIndex, issueCode: $issueCode, name: $name, indexIncluded: $indexIncluded, logoUrl: $logoUrl, basePrice: $basePrice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InvestAddressModel &&
        other.market == market &&
        other.country == country &&
        other.isIndex == isIndex &&
        other.issueCode == issueCode &&
        other.name == name &&
        other.indexIncluded == indexIncluded &&
        other.logoUrl == logoUrl &&
        other.basePrice == basePrice;
  }

  @override
  int get hashCode {
    return market.hashCode ^
        country.hashCode ^
        isIndex.hashCode ^
        issueCode.hashCode ^
        name.hashCode ^
        indexIncluded.hashCode ^
        logoUrl.hashCode ^
        basePrice.hashCode;
  }
}
