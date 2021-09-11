import 'dart:convert';

import 'package:flutter/foundation.dart';

class TierSystemModel {
  final List<int> tierStops;
  final List<String> tierNames;
  final Map<String, String> tierKorNameMap;
  TierSystemModel({
    required this.tierStops,
    required this.tierNames,
    required this.tierKorNameMap,
  });

  TierSystemModel copyWith({
    List<int>? tierStops,
    List<String>? tierNames,
    Map<String, String>? tierKorNameMap,
  }) {
    return TierSystemModel(
      tierStops: tierStops ?? this.tierStops,
      tierNames: tierNames ?? this.tierNames,
      tierKorNameMap: tierKorNameMap ?? this.tierKorNameMap,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tierStops': tierStops,
      'tierNames': tierNames,
      'tierKorNameMap': tierKorNameMap,
    };
  }

  factory TierSystemModel.fromMap(Map<String, dynamic> map) {
    return TierSystemModel(
      tierStops: List<int>.from(map['tierStops']),
      tierNames: List<String>.from(map['tierNames']),
      tierKorNameMap: Map<String, String>.from(map['tierKorNameMap']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TierSystemModel.fromJson(String source) => TierSystemModel.fromMap(json.decode(source));

  @override
  String toString() => 'TierSystemModel(tierStops: $tierStops, tierNames: $tierNames, tierKorNameMap: $tierKorNameMap)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TierSystemModel &&
        listEquals(other.tierStops, tierStops) &&
        listEquals(other.tierNames, tierNames) &&
        mapEquals(other.tierKorNameMap, tierKorNameMap);
  }

  @override
  int get hashCode => tierStops.hashCode ^ tierNames.hashCode ^ tierKorNameMap.hashCode;
}
