class SubStockList {
  final String issueCode;
  final String name;
  final String alternativeName;

  SubStockList({this.issueCode, this.name, this.alternativeName});

  SubStockList.fromData(Map<String, dynamic> data)
      : issueCode = data['issueCode'],
        name = data['name'],
        alternativeName = data['alternativeName'] ?? data['name'];
}

class AllStockListModel {
  final List<SubStockList> subStocks;

  AllStockListModel({this.subStocks});

  AllStockListModel.fromData(List<SubStockList> subStocksList)
      : subStocks = subStocksList;
}
