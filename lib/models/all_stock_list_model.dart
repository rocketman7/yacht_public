class SubStockList {
  final String issueCode;
  final String name;

  SubStockList({this.issueCode, this.name});

  SubStockList.fromData(Map<String, dynamic> data)
      : issueCode = data['issueCode'],
        name = data['name'];
}

class AllStockListModel {
  final List<SubStockList> subStocks;

  AllStockListModel({this.subStocks});

  AllStockListModel.fromData(List<SubStockList> subStocksList)
      : subStocks = subStocksList;
}
