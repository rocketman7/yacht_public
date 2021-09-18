// FavoriteStockModel for profile페이지
class FavoriteStockModel {
  String name;
  String logoUrl;

  FavoriteStockModel({
    required this.name,
    required this.logoUrl,
  });

  factory FavoriteStockModel.fromMap(Map<String, dynamic> map) {
    return FavoriteStockModel(
      name: map['name'],
      logoUrl: map['logoUrl'],
    );
  }
}

// FavoriteStockHistoricalPriceModel for profile페이지
class FavoriteStockHistoricalPriceModel {
  num close;
  num prevClose;

  FavoriteStockHistoricalPriceModel(
      {required this.close, required this.prevClose});
}
