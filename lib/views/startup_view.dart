import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';
import '../view_models/startup_view_model.dart';
import '../views/loading_view.dart';

class StartUpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      viewModelBuilder: () => StartUpViewModel(),
      // ViewModel이 세팅되면 아래 함수 call
      onModelReady: (model) => model.handleStartUpLogic(),
      // onModelReady 콜 하고 아래 빌드. handleStartUpLogi이 Future함수 이므로 처리될 동안 LoadingView 빌드
      builder: (context, model, child) => LoadingView(),
    );
  }
}
