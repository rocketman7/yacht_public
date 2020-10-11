import 'dart:math';

import 'package:blobs/blobs.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../locator.dart';
import '../../models/database_address_model.dart';
import '../../models/user_model.dart';
import '../../models/user_vote_model.dart';
import '../../models/vote_model.dart';
import '../../services/navigation_service.dart';
import '../../view_models/ggook_view_model.dart';
import '../../views/constants/size.dart';
import 'package:vibration/vibration.dart';

Widget ggookWidget(
  DatabaseAddressModel address,
  UserModel user,
  VoteModel vote,
  List<int> listSelected,
  int idx,
  UserVoteModel userVote,
  GgookViewModel model,
) {
  var rng = Random();
  return Stack(
    children: [
      SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: deviceWidth * .8,
              child: Text(
                vote.subVotes[listSelected[idx]].ggookDescription,
                // "10월 12일 신성이엔지와 SK하이닉스중 더 많이 상승할 종목을 선택해주세요",
                style: TextStyle(
                    fontSize: 32,
                    letterSpacing: -0.5,
                    fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Container(
                  height: 16,
                  width: 48,
                  child: Stack(
                    children: [
                      Container(
                        height: 16,
                        width: 16,
                        child: CircleAvatar(
                          maxRadius: 16,
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage('assets/images/' +
                              "avatar00" +
                              (rng.nextInt(9) + 1).toString() +
                              '.png'),
                        ),
                      ),
                      Positioned(
                        left: 8,
                        child: Container(
                          height: 16,
                          width: 16,
                          child: CircleAvatar(
                            maxRadius: 16,
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage('assets/images/' +
                                "avatar00" +
                                (rng.nextInt(9) + 1).toString() +
                                '.png'),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        child: Container(
                          height: 16,
                          width: 16,
                          child: CircleAvatar(
                            maxRadius: 16,
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage('assets/images/' +
                                "avatar00" +
                                (rng.nextInt(9) + 1).toString() +
                                '.png'),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 24,
                        child: Container(
                          height: 16,
                          width: 16,
                          child: CircleAvatar(
                            maxRadius: 16,
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage('assets/images/' +
                                "avatar00" +
                                (rng.nextInt(9) + 1).toString() +
                                '.png'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${vote.subVotes[idx].numVoted0 ?? 1 + vote.subVotes[idx].numVoted1 ?? 1}명이 이 주제에 참여했습니다.',
                  style: TextStyle(fontSize: 16, letterSpacing: -0.28),
                )
              ],
            ),
            // Row(
            //   children: [
            //     Text(
            //       '네이버 전일가',
            //       style: TextStyle(fontSize: 16, letterSpacing: -0.28),
            //     ),
            //     Text(
            //       ' 322,450',
            //       style: TextStyle(
            //           fontSize: 16,
            //           letterSpacing: -0.28,
            //           fontFamily: 'DM Sans',
            //           fontWeight: FontWeight.bold,
            //           color: Color(0xFFFF3E3E)),
            //     ),
            //   ],
            // ),
            // Row(
            //   children: [
            //     Text(
            //       '카카오 전일가',
            //       style: TextStyle(fontSize: 16, letterSpacing: -0.28),
            //     ),
            //     Text(
            //       ' 389,000',
            //       style: TextStyle(
            //           fontSize: 16,
            //           letterSpacing: -0.28,
            //           fontFamily: 'DM Sans',
            //           fontWeight: FontWeight.bold,
            //           color: Color(0xFF3485FF)),
            //     ),
            //   ],
            // ),
            GestureDetector(
              child: Text('디버그'),
              onTap: () {
                // BlobData blobData = blobCtrl.change();
                // print(blobData);
                // setState(() {
                //   x += 10;
                // });
              },
            ),
            GestureDetector(
              child: Text('선택애니메이션'),
              onTap: () {
                // print(blobCtrl.change().size);
                // animationController.forward();
              },
            )
          ],
        ),
      )),
      Positioned(
        right: 20,
        bottom: 150,
        child: Container(
          width: 200,
          height: 400,
          // color: Colors.green,
          child: Stack(
            children: [
              // Positioned(child: Test5Widget()),
              TestWidget(),
              Positioned(
                  left: 10,
                  top: 10,
                  child: Test2Widget(
                    address,
                    user,
                    vote,
                    listSelected,
                    idx,
                    0,
                    userVote,
                    model,
                  )),
            ],
          ),
        ),
      ),
      Positioned(
        left: 20,
        bottom: 0,
        child: Container(
          // width: 400,
          height: 300,
          // color: Colors.yellow,
          child: Stack(
            children: [
              // Positioned(child: Test5Widget()),
              TestWidget(),
              Positioned(
                  left: 10,
                  top: 10,
                  child: Test2Widget(
                    address,
                    user,
                    vote,
                    listSelected,
                    idx,
                    1,
                    userVote,
                    model,
                  )),
            ],
          ),
        ),
      ),
    ],
  );
}

// RawMaterialButton version
Widget ggookButton(
  DatabaseAddressModel address,
  UserModel user,
  VoteModel vote,
  List<int> listSelected,
  int idx,
  int choice,
  UserVoteModel userVote,
  GgookViewModel model,
) {
  NavigationService _navigationService = locator<NavigationService>();
  return RawMaterialButton(
    onPressed: () {},
    onLongPress: () {
      print('longPressed');
      print(idx);
      print(listSelected.length);
      print('vote' + (idx + 2).toString());
      // 남은 투표 더 있을 때
      if (idx + 1 < listSelected.length) {
        List<int> tempList = userVote.voteSelected;
        print(tempList);
        tempList.fillRange(
            listSelected[idx], listSelected[idx] + 1, choice + 1);

        userVote.voteSelected = tempList;
        print("after 1vote" + userVote.voteSelected.toString());
        model.addUserVoteDB(address, userVote);

        // model.counterUserVote(address, userVote.voteSelected);

        _navigationService.navigateWithArgTo('ggook', [
          address,
          user,
          vote,
          listSelected,
          idx + 1,
          userVote,
        ]);
        // 남은 투표 없을 때
      } else {
        // TODO: userVote 모델로 만들어서 넘겨야함.
        List<int> tempList = userVote.voteSelected;
        print(tempList);
        tempList.fillRange(
            listSelected[idx], listSelected[idx] + 1, choice + 1);

        userVote.voteSelected = tempList;
        userVote.isVoted = true;
        print(tempList);
        model.addUserVoteDB(address, userVote);
        // 마지막 선택에서만 counter 콜해야됨
        model.counterUserVote(address, userVote.voteSelected);
        _navigationService.navigateWithArgTo('startup', 2);
      }
    },
    elevation: 2.0,
    fillColor: Color(0xFFBDEEEF),
    // child: Icon(
    //   Icons.pause,
    // //   size: 35.0,
    // ),
    padding: EdgeInsets.all(40.0),
    shape: CircleBorder(),
    child: Text(
      vote.subVotes[listSelected[idx]].voteChoices[choice],
      style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF9EA6F1)),
    ),
  );
}

//LongPressGesturRecognizer version (누르는 시간 customized 가능)
Widget ggookButton2(voteModel, idx, listSelected, userVote, uid, model) {
  LongPressGestureRecognizer _longPressGesture = LongPressGestureRecognizer(
    duration: Duration(milliseconds: 3000),
  );
  NavigationService _navigationService = locator<NavigationService>();

  return RawGestureDetector(
    gestures: <Type, GestureRecognizerFactory>{
      LongPressGestureRecognizer:
          GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
              () => _longPressGesture, (_longPressGesture) {
        _longPressGesture.onLongPress = () {
          if (idx + 1 < listSelected.length) {
            List<int> tempList = userVote.voteSelected;
            tempList.fillRange(listSelected[idx], listSelected[idx] + 1, 1);

            userVote.voteSelected = tempList;
            print(tempList);
            model.addUserVoteDB(userVote);

            _navigationService.navigateWithArgTo(
              'ggook',
              [uid, voteModel, listSelected, idx + 1],
            );
          } else {
            // TODO: userVote 모델로 만들어서 넘겨야함.
            List<int> tempList = userVote.voteSelected;
            tempList.fillRange(listSelected[idx], listSelected[idx] + 1, 1);

            userVote.voteSelected = tempList;
            userVote.isVoted = true;
            print(tempList);
            model.addUserVoteDB(userVote);

            _navigationService.navigateWithArgTo(
              'voteComment',
              uid,
            );
          }
        };
      }),
    },
    child: ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Container(
        color: Colors.blue,
        width: 100,
        height: 100,
        alignment: Alignment.center,
        // padding: EdgeInsets.all(40),
        child: Text(
          voteModel.subVotes[listSelected[idx]].voteChoices[0],
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF9EA6F1)),
        ),
      ),
    ),
  );
}

class Test2Widget extends StatefulWidget {
  final DatabaseAddressModel address;
  final UserModel user;
  final VoteModel vote;
  final List<int> listSelected;
  final int idx;
  final int choice;
  final UserVoteModel userVote;
  final GgookViewModel model;

  Test2Widget(
    this.address,
    this.user,
    this.vote,
    this.listSelected,
    this.idx,
    this.choice,
    this.userVote,
    this.model,
  );
  @override
  _Test2WidgetState createState() => _Test2WidgetState();
}

class _Test2WidgetState extends State<Test2Widget> {
  BlobController blobCtrl;
  NavigationService _navigationService = locator<NavigationService>();
  @override
  void dispose() {
    // blobCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseAddressModel address = widget.address;
    final UserModel user = widget.user;
    final VoteModel vote = widget.vote;
    final List<int> listSelected = widget.listSelected;
    final int idx = widget.idx;
    final int choice = widget.choice;
    final UserVoteModel userVote = widget.userVote;
    final GgookViewModel model = widget.model;

    LongPressGestureRecognizer _longPressGesture = LongPressGestureRecognizer(
      duration: Duration(milliseconds: 1300),
    );

    Color hexToColor(String code) {
      return Color(int.parse(code, radix: 16) + 0xFF0000000);
    }

    return GestureDetector(
      onTapDown: (details) async {
        if (await Vibration.hasVibrator()) {
          Vibration.vibrate(pattern: [10, 100, 50, 200, 40, 340, 30, 530]);

          print("tapped");
        }
      },
      onTapUp: (details) async {
        if (await Vibration.hasVibrator()) {
          Vibration.cancel();

          print("tapped out");
        }
      },
      child: RawGestureDetector(
        gestures: <Type, GestureRecognizerFactory>{
          LongPressGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
            () => _longPressGesture,
            (_longPressGesture) {
              _longPressGesture.onLongPress = () async {
                print("long tapped");
                // if (await Vibration.hasVibrator()) {
                //   Vibration.vibrate();
                // }
                if (idx + 1 < listSelected.length) {
                  List<int> tempList = userVote.voteSelected;
                  print(tempList);
                  tempList.fillRange(
                      listSelected[idx], listSelected[idx] + 1, choice + 1);

                  userVote.voteSelected = tempList;
                  print("after 1vote" + userVote.voteSelected.toString());
                  model.addUserVoteDB(address, userVote);

                  // model.counterUserVote(address, userVote.voteSelected);

                  _navigationService.navigateWithArgTo('ggook', [
                    address,
                    user,
                    vote,
                    listSelected,
                    idx + 1,
                    userVote,
                  ]);
                  // 남은 투표 없을 때
                } else {
                  // TODO: userVote 모델로 만들어서 넘겨야함.
                  List<int> tempList = userVote.voteSelected;
                  print(tempList);
                  tempList.fillRange(
                      listSelected[idx], listSelected[idx] + 1, choice + 1);

                  userVote.voteSelected = tempList;
                  userVote.isVoted = true;
                  print(tempList);
                  model.addUserVoteDB(address, userVote);
                  // 마지막 선택에서만 counter 콜해야됨
                  model.counterUserVote(address, userVote.voteSelected);
                  _navigationService.navigateWithArgTo('startup', 2);
                }
              };
            },
          )
        },
        child: Blob.animatedFromID(
            size: 180,
            id: [
              '10-7-88922',
              '10-7-848634',
              '10-7-863638',
              '10-7-63404',
              '10-7-424041',
            ],
            child: Center(
              child: Text(vote.subVotes[listSelected[idx]].voteChoices[choice],
                  style: TextStyle(
                    fontSize: 28,
                    fontFamily: 'DmSans',
                    fontWeight: FontWeight.w700,
                  )),
            ),
            styles: BlobStyles(
              color: vote.subVotes[listSelected[idx]].issueCode.length == 1
                  ? choice == 0
                      ? Color(0xFFFF3E3E)
                      : Color(0xFF3485FF)
                  : hexToColor(
                      vote.subVotes[listSelected[idx]].colorCode[choice]),
              // color: Color(0xFFFFDE34).withOpacity(.5),
            ),
            controller: blobCtrl,
            loop: true,
            duration: Duration(milliseconds: 2000)),
      ),
    );
  }
}

class TestWidget extends StatefulWidget {
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  BlobController blobCtrl;

  @override
  void dispose() {
    // blobCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Blob.animatedFromID(
        size: 200,
        id: [
          '10-7-848634',
          '10-7-863638',
          '10-7-63404',
          '10-7-424041',
          '10-7-88922'
        ],
        styles: BlobStyles(
          color: Color(0xFF000000),
        ),
        controller: blobCtrl,
        loop: true,
        duration: Duration(milliseconds: 2000));
  }
}
