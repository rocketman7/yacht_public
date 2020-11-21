import 'dart:convert';

class PriceModel {
  final String issueCode;
  final double price;
  final double pricePctChange;
  final dynamic createdAt;

  PriceModel(
    this.issueCode,
    this.price,
    this.pricePctChange,
    this.createdAt,
  );

  PriceModel copyWith({
    String issueCode,
    num price,
    double pricePctChange,
    dynamic createdAt,
  }) {
    return PriceModel(
      issueCode ?? this.issueCode,
      price ?? this.price,
      pricePctChange ?? this.pricePctChange,
      createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'issueCode': issueCode,
      'price': price,
      'pricePctChange': pricePctChange,
      'createdAt': createdAt,
    };
  }

  factory PriceModel.fromData(Map<String, dynamic> data) {
    if (data == null) return null;

    return PriceModel(
      data['issueCode'],
      data['price'].toDouble(),
      data['pricePctChange'],
      data['createdAt'],
    );
  }

  @override
  String toString() =>
      'PriceModel(issueCode: $issueCode, price: $price, pricePctChange: $pricePctChange, createdAt : $createdAt)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PriceModel &&
        o.issueCode == issueCode &&
        o.price == price &&
        o.pricePctChange == pricePctChange &&
        o.createdAt == createdAt;
  }

  @override
  int get hashCode =>
      issueCode.hashCode ^ price.hashCode ^ pricePctChange.hashCode;
}
