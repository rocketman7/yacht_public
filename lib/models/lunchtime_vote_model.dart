import 'dart:convert';

class LunchtimeVoteModel {
  final String name;
  final String indexOrStocks;
  final String issueCode;
  final String marketCode;
  final num basePrice;

  LunchtimeVoteModel({
    this.name,
    this.indexOrStocks,
    this.issueCode,
    this.marketCode,
    this.basePrice,
  });

  LunchtimeVoteModel copyWith({
    String name,
    String indexOrStocks,
    String issueCode,
    String marketCode,
    num basePrice,
  }) {
    return LunchtimeVoteModel(
      name: name ?? this.name,
      indexOrStocks: indexOrStocks ?? this.indexOrStocks,
      issueCode: issueCode ?? this.issueCode,
      marketCode: marketCode ?? this.marketCode,
      basePrice: basePrice ?? this.basePrice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'indexOrStocks': indexOrStocks,
      'issueCode': issueCode,
      'marketCode': marketCode,
      'basePrice': basePrice,
    };
  }

  factory LunchtimeVoteModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return LunchtimeVoteModel(
      name: map['name'],
      indexOrStocks: map['indexOrStocks'],
      issueCode: map['issueCode'],
      marketCode: map['marketCode'],
      basePrice: map['basePrice'],
    );
  }

  @override
  String toString() {
    return 'LunchtimeVoteModel(name: $name, indexOrStocks: $indexOrStocks, issueCode: $issueCode, marketCode: $marketCode, basePrice: $basePrice)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is LunchtimeVoteModel &&
        o.name == name &&
        o.indexOrStocks == indexOrStocks &&
        o.issueCode == issueCode &&
        o.marketCode == marketCode &&
        o.basePrice == basePrice;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        indexOrStocks.hashCode ^
        issueCode.hashCode ^
        marketCode.hashCode ^
        basePrice.hashCode;
  }
}
