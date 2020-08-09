import '../locator.dart';
import '../services/auth_service.dart';
import '../services/navigation_service.dart';
import '../view_models/base_model.dart';

class StartUpViewModel extends BaseModel {
  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future handleStartUpLogic() async {
    // return true or false
    var hasUserLoggedIn = await _authService.isUserLoggedIn();

    if (hasUserLoggedIn) {
      _navigationService.navigateTo('loggedIn');
    } else {
      _navigationService.navigateTo('login');
    }
  }
}
