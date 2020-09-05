import 'package:charts_flutter/flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../services/navigation_service.dart';

import '../../locator.dart';
import '../../models/user_model.dart';
import '../../view_models/mypage_view_model.dart';

import '../constants/size.dart';
import '../loading_view.dart';
import '../widgets/navigation_bars_widget.dart';

import '../../models/sharedPreferences_const.dart';

class AvatarSelectView extends StatefulWidget {
  final String uid;
  AvatarSelectView(this.uid);

  @override
  _AvatarSelectViewState createState() => _AvatarSelectViewState();
}

class _AvatarSelectViewState extends State<AvatarSelectView> {
  String uid;

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
              future: Future.wait([
                model.getUser(),
                model.downloadImage(),
              ]),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  UserModel currentUserModel = snapshot.data[0];
                  String _downloadAddress = snapshot.data[1];
                  return Scaffold(
                      backgroundColor: Colors.white,
                      body: SafeArea(
                          child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: displayRatio > 1.85 ? gap_l : gap_xs),
                        child: Column(
                          children: [
                            // topBar(currentUserModel),
                            CircleAvatar(
                              radius: (size.width ~/ 4).toDouble() / 2,
                              backgroundColor: Colors.white70,
                              backgroundImage: NetworkImage(
                                _downloadAddress,
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
}
