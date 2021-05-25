import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:yachtOne/models/stats_model.dart';

class StockInfoModel {
  final String? name;
  final String? stocksOrIndex;
  final String? issueCode;
  final String? marketCode;
  final String? descriptionTitle;
  final String? description;
  final int? marketCap;
  final double? per;
  final int? revenue;
  final int? operatingIncome;
  final int? netIncome;
  final num? latestEps;
  final String? ceo;
  final int? employees;
  final int? avrSalary;
  final String? avrWorkingYears;
  final String? foundedIn;
  final String? announcedAt;
  final dynamic uploadedAt;
  final List<dynamic>? tags;
  dynamic news;
  List<StatsModel>? stats;
  final String? credit;
  StockInfoModel({
    this.name,
    this.stocksOrIndex,
    this.issueCode,
    this.marketCode,
    this.descriptionTitle,
    this.description,
    this.marketCap,
    this.per,
    this.revenue,
    this.operatingIncome,
    this.netIncome,
    this.latestEps,
    this.ceo,
    this.employees,
    this.avrSalary,
    this.avrWorkingYears,
    this.foundedIn,
    this.announcedAt,
    this.uploadedAt,
    this.tags,
    this.news,
    this.stats,
    this.credit,
  });

  StockInfoModel copyWith({
    String? name,
    String? stocksOrIndex,
    String? issueCode,
    String? marketCode,
    String? descriptionTitle,
    String? description,
    int? marketCap,
    double? per,
    int? revenue,
    int? operatingIncome,
    int? netIncome,
    int? latestEps,
    String? ceo,
    int? employees,
    int? avrSalary,
    String? avrWorkingYears,
    String? foundedIn,
    String? announcedAt,
    dynamic uploadedAt,
    List<dynamic>? tags,
    dynamic news,
    List<StatsModel>? stats,
    String? credit,
  }) {
    return StockInfoModel(
      name: name ?? this.name,
      stocksOrIndex: stocksOrIndex ?? this.stocksOrIndex,
      issueCode: issueCode ?? this.issueCode,
      marketCode: marketCode ?? this.marketCode,
      descriptionTitle: descriptionTitle ?? this.descriptionTitle,
      description: description ?? this.description,
      marketCap: marketCap ?? this.marketCap,
      per: per ?? this.per,
      revenue: revenue ?? this.revenue,
      operatingIncome: operatingIncome ?? this.operatingIncome,
      netIncome: netIncome ?? this.netIncome,
      latestEps: latestEps ?? this.latestEps,
      ceo: ceo ?? this.ceo,
      employees: employees ?? this.employees,
      avrSalary: avrSalary ?? this.avrSalary,
      avrWorkingYears: avrWorkingYears ?? this.avrWorkingYears,
      foundedIn: foundedIn ?? this.foundedIn,
      announcedAt: announcedAt ?? this.announcedAt,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      tags: tags ?? this.tags,
      news: news ?? this.news,
      stats: stats ?? this.stats,
      credit: credit ?? this.credit,
    );
  }

  StockInfoModel addWith(StockInfoModel tempModel) {
    return StockInfoModel(
      name: tempModel.name ?? this.name,
      stocksOrIndex: tempModel.stocksOrIndex ?? this.stocksOrIndex,
      issueCode: tempModel.issueCode ?? this.issueCode,
      marketCode: tempModel.marketCode ?? this.marketCode,
      descriptionTitle: tempModel.descriptionTitle ?? this.descriptionTitle,
      description: tempModel.description ?? this.description,
      marketCap: tempModel.marketCap ?? this.marketCap,
      per: tempModel.per ?? this.per,
      revenue: tempModel.revenue ?? this.revenue,
      operatingIncome: tempModel.operatingIncome ?? this.operatingIncome,
      netIncome: tempModel.netIncome ?? this.netIncome,
      latestEps: tempModel.latestEps ?? this.latestEps,
      ceo: tempModel.ceo ?? this.ceo,
      employees: tempModel.employees ?? this.employees,
      avrSalary: tempModel.avrSalary ?? this.avrSalary,
      avrWorkingYears: tempModel.avrWorkingYears ?? this.avrWorkingYears,
      foundedIn: tempModel.foundedIn ?? this.foundedIn,
      announcedAt: tempModel.announcedAt ?? this.announcedAt,
      uploadedAt: tempModel.uploadedAt ?? this.uploadedAt,
      tags: tempModel.tags ?? this.tags,
      news: tempModel.news ?? this.news,
      stats: tempModel.stats ?? this.stats,
      credit: tempModel.credit ?? this.credit,
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
      'revenue': revenue,
      'operatingIncome': operatingIncome,
      'netIncome': netIncome,
      'latestEps': latestEps,
      'ceo': ceo,
      'employees': employees,
      'avrSalary': avrSalary,
      'avrWorkingYears': avrWorkingYears,
      'foundedIn': foundedIn,
      'announcedAt': announcedAt,
      'uploadedAt': uploadedAt,
      'tags': tags,
      'news': news,
      'stats': stats,
      'credit': credit,
    };
  }

  factory StockInfoModel.fromData(
    Map<String, dynamic> data,
  ) {
    // if (data == null) return null;

    return StockInfoModel(
      name: data['name'] ?? null,
      stocksOrIndex: data['stocksOrIndex'] ?? null,
      issueCode: data['issueCode'] ?? null,
      marketCode: data['marketCode'] ?? null,
      descriptionTitle: data['descriptionTitle'] ?? null,
      description: data['description'] ?? null,
      marketCap: data['marketCap'] ?? null,
      per: data['per'] ?? null,
      revenue: data['revenue'] ?? null,
      operatingIncome: data['operatingIncome'] ?? null,
      netIncome: data['netIncome'] ?? null,
      latestEps: data['latestEps'] ?? null,
      ceo: data['ceo'] ?? null,
      employees: data['employees'] ?? null,
      avrSalary: data['avrSalary'] ?? null,
      avrWorkingYears: data['avrWorkingYears'] ?? null,
      foundedIn: data['foundedIn'] ?? null,
      announcedAt: data['announcedAt'] ?? null,
      uploadedAt: data['uploadedAt'] ?? null,
      tags: data['tags'] != null ? List<dynamic>.from(data['tags']) : null,
      news: data['news'] ?? null,
      stats: data['stats'] ?? null,
      credit: data['credit'] ?? null,
    );
  }

  @override
  String toString() {
    return 'StockInfoModel(name: $name, stocksOrIndex: $stocksOrIndex, issueCode: $issueCode, marketCode: $marketCode, descriptionTitle: $descriptionTitle, description: $description, marketCap: $marketCap, per: $per, revenue: $revenue, operatingIncome: $operatingIncome, netIncome: $netIncome, latestEps: $latestEps, ceo: $ceo, employees: $employees, avrSalary: $avrSalary, avrWorkingYears: $avrWorkingYears, foundedIn: $foundedIn, announcedAt: $announcedAt, uploadedAt: $uploadedAt, tags: $tags, news: $news, stats: $stats, credit: $credit)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return o is StockInfoModel &&
        o.name == name &&
        o.stocksOrIndex == stocksOrIndex &&
        o.issueCode == issueCode &&
        o.marketCode == marketCode &&
        o.descriptionTitle == descriptionTitle &&
        o.description == description &&
        o.marketCap == marketCap &&
        o.per == per &&
        o.revenue == revenue &&
        o.operatingIncome == operatingIncome &&
        o.netIncome == netIncome &&
        o.latestEps == latestEps &&
        o.ceo == ceo &&
        o.employees == employees &&
        o.avrSalary == avrSalary &&
        o.avrWorkingYears == avrWorkingYears &&
        o.foundedIn == foundedIn &&
        o.announcedAt == announcedAt &&
        o.uploadedAt == uploadedAt &&
        listEquals(o.tags, tags) &&
        o.news == news &&
        listEquals(o.stats, stats) &&
        o.credit == credit;
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
        revenue.hashCode ^
        operatingIncome.hashCode ^
        netIncome.hashCode ^
        latestEps.hashCode ^
        ceo.hashCode ^
        employees.hashCode ^
        avrSalary.hashCode ^
        avrWorkingYears.hashCode ^
        foundedIn.hashCode ^
        announcedAt.hashCode ^
        uploadedAt.hashCode ^
        tags.hashCode ^
        news.hashCode ^
        stats.hashCode ^
        credit.hashCode;
  }
}
