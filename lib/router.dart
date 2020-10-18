import 'package:flutter/material.dart';
import 'package:yachtOne/views/initial_view.dart';
import 'package:yachtOne/views/phone_auth_view.dart';
import 'package:yachtOne/views/season_community_view.dart';
import 'package:yachtOne/views/subject_community_view.dart';
import 'package:yachtOne/views/track_record_view.dart';
import 'managers/dialog_manager.dart';
import 'views/home_view.dart';
import 'views/login_view.dart';
import 'views/mypage_documents/avatarSelect_view.dart';
import 'views/oneOnOne_view.dart';
import 'views/register_view.dart';
import 'views/startup_view.dart';
import 'views/ggook_view.dart';
import 'views/rank_view.dart';
import 'views/mypage_main_view.dart';

import 'views/mypage_documents/mypage_privacyPolicy.dart';
import 'views/mypage_documents/mypage_termsOfUse.dart';
import 'views/mypage_documents/mypage_businessInformation.dart';
import 'views/mypage_documents/mypage_pushAlarmSetting_view.dart';
import 'views/mypage_documents/mypage_accountVerification_view.dart';
import 'views/mypage_documents/mypage_friendsCode_view.dart';
import 'views/mypage_documents/mypage_editProfile_view.dart';
import 'views/vote_comment_view.dart';
import 'views/vote_select_view.dart';
import 'views/portfolio_view.dart';
import 'views/faq_view.dart';
import 'views/notice_view.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      // navigation service에서 접근할 route이름들 view설정
      case 'phoneAuth':
        return MaterialPageRoute(
            builder: (context) => DialogManager(child: PhoneAuthView()));
      case 'loggedIn':
        return MaterialPageRoute(
            builder: (context) =>
                DialogManager(child: HomeView(routeSettings.arguments)));
      case 'register':
        return MaterialPageRoute(
            builder: (context) =>
                DialogManager(child: RegisterView(routeSettings.arguments)));
      case 'login':
        return MaterialPageRoute(
            builder: (context) => DialogManager(child: LoginView()));
      case 'voteSelect':
        return MaterialPageRoute(
            builder: (context) => DialogManager(child: VoteSelectView()));
      case 'ggook':
        return MaterialPageRoute(
            builder: (context) =>
                DialogManager(child: GgookView(routeSettings.arguments)));
      case 'voteComment':
        return MaterialPageRoute(
            builder: (context) => DialogManager(child: VoteCommentView()));
      case 'seasonComment':
        return MaterialPageRoute(
            builder: (context) => DialogManager(child: SeasonCommunityView()));
      case 'subjectComment':
        return MaterialPageRoute(
            builder: (context) => DialogManager(
                child: SubjectCommunityView(routeSettings.arguments)));
      case 'rank':
        return MaterialPageRoute(
            builder: (context) => DialogManager(child: RankView()));

      case 'mypage_main':
        return MaterialPageRoute(
            builder: (context) => DialogManager(child: MypageMainView()));
      case 'initial':
        return MaterialPageRoute(
            builder: (context) => DialogManager(child: InitialView()));
      case 'mypage_termsofuse':
        return MaterialPageRoute(builder: (context) => MypageTermofuse());
      case 'mypage_privacypolicy':
        return MaterialPageRoute(builder: (context) => MypagePrivacyPolicy());
      case 'mypage_businessinformation':
        return MaterialPageRoute(
            builder: (context) => MypageBusinessInformation());
      case 'mypage_pushalarmsetting':
        return MaterialPageRoute(
            builder: (context) => MypagePushAlarmSettingView());
      case 'mypage_avatarselect':
        return MaterialPageRoute(
            builder: (context) => MypageAvatarSelectView());
      case 'mypage_accoutverification':
        return MaterialPageRoute(
            builder: (context) => MypageAccountVerificationView());
      case 'mypage_friendscode':
        return MaterialPageRoute(builder: (context) => MypageFriendsCodeView());
      case 'mypage_editprofile':
        return MaterialPageRoute(builder: (context) => MypageEditProfileView());
      case 'mypage_tempggook':
        return MaterialPageRoute(builder: (context) => MypageTempGGookView());
      case 'portfolio':
        return MaterialPageRoute(builder: (context) => PortfolioView());
      case 'trackRecord':
        return MaterialPageRoute(builder: (context) => TrackRecordView());
      case 'faq':
        return MaterialPageRoute(builder: (context) => FaqView());
      case 'notice':
        return MaterialPageRoute(builder: (context) => NoticeView());
      case 'oneonone':
        return MaterialPageRoute(builder: (context) => OneOnOneView());
      case 'startup':
        return MaterialPageRoute(
            builder: (context) =>
                DialogManager(child: StartUpView(routeSettings.arguments)));
      default:
        return MaterialPageRoute(
            builder: (context) =>
                DialogManager(child: StartUpView(routeSettings.arguments)));
    }
  }
}
