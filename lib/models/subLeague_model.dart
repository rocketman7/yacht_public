import 'dart:convert';
import 'dart:ui'; // offset때매 잠깐 넣어놓음.

import 'package:flutter/foundation.dart';
import 'package:yachtOne/models/quest_model.dart';

// 월간 리그를 구성하는 하나의 서브리그에 대한 정보를 담는 모델.
// 예를 들어 4월 리그의 서브리그로, 소통왕이라는 서브리그가 있을 수 있고 그에 대한 정보를 담는다.
class SubLeagueModel {
  final String name;
  final String description;
  final String comment;
  final List<String> rules;
  final List<SubLeagueStocksModel> stocks;
  // final num totalValue;

  SubLeagueModel({
    required this.name,
    required this.description,
    required this.comment,
    required this.rules,
    required this.stocks,
    // required this.totalValue,
  });

  SubLeagueModel copyWith({
    String? name,
    String? description,
    String? comment,
    List<String>? rules,
    List<SubLeagueStocksModel>? stocks,
    // num? totalValue,
  }) {
    return SubLeagueModel(
      name: name ?? this.name,
      description: description ?? this.description,
      comment: comment ?? this.comment,
      rules: rules ?? this.rules,
      stocks: stocks ?? this.stocks,
      // totalValue: totalValue ?? this.totalValue,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'comment': comment,
      'rules': rules,
      'stocks': stocks.map((x) => x.toMap()).toList(),
      // 'totalValue': totalValue,
    };
  }

  factory SubLeagueModel.fromMap(Map<String, dynamic> map) {
    return SubLeagueModel(
      name: map['name'],
      description: map['description'],
      comment: map['comment'],
      rules: List<String>.from(map['rules']),
      stocks: List<SubLeagueStocksModel>.from(map['stocks']?.map((x) => SubLeagueStocksModel.fromMap(x))),
      // totalValue: map['totalValue'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SubLeagueModel.fromJson(String source) => SubLeagueModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SubLeagueModel(name: $name, description: $description, comment: $comment, rules: $rules, stocks: $stocks)'; //, totalValue: $totalValue)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubLeagueModel &&
        other.name == name &&
        other.description == description &&
        other.comment == comment &&
        listEquals(other.rules, rules) &&
        listEquals(other.stocks, stocks); // &&
    // other.totalValue == totalValue;
  }

  @override
  int get hashCode {
    return name.hashCode ^ description.hashCode ^ comment.hashCode ^ rules.hashCode ^ stocks.hashCode; // ^
    // totalValue.hashCode;
  }
}

// SubLeagueModel 에 담긴 stock 모델
// 즉 SubLeagueModel에는 포트폴리오에 담긴 주식의 갯수만큼 SubLeagueStocksModel list가 존재해야함.
class SubLeagueStocksModel {
  final String field;
  final String country;
  final String issueCode;
  final String name;
  final num sharesNum;
  final num standardPrice;
  SubLeagueStocksModel({
    required this.field,
    required this.country,
    required this.issueCode,
    required this.name,
    required this.sharesNum,
    required this.standardPrice,
  });

  SubLeagueStocksModel copyWith({
    String? field,
    String? country,
    String? issueCode,
    String? name,
    num? sharesNum,
    num? standardPrice,
  }) {
    return SubLeagueStocksModel(
      field: field ?? this.field,
      country: country ?? this.country,
      issueCode: issueCode ?? this.issueCode,
      name: name ?? this.name,
      sharesNum: sharesNum ?? this.sharesNum,
      standardPrice: standardPrice ?? this.standardPrice,
    );
  }

  InvestAddressModel toInvestAddressModel() {
    return InvestAddressModel(
      market: field,
      country: country,
      isIndex: false,
      issueCode: issueCode,
      name: name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'field': field,
      'country': country,
      'issueCode': issueCode,
      'name': name,
      'sharesNum': sharesNum,
      'standardPrice': standardPrice,
    };
  }

  factory SubLeagueStocksModel.fromMap(Map<String, dynamic> map) {
    return SubLeagueStocksModel(
      field: map['field'],
      country: map['country'],
      issueCode: map['issueCode'],
      name: map['name'],
      sharesNum: map['sharesNum'],
      standardPrice: map['standardPrice'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SubLeagueStocksModel.fromJson(String source) => SubLeagueStocksModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SubLeagueStocksModel(field: $field, country: $country, issueCode: $issueCode, name: $name, sharesNum: $sharesNum, standardPrice: $standardPrice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubLeagueStocksModel &&
        other.field == field &&
        other.country == country &&
        other.issueCode == issueCode &&
        other.name == name &&
        other.sharesNum == sharesNum &&
        other.standardPrice == standardPrice;
  }

  @override
  int get hashCode {
    return field.hashCode ^
        country.hashCode ^
        issueCode.hashCode ^
        name.hashCode ^
        sharesNum.hashCode ^
        standardPrice.hashCode;
  }
}

//=======//
// 임시 모델. 나중에 firebase DB와 연동시켜야하고 / models에 만들어야함
// 그리고 copyWith 같은거 있는 표준 폼으로 바꿔야 함
// 하나의 어워드에 대한 정보를 담는다
// class AwardModel {
//   // 필수적으로 있어야 하는 정보들이므로? non-nullable로 선언해준다.
//   final String awardTitle;
//   final String awardDescription;
//   final List<AwardStockModel> awardStockModels;
//   // 모델을 먼저 선언해주고 값들을 나중에 계산해줄 것이기 때문에 nullable로??
//   double totalAwardValue = 0.0;
//   final List<AwardStockUIModel>? awardStockUIModels;
//   // 테마색깔을 정하지 않았을 경우 기본테마색으로. 즉, nullable??
//   final List<String>? awardThemeColors;
//   // 첫번째 인덱스는 슬리버앱바의 타이틀색깔임과 동시에 비중이 가장 높은 종목의 포트폴리오 색깔
//   // 두번째 인덱스는 비중이 두번째로 높은 종목의 포트폴리오 색깔
//   // ....
//   // 우리가 생성하는 어워드의 경우 어워드 종목 갯수만큼의 배열이 존재해야함 (그 이상은 어차피 활용안되고)
//   // #나중에 사용자들이 생성하는 포트폴리오의 경우는 테마색깔을 이런 배열보다는 다른 식으로 구현해야 할 듯

//   AwardModel({
//     required this.awardTitle,
//     required this.awardDescription,
//     required this.awardStockModels,
//     this.totalAwardValue = 0.0,
//     this.awardStockUIModels,
//     this.awardThemeColors,
//   });
// }

// // 임시 모델. 나중에 firebase DB와 연동시켜야하고 / models에 만들어야함
// // 그리고 copyWith 같은거 있는 표준 폼으로 바꿔야 함
// // 어워드를 구성하는 주식 하나하나의 모델
// class AwardStockModel {
//   // 필수적으로 있어야 하는 정보들이므로? non-nullable로 선언해준다.
//   final String stockName; // 주식이름
//   final int sharesNum; // 몇 주?
//   final double currentPrice; // 현재가격 (혹은 가장 최근 종가)

//   AwardStockModel({
//     required this.stockName,
//     required this.sharesNum,
//     required this.currentPrice,
//   });
// }

// // award 포트폴리오 UI에 필요한 모델. award 모델의 갯수만큼 정확히 있어야 함.
// class AwardStockUIModel {
//   // 모델을 먼저 선언해주고 값들을 나중에 계산해줄 것이기 때문에 nullable로??
//   final bool? legendVisible; // 주식명 및 비중 보여줄 것인지
//   final int? roundPercentage; // 정수로 반올림된 퍼센테이지
//   final double? startPercentage; // 원을 0~100으로 봤을 때 어디서 시작?
//   final double? endPercentage; // .. 어디서 끝?
//   final Offset? portionOffsetFromCenter; // 비중의 offset 계산
//   final Offset? stockNameOffsetFromCenter; // 주식명의 offset 계산
//   final dynamic colorCode; // 테마색깔에서 가져올 주식의 고유 색깔

//   AwardStockUIModel(
//       {this.legendVisible = true,
//       this.roundPercentage = 0,
//       this.startPercentage = 0.0,
//       this.endPercentage = 0.0,
//       this.portionOffsetFromCenter = const Offset(0, 0),
//       this.stockNameOffsetFromCenter = const Offset(0, 0),
//       this.colorCode = 'FFFFFF'});
// }