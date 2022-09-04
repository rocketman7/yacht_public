import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class YachtView {
  final dynamic viewDate;
  final String view;
  YachtView({
    required this.viewDate,
    required this.view,
  });

  YachtView copyWith({
    dynamic? viewDate,
    String? view,
  }) {
    return YachtView(
      viewDate: viewDate ?? this.viewDate,
      view: view ?? this.view,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'viewDate': viewDate,
      'view': view,
    };
  }

  factory YachtView.fromMap(Map<String, dynamic> map) {
    return YachtView(
      viewDate: map['viewDate'] ?? null,
      view: map['view'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory YachtView.fromJson(String source) => YachtView.fromMap(json.decode(source));

  @override
  String toString() => 'YachtView(viewDate: $viewDate, view: $view)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is YachtView && other.viewDate == viewDate && other.view == view;
  }

  @override
  int get hashCode => viewDate.hashCode ^ view.hashCode;
}

class StockInfoNewModel {
  final bool showMain;
  final bool isTobeContinue;
  final String logoUrl;
  final String descriptionUrl;
  final String name;
  final Timestamp updateTime;
  final Timestamp releaseTime;
  final String assetCategory;
  final String code;
  final String country;
  final List<YachtView> yachtView;
  StockInfoNewModel({
    required this.showMain,
    required this.isTobeContinue,
    required this.logoUrl,
    required this.descriptionUrl,
    required this.name,
    required this.updateTime,
    required this.releaseTime,
    required this.assetCategory,
    required this.code,
    required this.country,
    required this.yachtView,
  });

  StockInfoNewModel copyWith({
    bool? showMain,
    bool? isTobeContinue,
    String? logoUrl,
    String? descriptionUrl,
    String? name,
    Timestamp? updateTime,
    Timestamp? releaseTime,
    String? assetCategory,
    String? code,
    String? country,
    List<YachtView>? yachtView,
  }) {
    return StockInfoNewModel(
      showMain: showMain ?? this.showMain,
      isTobeContinue: isTobeContinue ?? this.isTobeContinue,
      logoUrl: logoUrl ?? this.logoUrl,
      descriptionUrl: descriptionUrl ?? this.descriptionUrl,
      name: name ?? this.name,
      updateTime: updateTime ?? this.updateTime,
      releaseTime: releaseTime ?? this.releaseTime,
      assetCategory: assetCategory ?? this.assetCategory,
      code: code ?? this.code,
      country: country ?? this.country,
      yachtView: yachtView ?? this.yachtView,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'showMain': showMain,
      'isTobeContinue': isTobeContinue,
      'logoUrl': logoUrl,
      'descriptionUrl': descriptionUrl,
      'name': name,
      'updateTime': updateTime,
      'releaseTime': releaseTime,
      'assetCategory': assetCategory,
      'code': code,
      'country': country,
      'yachtView': yachtView,
    };
  }

  factory StockInfoNewModel.fromMap(
    Map<String, dynamic> map,
    List<YachtView> yachtView,
  ) {
    return StockInfoNewModel(
      showMain: map['showMain'] ?? false,
      isTobeContinue: map['isTobeContinue'] ?? false,
      logoUrl: map['logoUrl'] ?? '',
      descriptionUrl: map['descriptionUrl'] ?? '',
      name: map['name'] ?? '',
      updateTime: map['updateTime'],
      releaseTime: map['releaseTime'],
      assetCategory: map['assetCategory'] ?? '',
      code: map['code'] ?? '',
      country: map['country'] ?? 'KR',
      yachtView: yachtView,
    );
  }

  String toJson() => json.encode(toMap());

  // factory StockInfoNewModel.fromJson(String source) => StockInfoNewModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StockInfoNewModel(showMain: $showMain, isTobeContinue: $isTobeContinue, logoUrl: $logoUrl, descriptionUrl: $descriptionUrl, name: $name, updateTime: $updateTime, releaseTime: $releaseTime, assetCategory: $assetCategory, code: $code, country: $country, yachtView: $yachtView)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StockInfoNewModel &&
        other.showMain == showMain &&
        other.isTobeContinue == isTobeContinue &&
        other.logoUrl == logoUrl &&
        other.descriptionUrl == descriptionUrl &&
        other.name == name &&
        other.updateTime == updateTime &&
        other.releaseTime == releaseTime &&
        other.assetCategory == assetCategory &&
        other.code == code &&
        other.country == country &&
        other.yachtView == yachtView;
  }

  @override
  int get hashCode {
    return showMain.hashCode ^
        isTobeContinue.hashCode ^
        logoUrl.hashCode ^
        descriptionUrl.hashCode ^
        name.hashCode ^
        updateTime.hashCode ^
        releaseTime.hashCode ^
        assetCategory.hashCode ^
        code.hashCode ^
        country.hashCode ^
        yachtView.hashCode;
  }
}
