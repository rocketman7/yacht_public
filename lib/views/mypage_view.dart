import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../view_models/mypage_view_model.dart';

import 'constants/size.dart';
import 'loading_view.dart';
import 'widgets/navigation_bars_widget.dart';

class MypageView extends StatefulWidget {
  @override
  _MypageViewState createState() => _MypageViewState();
}

class _MypageViewState extends State<MypageView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double displayRatio = size.height / size.width;

    return ViewModelBuilder<MypageViewModel>.reactive(
        viewModelBuilder: () => MypageViewModel(),
        onModelReady: (model) => model.getSharedPreferencesAll(),
        builder: (context, model, child) => MaterialApp(
                home: FutureBuilder(
              future: Future.wait([
                model.getUser(),
              ]),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Scaffold(
                      backgroundColor: Colors.white,
                      body: SafeArea(
                          child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: displayRatio > 1.85 ? gap_l : gap_xs),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView(children: _mypageList(model)),
                            ),
                            Row(
                              children: [
                                Text('푸쉬알람설정1 : '),
                                Switch(
                                    value: model.pushAlarm1,
                                    onChanged: (bool value) {
                                      model.pushAlarm1 = value;
                                      model.setSharedPreferencesAll();
                                    })
                              ],
                            ),
                            Row(
                              children: [
                                Text('푸쉬알람설정2 : '),
                                Switch(
                                    value: model.pushAlarm2,
                                    onChanged: (bool value) {
                                      model.pushAlarm2 = value;
                                      model.setSharedPreferencesAll();
                                    })
                              ],
                            ),
                            Row(
                              children: [
                                Text('유저카운터값 : ${model.userCounter}'),
                                RaisedButton(
                                    child: Text('클릭하여 1씩 증가'),
                                    onPressed: () {
                                      model.userCounter++;
                                      model.setSharedPreferencesAll();
                                    })
                              ],
                            ),
                            RaisedButton(
                                child: Text('클릭하여 Shared Preferences 초기화'),
                                onPressed: () {
                                  model.clearSharedPreferencesAll();
                                }),
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
    result.add(_mypageListItem(model, '(o)내사진 변경', 'mypage_avatarselect'));
    result.add(_mypageListItem(model, '(x)닉네임 변경', null));
    result.add(_mypageListItem(model, '(x)내 상금현황 보러가기', null));
    result.add(_mypageListItem(model, '(x)아이디(이메일)', null));
    result.add(_mypageListItem(model, '(o)푸쉬알림유무', null));
    result.add(_mypageListItem(model, '(x)내 활동', null));
    result.add(_mypageListItem(model, '(x)비밀번호 변경', null));
    result.add(_mypageListItem(model, '(k)계좌정보', 'mypage_accoutverification'));
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
            if (navigateTo != null) model.navigateToMypageToDown(navigateTo);
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
