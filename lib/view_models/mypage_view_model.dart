import 'package:yachtOne/services/dialog_service.dart';
import '../locator.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import '../view_models/base_model.dart';

class MypageViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DialogService _dialogService = locator<DialogService>();
  final DatabaseService _databaseService = locator<DatabaseService>();

  UserModel _user;

  Future getUser(String uid) async {
    _user = await _databaseService.getUser(uid);
    return _user;
  }
}
