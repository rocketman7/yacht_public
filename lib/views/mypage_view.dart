import 'package:charts_flutter/flutter.dart';
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
                      backgroundColor: Colors.black12,
                      body: SafeArea(
                          child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: displayRatio > 1.85 ? gap_l : gap_xs),
                        child: Column(
                          children: [
                            topBar(currentUserModel),
                            Expanded(
                              child: ListView(
                                children: _mypageList(),
                              ),
                            ),
                            Container(
                              height: 30,
                              color: Colors.green[100],
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

  List<Widget> _mypageList() {
    var result = List<Widget>();

    result.add(Padding(
      padding: EdgeInsets.all(5.0),
      child: Text('내 상금현황 보러가기'),
    ));
    result.add(Container(
      height: 1,
      width: 100,
      color: Colors.white,
    ));

    return result;
  }
}
