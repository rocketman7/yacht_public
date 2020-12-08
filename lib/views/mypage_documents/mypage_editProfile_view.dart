import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/views/constants/size.dart';

import '../../locator.dart';
import '../../view_models/mypage_editProfile_view_model.dart';
import '../widgets/avatar_widget.dart';

class MypageEditProfileView extends StatelessWidget {
  NavigationService _navigationService = locator<NavigationService>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MypageEditProfileViewModel>.reactive(
      viewModelBuilder: () => MypageEditProfileViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              '회원정보 수정',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            elevation: 1,
          ),
          backgroundColor: Colors.white,
          body: model.hasError
              ? Container(
                  child: Text('error발생. 페이지를 벗어나신 후 다시 시도하세요.'),
                )
              : model.isBusy
                  ? Container()
                  : SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 16,
                            ),
                            Center(
                                child: avatarWidget(
                                    model.sharedPrefForAvatarImage,
                                    model.user.item)),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  model.checkedAvatarImage =
                                      model.sharedPrefForAvatarImage;
                                  buildModalBottomSheet(context, model);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 83,
                                  height: 27,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(80.0)),
                                    color: Color(0xFF1EC8CF),
                                  ),
                                  child: Text(
                                    '사진 변경',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: -1),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 48,
                            ),
                            GestureDetector(
                              onTap: () {
                                _navigationService.navigateWithArgTo(
                                    'nickname_set', model.user.userName);
                              },
                              child: Row(children: [
                                Text(
                                  '활동 닉네임',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Spacer(),
                                Text(
                                  model.user.userName,
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ]),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Container(
                              height: 1,
                              color: Color(0xFFE3E3E3),
                            ),

                            !model.isEmailAndPhoneAuth
                                ? Container()
                                : Column(
                                    children: [
                                      SizedBox(
                                        height: 16,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _navigationService.navigateTo(
                                            'password_change',
                                          );
                                        },
                                        child: Row(children: [
                                          Text(
                                            '비밀번호 변경',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Spacer(),
                                          Text(
                                            "                   ",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          SizedBox(
                                            width: 16,
                                          ),
                                          GestureDetector(
                                            onTap: () {},
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ]),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Container(
                                        height: 1,
                                        color: Color(0xFFE3E3E3),
                                      ),
                                    ],
                                  ),

                            // SizedBox(
                            //   height: 16,
                            // ),
                            // Row(children: [
                            //   Text(
                            //     '휴대폰 번호',
                            //     style: TextStyle(fontSize: 16),
                            //   ),
                            //   Spacer(),
                            //   Text(
                            //     model.user.phoneNumber ?? "",
                            //     style: TextStyle(fontSize: 16),
                            //   ),
                            //   SizedBox(
                            //     width: 16,
                            //   ),
                            //   GestureDetector(
                            //     onTap: () {},
                            //     child: Icon(
                            //       Icons.arrow_forward_ios,
                            //       size: 16,
                            //       color: Colors.grey,
                            //     ),
                            //   ),
                            // ]),
                            // SizedBox(
                            //   height: 16,
                            // ),
                            // Container(
                            //   height: 1,
                            //   color: Color(0xFFE3E3E3),
                            // ),
                            // SizedBox(
                            //   height: 16,
                            // ),
                            // Row(children: [
                            //   Text(
                            //     '이메일',
                            //     style: TextStyle(fontSize: 16),
                            //   ),
                            //   Spacer(),
                            //   Text(
                            //     model.user.email ?? "",
                            //     style: TextStyle(fontSize: 16),
                            //   ),
                            //   SizedBox(
                            //     width: 16,
                            //   ),
                            //   GestureDetector(
                            //     onTap: () {},
                            //     child: Icon(
                            //       Icons.arrow_forward_ios,
                            //       size: 16,
                            //       color: Colors.grey,
                            //     ),
                            //   ),
                            // ]),
                            // SizedBox(
                            //   height: 16,
                            // ),
                            // Container(
                            //   height: 1,
                            //   color: Color(0xFFE3E3E3),
                            // ),
                            // SizedBox(
                            //   height: 16,
                            // ),
                            // Row(children: [
                            //   Text(
                            //     '비밀번호',
                            //     style: TextStyle(fontSize: 16),
                            //   ),
                            //   Spacer(),
                            //   SizedBox(
                            //     width: 16,
                            //   ),
                            //   GestureDetector(
                            //     onTap: () {},
                            //     child: Icon(
                            //       Icons.arrow_forward_ios,
                            //       size: 16,
                            //       color: Colors.grey,
                            //     ),
                            //   ),
                            // ]),
                            // SizedBox(
                            //   height: 16,
                            // ),
                            // Container(
                            //   height: 1,
                            //   color: Color(0xFFE3E3E3),
                            // ),
                            // SizedBox(
                            //   height: 16,
                            // ),
                            // Row(children: [
                            //   Text(
                            //     '관심종목 설정',
                            //     style: TextStyle(fontSize: 16),
                            //   ),
                            //   Spacer(),
                            //   SizedBox(
                            //     width: 16,
                            //   ),
                            //   GestureDetector(
                            //     onTap: () {},
                            //     child: Icon(
                            //       Icons.arrow_forward_ios,
                            //       size: 16,
                            //       color: Colors.grey,
                            //     ),
                            //   ),
                            // ]),
                          ],
                        ),
                      ),
                    ),
        );
      },
    );
  }
}

Future buildModalBottomSheet(
    BuildContext context, MypageEditProfileViewModel model) {
  final ScrollController scrollController = ScrollController();

  return showModalBottomSheet(
    backgroundColor: Color(0xFF1EC8CF),
    context: context,
    isScrollControlled: true,
    builder: (context) => StatefulBuilder(builder: (context, setState) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(
          16.0,
          32.0,
          16.0,
          48.0,
        ),
        child: Container(
            height: deviceHeight / 2,
            child: Column(
              children: [
                Text(
                  '메리 크리스마스!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: Scrollbar(
                      // isAlwaysShown: true,
                      // _scrollController.hasClients ? true : false,
                      controller: scrollController,
                      child: ListView(
                          children: makeAvatarItemList(model, setState))),
                ),
                SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {
                    model.setAvatarImage(model.checkedAvatarImage);
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 32,
                    child: Center(
                      child: Text(
                        '선택하기',
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      );
    }),
  );
}

Widget avatarItems(
    MypageEditProfileViewModel model, StateSetter setState, int checkedIndex) {
  return GestureDetector(
    onTap: () {
      model.checkedAvatarImage = model.avatarImages[checkedIndex];
      model.notifyListeners();

      setState(() {});
    },
    child: Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 72,
            width: 72,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                    color: (model.avatarImages[checkedIndex] ==
                            model.checkedAvatarImage)
                        ? Color(0xFFFFFFFF).withOpacity(0.5)
                        : Color(0xFF1EC8CF),
                    width: 2)),
          ),
          Container(
            height: 60,
            width: 60,
            child: CircleAvatar(
              maxRadius: 60,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(
                  'assets/images/${model.avatarImages[checkedIndex]}.png'),
            ),
          ),
        ],
      ),
    ),
  );
}

List<Widget> makeAvatarItemList(
    MypageEditProfileViewModel model, StateSetter setState) {
  List<Widget> result = [];

  for (int i = 0; i < model.avatarImages.length; i += 3) {
    result.add(
      Row(
        children: [
          SizedBox(
            width: (deviceWidth - 16 * 2 - 72 * 3) / 4,
          ),
          avatarItems(model, setState, i),
          SizedBox(
            width: (deviceWidth - 16 * 2 - 72 * 3) / 4,
          ),
          (i + 1 < model.avatarImages.length)
              ? avatarItems(model, setState, i + 1)
              : Container(),
          SizedBox(
            width: (deviceWidth - 16 * 2 - 72 * 3) / 4,
          ),
          (i + 2 < model.avatarImages.length)
              ? avatarItems(model, setState, i + 2)
              : Container(),
          SizedBox(
            width: (deviceWidth - 16 * 2 - 72 * 3) / 4,
          ),
        ],
      ),
    );
    result.add(
      SizedBox(
        height: 16,
      ),
    );
  }

  return result;
}
