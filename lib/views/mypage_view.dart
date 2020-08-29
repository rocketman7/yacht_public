import 'package:charts_flutter/flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../models/user_model.dart';
import '../view_models/mypage_view_model.dart';

import 'constants/size.dart';
import 'loading_view.dart';
import 'widgets/navigation_bars_widget.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/shared_preferences_const.dart';

class MypageView extends StatefulWidget {
  final String uid;
  MypageView(this.uid);

  @override
  _MypageViewState createState() => _MypageViewState();
}

class _MypageViewState extends State<MypageView> {
  String uid;

  MypageViewModel _mypageViewModelforFuture = MypageViewModel();
  bool _pushAlarm1, _pushAlarm2;
  Future<dynamic> _pushAlarm1Future, _pushAlarm2Future;

  @override
  void initState() {
    super.initState();

    _pushAlarm1Future =
        _mypageViewModelforFuture.getSharedPreferences(pushAlarm1);
    _pushAlarm2Future =
        _mypageViewModelforFuture.getSharedPreferences(pushAlarm2);

    uid = widget.uid;
  }

  @override
  void dispose() {
    // _mypageViewModelforFuture.setSharedPreferences(pushAlarm1, _pushAlarm1);
    // _mypageViewModelforFuture.setSharedPreferences(pushAlarm2, _pushAlarm2);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double displayRatio = size.height / size.width;

    return ViewModelBuilder<MypageViewModel>.reactive(
        viewModelBuilder: () => MypageViewModel(),
        builder: (context, model, child) => MaterialApp(
                home: FutureBuilder(
              future: Future.wait([
                model.getUser(widget.uid),
                model.downloadImage(),
                _pushAlarm1Future,
                _pushAlarm2Future,
              ]),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  UserModel currentUserModel = snapshot.data[0];
                  _pushAlarm1 = _pushAlarm1 ?? snapshot.data[2];
                  _pushAlarm2 = _pushAlarm2 ?? snapshot.data[3];
                  return Scaffold(
                      backgroundColor: Colors.grey,
                      body: SafeArea(
                          child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: displayRatio > 1.85 ? gap_l : gap_xs),
                        child: Column(
                          children: [
                            topBar(currentUserModel),
                            Expanded(
                              child: ListView(children: _mypageList(model)),
                            ),
                            Switch(
                              value: _pushAlarm1,
                              onChanged: (bool value) {
                                setState(() {
                                  _pushAlarm1 = value;
                                  _mypageViewModelforFuture
                                      .setSharedPreferences(
                                          pushAlarm1, _pushAlarm1);
                                });
                              },
                            ),
                            Switch(
                              value: _pushAlarm2,
                              onChanged: (bool value) {
                                setState(() {
                                  _pushAlarm2 = value;
                                  _mypageViewModelforFuture
                                      .setSharedPreferences(
                                          pushAlarm2, _pushAlarm2);
                                });
                              },
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

  List<Widget> _mypageList(MypageViewModel model) {
    var result = List<Widget>();

    result.add(GestureDetector(
      onDoubleTap: () {
        model.logout();
      },
      child: _mypageListItem('로그아웃', null),
    ));
    result.add(Container(
      height: 1,
      width: 100,
      color: Colors.black12,
    ));
    result.add(Image.network(model.downloadAddress));
    result.add(Container(
      height: 1,
      width: 100,
      color: Colors.black12,
    ));
    result.add(_mypageListItem('푸쉬알림유무', null));
    result.add(Container(
      height: 1,
      width: 100,
      color: Colors.black12,
    ));

    return result;
  }

  Widget _mypageListItem(String title, String navigateTo) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Text(
        title,
      ),
    );
  }
}
