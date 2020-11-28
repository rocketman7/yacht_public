class SubPortfolio {
  final String stockName;
  final int sharesNum;
  final int initialPrice;
  final int currentPrice;
  final dynamic colorCode;

  SubPortfolio(
      {this.stockName,
      this.sharesNum,
      this.initialPrice,
      this.currentPrice,
      this.colorCode});

  SubPortfolio.fromData(Map<String, dynamic> data)
      : stockName = data['stockName'],
        sharesNum = data['sharesNum'],
        initialPrice = data['initialPrice'],
        currentPrice = data['currentPrice'],
        colorCode = data['colorCode'];

  Map<String, dynamic> toJson() {
    return {
      'currentPrice': this.currentPrice,
    };
  }
}

class PortfolioModel {
  final List<SubPortfolio> subPortfolio;

  PortfolioModel({this.subPortfolio});

  PortfolioModel.fromData(List<SubPortfolio> subPortfolioList)
      : subPortfolio = subPortfolioList;
}
