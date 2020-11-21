import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:yachtOne/models/stats_model.dart';

class IndexInfoModel {
  final String name;
  final String stocksOrIndex;
  final String issueCode;
  final String marketCode;
  final String descriptionTitle;
  final String description;
  final int marketCap;
  final double per;
  final int numOfListed;
  final dynamic indexBaseDate;
  final num indexBasePoint;
  final String methodology;
  final dynamic updatedAt;
  List<ListedStockModel> topListed;
  IndexInfoModel({
    this.name,
    this.stocksOrIndex,
    this.issueCode,
    this.marketCode,
    this.descriptionTitle,
    this.description,
    this.marketCap,
    this.per,
    this.numOfListed,
    this.indexBaseDate,
    this.indexBasePoint,
    this.methodology,
    this.updatedAt,
    this.topListed,
  });

  IndexInfoModel copyWith({
    String name,
    String stocksOrIndex,
    String issueCode,
    String marketCode,
    String descriptionTitle,
    String description,
    int marketCap,
    double per,
    int numOfListed,
    dynamic indexBaseDate,
    double indexBasePoint,
    String methodology,
    dynamic updatedAt,
    List<ListedStockModel> topListed,
  }) {
    return IndexInfoModel(
      name: name ?? this.name,
      stocksOrIndex: stocksOrIndex ?? this.stocksOrIndex,
      issueCode: issueCode ?? this.issueCode,
      marketCode: marketCode ?? this.marketCode,
      descriptionTitle: descriptionTitle ?? this.descriptionTitle,
      description: description ?? this.description,
      marketCap: marketCap ?? this.marketCap,
      per: per ?? this.per,
      numOfListed: numOfListed ?? this.numOfListed,
      indexBaseDate: indexBaseDate ?? this.indexBaseDate,
      indexBasePoint: indexBasePoint ?? this.indexBasePoint,
      methodology: methodology ?? this.methodology,
      updatedAt: updatedAt ?? this.updatedAt,
      topListed: topListed ?? this.topListed,
    );
  }

  IndexInfoModel addWith(IndexInfoModel tempModel) {
    return IndexInfoModel(
      name: tempModel.name ?? this.name,
      stocksOrIndex: tempModel.stocksOrIndex ?? this.stocksOrIndex,
      issueCode: tempModel.issueCode ?? this.issueCode,
      marketCode: tempModel.marketCode ?? this.marketCode,
      descriptionTitle: tempModel.descriptionTitle ?? this.descriptionTitle,
      description: tempModel.description ?? this.description,
      marketCap: tempModel.marketCap ?? this.marketCap,
      per: tempModel.per ?? this.per,
      numOfListed: tempModel.numOfListed ?? this.numOfListed,
      indexBaseDate: tempModel.indexBaseDate ?? this.indexBaseDate,
      indexBasePoint: tempModel.indexBasePoint ?? this.indexBasePoint,
      methodology: tempModel.methodology ?? this.methodology,
      updatedAt: tempModel.updatedAt ?? this.updatedAt,
      topListed: tempModel.topListed ?? this.topListed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'stocksOrIndex': stocksOrIndex,
      'issueCode': issueCode,
      'marketCode': marketCode,
      'descriptionTitle': descriptionTitle,
      'description': description,
      'marketCap': marketCap,
      'per': per,
      'numOfListed': numOfListed,
      'indexBaseDate': indexBaseDate,
      'indexBasePoint': indexBasePoint,
      'methodology': methodology,
      'updatedAt': updatedAt,
      'topListed': topListed?.map((x) => x?.toJson())?.toList(),
    };
  }

  factory IndexInfoModel.fromData(Map<String, dynamic> data) {
    if (data == null) return null;
    return IndexInfoModel(
      name: data['name'],
      stocksOrIndex: data['stocksOrIndex'],
      issueCode: data['issueCode'],
      marketCode: data['marketCode'],
      descriptionTitle: data['descriptionTitle'],
      description: data['description'],
      marketCap: data['marketCap'],
      per: data['per'],
      numOfListed: data['numOfListed'],
      indexBaseDate: data['indexBaseDate'],
      indexBasePoint: data['indexBasePoint'],
      methodology: data['methodology'],
      updatedAt: data['updatedAt'],
      topListed: data['topListed'],
    );
  }

  @override
  String toString() {
    return 'IndexInfoModel(name: $name, stocksOrIndex: $stocksOrIndex, issueCode: $issueCode, marketCode: $marketCode, descriptionTitle: $descriptionTitle, description: $description, marketCap: $marketCap, per: $per, numOfListed: $numOfListed, indexBaseDate: $indexBaseDate, indexBasePoint: $indexBasePoint, methodology: $methodology, updatedAt: $updatedAt, topListed: $topListed)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return o is IndexInfoModel &&
        o.name == name &&
        o.stocksOrIndex == stocksOrIndex &&
        o.issueCode == issueCode &&
        o.marketCode == marketCode &&
        o.descriptionTitle == descriptionTitle &&
        o.description == description &&
        o.marketCap == marketCap &&
        o.per == per &&
        o.numOfListed == numOfListed &&
        o.indexBaseDate == indexBaseDate &&
        o.indexBasePoint == indexBasePoint &&
        o.methodology == methodology &&
        o.updatedAt == updatedAt &&
        listEquals(o.topListed, topListed);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        stocksOrIndex.hashCode ^
        issueCode.hashCode ^
        marketCode.hashCode ^
        descriptionTitle.hashCode ^
        description.hashCode ^
        marketCap.hashCode ^
        per.hashCode ^
        numOfListed.hashCode ^
        indexBaseDate.hashCode ^
        indexBasePoint.hashCode ^
        methodology.hashCode ^
        updatedAt.hashCode ^
        topListed.hashCode;
  }
}

class ListedStockModel {
  final String name;
  final int marketCap;
  final double weight;
  ListedStockModel({
    this.name,
    this.marketCap,
    this.weight,
  });

  ListedStockModel copyWith({
    String name,
    int marketCap,
    double weight,
  }) {
    return ListedStockModel(
      name: name ?? this.name,
      marketCap: marketCap ?? this.marketCap,
      weight: weight ?? this.weight,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'marketCap': marketCap,
      'weight': weight,
    };
  }

  factory ListedStockModel.fromData(Map<String, dynamic> data) {
    if (data == null) return null;

    return ListedStockModel(
      name: data['name'],
      marketCap: data['marketCap'],
      weight: data['weight'],
    );
  }

  @override
  String toString() =>
      'ListedStockModel(name: $name, marketCap: $marketCap, weight: $weight)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ListedStockModel &&
        o.name == name &&
        o.marketCap == marketCap &&
        o.weight == weight;
  }

  @override
  int get hashCode => name.hashCode ^ marketCap.hashCode ^ weight.hashCode;
}
