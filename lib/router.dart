import 'package:flutter/material.dart';
import 'package:yachtOne/views/phone_auth_view.dart';
import 'managers/dialog_manager.dart';
import 'views/home_view.dart';
import 'views/login_view.dart';
import 'views/mypage_documents/avatarSelect_view.dart';
import 'views/register_view.dart';
import 'views/startup_view.dart';
import 'views/ggook_view.dart';
import 'views/rank_view.dart';
import 'views/mypage_view.dart';

import 'views/vote_comment_view.dart';
import 'views/vote_select_view.dart';
import 'views/mypage_documents/termsOfUse_View.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      // navigation service에서 접근할 route이름들 view설정
      case 'phoneAuth':
        return MaterialPageRoute(
            builder: (context) => DialogManager(child: PhoneAuthView()));
      case 'loggedIn':
        return MaterialPageRoute(
            builder: (context) => DialogManager(child: HomeView()));
      case 'register':
        return MaterialPageRoute(
            builder: (context) =>
                DialogManager(child: RegisterView(routeSettings.arguments)));
      case 'login':
        return MaterialPageRoute(
            builder: (context) => DialogManager(child: LoginView()));
      case 'voteSelect':
        return MaterialPageRoute(
            builder: (context) =>
                DialogManager(child: VoteSelectView(routeSettings.arguments)));
      case 'ggook':
        return MaterialPageRoute(
            builder: (context) =>
                DialogManager(child: GgookView(routeSettings.arguments)));
      case 'voteComment':
        return MaterialPageRoute(
            builder: (context) =>
                DialogManager(child: VoteCommentView(routeSettings.arguments)));
      case 'rank':
        return MaterialPageRoute(
            builder: (context) => DialogManager(child: RankView()));
      case 'mypage':
        return MaterialPageRoute(
            builder: (context) => DialogManager(child: MypageView()));
      case 'mypage_termsofuse':
        return MaterialPageRoute(
            builder: (context) => DialogManager(child: TermsOfUseView()));
      case 'mypage_avatarselect':
        return MaterialPageRoute(
            builder: (context) => DialogManager(
                child: AvatarSelectView(routeSettings.arguments)));
      default:
        return MaterialPageRoute(
            builder: (context) => DialogManager(child: StartUpView()));
    }
  }
}
