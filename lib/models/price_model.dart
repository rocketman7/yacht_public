import 'dart:convert';

class PriceModel {
  final String issueCode;
  final dynamic price;
  final double pricePctChange;

  PriceModel(
    this.issueCode,
    this.price,
    this.pricePctChange,
  );

  PriceModel copyWith({
    String issueCode,
    dynamic price,
    double pricePctChange,
  }) {
    return PriceModel(
      issueCode ?? this.issueCode,
      price ?? this.price,
      pricePctChange ?? this.pricePctChange,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'issueCode': issueCode,
      'price': price,
      'pricePctChange': pricePctChange,
    };
  }

  factory PriceModel.fromData(Map<String, dynamic> map) {
    if (map == null) return null;

    return PriceModel(
      map['issueCode'],
      map['price'],
      map['pricePctChange'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PriceModel.fromJson(String source) =>
      PriceModel.fromData(json.decode(source));

  @override
  String toString() =>
      'PriceModel(issueCode: $issueCode, price: $price, pricePctChange: $pricePctChange)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PriceModel &&
        o.issueCode == issueCode &&
        o.price == price &&
        o.pricePctChange == pricePctChange;
  }

  @override
  int get hashCode =>
      issueCode.hashCode ^ price.hashCode ^ pricePctChange.hashCode;
}
