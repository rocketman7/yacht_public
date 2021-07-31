import 'dart:convert';

class TempRealtimeModel {
  final String? issueCode;
  final double? pricePctChange;
  final num? price;
  final dynamic createdAt;
  TempRealtimeModel({
    required this.issueCode,
    required this.pricePctChange,
    required this.price,
    required this.createdAt,
  });

  TempRealtimeModel copyWith({
    String? issueCode,
    double? pricePctChange,
    num? price,
    dynamic? createdAt,
  }) {
    return TempRealtimeModel(
      issueCode: issueCode ?? this.issueCode,
      pricePctChange: pricePctChange ?? this.pricePctChange,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'issueCode': issueCode,
      'pricePctChange': pricePctChange,
      'price': price,
      'createdAt': createdAt,
    };
  }

  factory TempRealtimeModel.fromMap(Map<String, dynamic> map) {
    return TempRealtimeModel(
      issueCode: map['issueCode'],
      pricePctChange: map['pricePctChange'],
      price: map['price'],
      createdAt: map['createdAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TempRealtimeModel.fromJson(String source) =>
      TempRealtimeModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TempRealtimeModel(issueCode: $issueCode, pricePctChange: $pricePctChange, price: $price, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TempRealtimeModel &&
        other.issueCode == issueCode &&
        other.pricePctChange == pricePctChange &&
        other.price == price &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return issueCode.hashCode ^
        pricePctChange.hashCode ^
        price.hashCode ^
        createdAt.hashCode;
  }
}
