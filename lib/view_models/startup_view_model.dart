import '../locator.dart';
import '../services/auth_service.dart';
import '../services/navigation_service.dart';
import '../view_models/base_model.dart';

class StartUpViewModel extends BaseModel {
  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future handleStartUpLogic() async {
    // 유저정보 있으면 True, 없으면 False
    // _authService.signOut();
    bool hasUserLoggedIn = await _authService.isUserLoggedIn();

    if (hasUserLoggedIn) {
      _navigationService.navigateTo('loggedIn');
    } else {
      _navigationService.navigateTo('phoneAuth');
    }
  }
}
