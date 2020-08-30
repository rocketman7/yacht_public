import 'package:charts_flutter/flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../services/navigation_service.dart';

import '../locator.dart';
import '../models/user_model.dart';
import '../view_models/mypage_view_model.dart';

import 'constants/size.dart';
import 'loading_view.dart';
import 'widgets/navigation_bars_widget.dart';

import '../models/shared_preferences_const.dart';

class MypageView extends StatefulWidget {
  final String uid;
  MypageView(this.uid);

  @override
  _MypageViewState createState() => _MypageViewState();
}

class _MypageViewState extends State<MypageView> {
  String uid;

  final NavigationService _navigationService = locator<NavigationService>();

  final MypageViewModel _mypageViewModelforFuture = MypageViewModel();
  //GlobalKey<NavigatorState> _globalKey;
  bool _pushAlarm1, _pushAlarm2;
  Future<dynamic> _pushAlarm1Future, _pushAlarm2Future;

  @override
  void initState() {
    super.initState();
    //_globalKey = _navigationService.navigatorKey;

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
                _pushAlarm1Future,
                _pushAlarm2Future,
              ]),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  UserModel currentUserModel = snapshot.data[0];
                  _pushAlarm1 = _pushAlarm1 ?? snapshot.data[1];
                  _pushAlarm2 = _pushAlarm2 ?? snapshot.data[2];
                  return Scaffold(
                      //key: _globalKey,
                      backgroundColor: Colors.white,
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

    result.add(_mypageListItem(model, '(o)구현완료, (x)나중에 구현해야', null));
    result.add(_mypageListItem(model, '', null));
    result.add(_mypageListItem(model, '내사진 변경', 'mypage_avatarselect'));
    result.add(_mypageListItem(model, '닉네임 변경', null));
    result.add(_mypageListItem(model, '(x)내 상금현황 보러가기', null));
    result.add(_mypageListItem(model, '(x)아이디(이메일)', null));
    result.add(_mypageListItem(model, '푸쉬알림유무', null));
    result.add(_mypageListItem(model, '(x)내 활동', null));
    result.add(_mypageListItem(model, '(x)비밀번호 변경', null));
    result.add(_mypageListItem(model, '(x)계좌정보', null));
    result.add(_mypageListItem(model, '(o)이용약관', 'mypage_termsofuse'));
    result.add(_mypageListItem(model, '(o)개인정보취급방침(^이용약관)', null));
    result.add(_mypageListItem(model, '(o)사업자정보(^이용약관)', null));
    result.add(GestureDetector(
      onTap: () {
        print('dddd');
        model.logout();
      },
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Text('(o)로그아웃'),
      ),
    ));

    return result;
  }

  Widget _mypageListItem(
      MypageViewModel model, String title, String navigateTo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            if (navigateTo != null)
              _navigationService.navigateWithArgTo(navigateTo, uid);
          },
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              title,
            ),
          ),
        ),
        Container(
          height: 1,
          color: Colors.black12,
        )
      ],
    );
  }
}
