import 'package:stacked/stacked.dart';
import 'package:yachtOne/models/all_stock_list_model.dart';

import '../services/database_service.dart';
import '../services/navigation_service.dart';

import '../locator.dart';

class StockListViewModel extends FutureViewModel {
  ///se
  final DatabaseService _databaseService = locator<DatabaseService>();
  final NavigationService _navigationService = locator<NavigationService>();

  ///va
  AllStockListModel allStockListModel;

  ///ui va

  ///me
  StockListViewModel() {
    null;
  }
  // for futureToRun
  Future getModels() async {
    allStockListModel = await _databaseService.getAllStockList();
  }

  @override
  Future futureToRun() => getModels();
}
