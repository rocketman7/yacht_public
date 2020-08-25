import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../models/user_model.dart';
import '../view_models/mypage_view_model.dart';

import 'constants/size.dart';
import 'loading_view.dart';
import 'widgets/navigation_bars_widget.dart';

class MypageView extends StatelessWidget {
  final String uid;
  MypageView(this.uid);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double displayRatio = size.height / size.width;

    return ViewModelBuilder<MypageViewModel>.reactive(
        viewModelBuilder: () => MypageViewModel(),
        builder: (context, model, child) => MaterialApp(
                home: FutureBuilder(
              future: Future.wait([model.getUser(uid)]),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  UserModel currentUserModel = snapshot.data[0];
                  return Scaffold(
                      body: SafeArea(
                          child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: displayRatio > 1.85 ? gap_l : gap_xs),
                        child: Column(
                          children: [
                            topBar(currentUserModel),
                            Flexible(
                              flex: 1,
                              child: Container(
                                color: Colors.red,
                              ),
                            ),
                            Flexible(
                              flex: 7,
                              child: Container(
                                color: Colors.blue,
                              ),
                            )
                          ],
                        ),
                      )),
                      bottomNavigationBar: bottomNavigationBar(context));
                } else {
                  return LoadingView();
                }
              },
            )));
  }
}
