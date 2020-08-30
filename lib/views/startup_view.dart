import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/views/home_view.dart';
import 'package:yachtOne/views/login_view.dart';
import '../view_models/startup_view_model.dart';
import '../views/loading_view.dart';

class StartUpView extends StatefulWidget {
  @override
  _StartUpViewState createState() => _StartUpViewState();
}

class _StartUpViewState extends State<StartUpView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("init");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didC");
  }

  // @override
  // Widget build(BuildContext context) {
  //   print("StartuUpView");
  //   return ViewModelBuilder<StartUpViewModel>.reactive(
  //     viewModelBuilder: () => StartUpViewModel(),
  //     // ViewModel이 세팅되면 아래 함수 call
  //     // onModelReady: (model) => model.handleStartUpLogic(),
  //     // onModelReady 콜 하고 아래 빌드. handleStartUpLogi이 Future함수 이므로 처리될 동안 LoadingView 빌드
  //     builder: (context, model, child) {
  //       return StreamBuilder<User>(
  //         stream: FirebaseAuth.instance.authStateChanges(),
  //         builder: (BuildContext context, snapshot) {
  //           print(snapshot);
  //           if (snapshot.connectionState == ConnectionState.waiting) {
  //             return new LoadingView();
  //           } else {
  //             if (snapshot.hasData) {
  //               return HomeView();
  //             }
  //             print("To login");
  //             // Navigator.of(context).pushNamed('login');
  //             print("navigated");
  //             return LoginView();
  //           }
  //         },
  //       );
  //     },
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    // HomeView에서 다른 페이지로 간 뒤에 backbutton으로 다시 홈에 오면 stream trigger가 안됨.
    print("StartuUpView");
    return ViewModelBuilder<StartUpViewModel>.reactive(
      onModelReady: (model) => model.stream,
      // ViewModel이 세팅되면 아래 함수 call
      // onModelReady: (model) => model.handleStartUpLogic(),
      // onModelReady 콜 하고 아래 빌드. handleStartUpLogi이 Future함수 이므로 처리될 동안 LoadingView 빌드
      builder: (context, model, child) {
        // model.stream;
        return LoadingView();
      },
      viewModelBuilder: () => StartUpViewModel(),
    );
  }
}
