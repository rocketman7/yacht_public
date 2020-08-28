import 'package:charts_flutter/flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../models/user_model.dart';
import '../view_models/mypage_view_model.dart';

import 'constants/size.dart';
import 'loading_view.dart';
import 'widgets/navigation_bars_widget.dart';

class MypageView extends StatefulWidget {
  final String uid;
  MypageView(this.uid);

  @override
  _MypageViewState createState() => _MypageViewState();
}

class _MypageViewState extends State<MypageView> {
  String uid;

  // String _downloadURL;

  @override
  void initState() {
    super.initState();

    uid = widget.uid;
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
        builder: (context, model, child) => MaterialApp(
                home: FutureBuilder(
              future: Future.wait(
                  [model.getUser(widget.uid), model.downloadImage()]),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  UserModel currentUserModel = snapshot.data[0];
                  //_downloadURL = snapshot.data[1];
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

    result.add(Padding(
      padding: EdgeInsets.all(5.0),
      child: Text('내 상금현황 보러가기'),
    ));
    result.add(Container(
      height: 1,
      width: 100,
      color: Colors.black12,
    ));
    result.add(_mypageListItem('아이디(이메일)', null));
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
    result.add(_mypageListItem('내 활동', null));
    result.add(Container(
      height: 1,
      width: 100,
      color: Colors.black12,
    ));
    result.add(_mypageListItem('비밀번호 변경', null));
    result.add(Container(
      height: 1,
      width: 100,
      color: Colors.black12,
    ));
    result.add(_mypageListItem('계좌정보', null));
    result.add(Container(
      height: 1,
      width: 100,
      color: Colors.black12,
    ));
    result.add(_mypageListItem('이용약관', null));
    result.add(Container(
      height: 1,
      width: 100,
      color: Colors.black12,
    ));
    result.add(_mypageListItem('개인정보 취급 방침', null));
    result.add(Container(
      height: 1,
      width: 100,
      color: Colors.black12,
    ));
    result.add(_mypageListItem('사업자 정보', null));
    result.add(Container(
      height: 1,
      width: 100,
      color: Colors.black12,
    ));
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
