import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/models/all_stock_list_model.dart';

import '../services/database_service.dart';

import '../locator.dart';

class StockListViewModel extends FutureViewModel {
  ///se
  final DatabaseService _databaseService = locator<DatabaseService>();

  ///va
  AllStockListModel allStockListModel;
  AllStockListModel searchingAllStockListModel;

  ///ui va
  final TextEditingController filter = TextEditingController();
  String searchingName = "";

  ///me
  StockListViewModel() {
    filter.addListener(() {
      filter.addListener(() {
        if (filter.text.isEmpty) {
          searchingName = "";
          searchingAllStockListModel =
              searchStocksInAllStockList(searchingName);
          notifyListeners();
        } else {
          searchingName = filter.text;
          searchingAllStockListModel =
              searchStocksInAllStockList(searchingName);
          notifyListeners();
        }
      });
    });
  }

  AllStockListModel searchStocksInAllStockList(String name) {
    List<SubStockList> tempSubStockList = [];

    if (name == "") {
      return allStockListModel;
    } else {
      for (int i = 0; i < allStockListModel.subStocks.length; i++) {
        if (allStockListModel.subStocks[i].name
                .toLowerCase()
                .contains(name.toLowerCase()) ||
            allStockListModel.subStocks[i].alternativeName
                .toLowerCase()
                .contains(name.toLowerCase())) {
          tempSubStockList.add(SubStockList(
              issueCode: allStockListModel.subStocks[i].issueCode,
              name: allStockListModel.subStocks[i].name));
        }
      }

      AllStockListModel tempAllStockListModel =
          AllStockListModel.fromData(tempSubStockList);

      return tempAllStockListModel;
    }
  }

  // for futureToRun
  Future getModels() async {
    allStockListModel = await _databaseService.getAllStockList();
    searchingAllStockListModel = allStockListModel;
  }

  @override
  Future futureToRun() => getModels();
}
