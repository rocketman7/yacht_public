import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/view_models/initial_view_model.dart';
import 'package:yachtOne/views/loading_view.dart';
import 'package:yachtOne/views/startup_view.dart';

import 'login_view.dart';

class InitialView extends StatefulWidget {
  @override
  _InitialViewState createState() => _InitialViewState();
}

class _InitialViewState extends State<InitialView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => InitialViewModel(),
        builder: (context, model, child) {
          return StreamBuilder<User>(
              stream: model.getAuthChange(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Scaffold(
                    body: LoginView(),
                  );
                } else {
                  print(snapshot.data.uid);
                  return StartUpView(0);
                }
              });
        });
  }
}
