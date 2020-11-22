import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../view_models/nicknameSet_viewmodel.dart';

class NicknameSetView extends StatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NicknameSetViewModel>.reactive(
      viewModelBuilder: () => NicknameSetViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          // appBar: AppBar(
          //   title: Text(
          //     '닉네임 정하기',
          //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          //   ),
          //   elevation: 1,
          // ),
          // backgroundColor: Colors.red,
          backgroundColor: Colors.white,
          body: model.hasError
              ? Container(
                  child: Text('error발생. 페이지를 벗어나신 후 다시 시도하세요.'),
                )
              : model.isBusy
                  ? Container()
                  : WillPopScope(
                      onWillPop: () async {
                        _navigatorKey.currentState.maybePop();
                        return false;
                      },
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  "닉네임 설정",
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontFamily: 'DmSans',
                                  ),
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                              SizedBox(
                                height: 32.h,
                              ),
                              GestureDetector(
                                onTap: () {
                                  model.setNickname();
                                },
                                child: Text(
                                  '닉네임 설정하기',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
        );
      },
    );
  }
}
