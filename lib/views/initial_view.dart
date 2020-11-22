import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/view_models/initial_view_model.dart';
import 'package:yachtOne/views/app_title_view.dart';
import 'package:yachtOne/views/loading_view.dart';
import 'package:yachtOne/views/startup_view.dart';

import '../locator.dart';
import 'intro_view.dart';
import 'login_view.dart';

class InitialView extends StatefulWidget {
  @override
  _InitialViewState createState() => _InitialViewState();
}

class _InitialViewState extends State<InitialView> {
  final AuthService _authService = locator<AuthService>();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(375, 812), allowFontScaling: true);

    return ViewModelBuilder.reactive(
        viewModelBuilder: () => InitialViewModel(),
        builder: (context, model, child) {
          return (model.isBusy)
              ? Container()
              : StreamBuilder<User>(
                  stream: model.getAuthChange(),
                  builder: (context, snapshot) {
                    // print(model.isTwoFactorAuthed);
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      print("CONNECTION STATE" +
                          snapshot.connectionState.toString());
                      return Scaffold(
                        body: IntroView(),
                      );
                    } else if (!snapshot.hasData) {
                      print("nodata");
                      return Scaffold(
                        body: AppTitleView(),
                      );
                    } else {
                      print(snapshot.data.uid);
                      return StartUpView(0);
                    }
                  });
        });
  }
}
