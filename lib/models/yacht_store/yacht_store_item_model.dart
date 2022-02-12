import 'dart:convert';

class YachtStoreItemModel {
  final String itemCategory;
  final String itemName;
  final String itemCode;
  final num itemPrice;
  YachtStoreItemModel({
    required this.itemCategory,
    required this.itemName,
    required this.itemCode,
    required this.itemPrice,
  });

  YachtStoreItemModel copyWith({
    String? itemCategory,
    String? itemName,
    String? itemCode,
    num? itemPrice,
  }) {
    return YachtStoreItemModel(
      itemCategory: itemCategory ?? this.itemCategory,
      itemName: itemName ?? this.itemName,
      itemCode: itemCode ?? this.itemCode,
      itemPrice: itemPrice ?? this.itemPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemCategory': itemCategory,
      'itemName': itemName,
      'itemCode': itemCode,
      'itemPrice': itemPrice,
    };
  }

  factory YachtStoreItemModel.fromMap(Map<String, dynamic> map) {
    return YachtStoreItemModel(
      itemCategory: map['itemCategory'] ?? '',
      itemName: map['itemName'] ?? '',
      itemCode: map['itemCode'] ?? '',
      itemPrice: map['itemPrice'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory YachtStoreItemModel.fromJson(String source) => YachtStoreItemModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'YachtStoreItemModel(itemCategory: $itemCategory, itemName: $itemName, itemCode: $itemCode, itemPrice: $itemPrice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is YachtStoreItemModel &&
        other.itemCategory == itemCategory &&
        other.itemName == itemName &&
        other.itemCode == itemCode &&
        other.itemPrice == itemPrice;
  }

  @override
  int get hashCode {
    return itemCategory.hashCode ^ itemName.hashCode ^ itemCode.hashCode ^ itemPrice.hashCode;
  }
}
