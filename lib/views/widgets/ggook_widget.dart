import 'dart:io';
import 'dart:math' as math;
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:blobs/blobs.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_2.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_3.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';

import 'package:yachtOne/models/sub_vote_model.dart';
import 'package:yachtOne/views/constants/holiday.dart';

import '../../locator.dart';
import '../../models/database_address_model.dart';
import '../../models/user_model.dart';
import '../../models/user_vote_model.dart';
import '../../models/vote_model.dart';
import '../../services/navigation_service.dart';
import '../../view_models/ggook_view_model.dart';
import '../../views/constants/size.dart';

class GgookWidget extends StatefulWidget {
  final DatabaseAddressModel address;
  final UserModel user;
  final VoteModel vote;
  final List<int> listSelected;
  final int idx;
  final UserVoteModel userVote;
  final GgookViewModel model;
  GgookWidget(
    this.address,
    this.user,
    this.vote,
    this.listSelected,
    this.idx,
    this.userVote,
    this.model,
  );

  @override
  _GgookWidgetState createState() => _GgookWidgetState();
}

class _GgookWidgetState extends State<GgookWidget>
    with TickerProviderStateMixin {
  DatabaseAddressModel address;
  UserModel user;
  VoteModel vote;
  List<int> listSelected;
  int idx;
  UserVoteModel userVote;
  GgookViewModel model;
  bool forwardAnimating = true;

  AnimationController animationController0;
  Animation animation0;
  AnimationController animationController1;
  Animation animation1;

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  void onTapDown(int choice) {
    print("ONTAPDOWN triggered");
    print(choice);
    choice == 0
        ? animationController0.forward()
        : animationController1.forward();
  }

  void onTapUp(int choice) {
    print("ONTAPUP Triggered");
    choice == 0
        ? animationController0.reverse()
        : animationController1.reverse();
  }

  var randomNumber = Random();

  @override
  void initState() {
    // TODO: implement initState
    animationController0 =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    animation0 =
        Tween<double>(begin: 0.0, end: 100.0).animate(animationController0);
    animationController0.addListener(() {
      // setState(() {});
    });

    animationController1 =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    animation1 =
        Tween<double>(begin: 0.0, end: 100.0).animate(animationController1);
    animationController1.addListener(() {
      // setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print("Random Number" + randomForBlob.nextDouble().toString());
    address = widget.address;
    user = widget.user;
    vote = widget.vote;
    listSelected = widget.listSelected;
    idx = widget.idx;
    userVote = widget.userVote;
    model = widget.model;

    final availableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    double blobSize = (deviceWidth - 32) * .47;
    // print(blobSize);
    // print("RANDOM" + randomNumber.nextDouble().toString());

    return WillPopScope(
      onWillPop: () async {
        _navigatorKey.currentState.maybePop();
        return false;
      },
      child: Stack(
        children: [
          Container(
            // color: Colors.blue,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                  Color(0xFFC000C5),
                  Color(0xFFFF0057),
                  Color(0xFFFAA15E),
                  Color(0xFF91E0FD),
                  Color(0xFF91E0FD),
                  Color(0xFF2D5BFF)
                ],
                    stops: [
                  0.0,
                  0.167,
                  0.333,
                  0.5,
                  0.9,
                  1.0,
                ])),
          ),
          SafeArea(
              child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // color: Colors.green,
                  height: availableHeight / 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: (availableHeight / 2) * .15,
                      ),
                      Text(
                          '${vote.subVotes[listSelected[idx]].ggookDescription.replaceAll("\\n", "\n")}',
                          // "10월 12일 신성이엔지와 SK하이닉스중 더 많이 상승할 종목을 선택해주세요",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            letterSpacing: -0.5,
                            fontFamily: 'AppleSDM',
                          )
                          // fontWeight: FontWeight.w700),
                          ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 16.h,
                            width: 48.w,
                            child: Stack(
                              children: [
                                Container(
                                  height: 16.h,
                                  width: 16.w,
                                  child: CircleAvatar(
                                    maxRadius: 16,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: AssetImage(
                                        'assets/images/' +
                                            "avatar00" +
                                            (randomNumber.nextInt(9) + 1)
                                                .toString() +
                                            '.png'),
                                  ),
                                ),
                                Positioned(
                                  left: 8.w,
                                  child: Container(
                                    height: 16.h,
                                    width: 16.w,
                                    child: CircleAvatar(
                                      maxRadius: 16,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: AssetImage(
                                          'assets/images/' +
                                              "avatar00" +
                                              (randomNumber.nextInt(9) + 1)
                                                  .toString() +
                                              '.png'),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 16.w,
                                  child: Container(
                                    height: 16.h,
                                    width: 16.w,
                                    child: CircleAvatar(
                                      maxRadius: 16,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: AssetImage(
                                          'assets/images/' +
                                              "avatar00" +
                                              (randomNumber.nextInt(9) + 1)
                                                  .toString() +
                                              '.png'),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 24.w,
                                  child: Container(
                                    height: 16.h,
                                    width: 16.w,
                                    child: CircleAvatar(
                                      maxRadius: 16,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: AssetImage(
                                          'assets/images/' +
                                              "avatar00" +
                                              (randomNumber.nextInt(9) + 1)
                                                  .toString() +
                                              '.png'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${vote.subVotes[idx].numVoted0 ?? 1 + vote.subVotes[idx].numVoted1 ?? 1}명이 이 주제에 참여했습니다.',
                            style: TextStyle(
                              fontFamily: 'AppleSDM',
                              fontSize: 14,
                              letterSpacing: -0.28,
                              color: Color(0xFFE3E3E3),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14),
                      Text(
                        "선택한 주제 ${idx + 1} / ${listSelected.length}",
                        style: TextStyle(
                          fontFamily: 'AppleSDM',
                          fontSize: 16,
                          letterSpacing: -0.28,
                          color: Color(0xFFE3E3E3),
                        ),
                      )
                    ],
                  ),
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
              ],
            ),
          )),
          Positioned(
            right:
                // (blobSize * .13),
                //  blobSize * .3,
                randomNumber.nextDouble() * (blobSize * .13),
            bottom:
                //  50,
                (randomNumber.nextDouble() *
                        (((availableHeight / 2) - blobSize) -
                            deviceHeight * .1)) +
                    (deviceHeight * .1),

            // deviceHeight * .1,
            // (availableHeight / 2) - blobSize,
            child: Container(
              // color: Colors.black,
              child: Stack(
                children: [
                  // Positioned(child: Test5Widget()),
                  OuterBlob(
                    vote,
                    listSelected,
                    idx,
                    0,
                    blobSize,
                  ),
                  GgookGuage0(
                    animationController0,
                    animation0,
                    blobSize,
                  ),
                  Positioned(
                      left: 10,
                      top: 10,
                      child: InnerBlob(
                        address,
                        user,
                        vote,
                        listSelected,
                        idx,
                        0,
                        userVote,
                        model,
                        onTapDown,
                        onTapUp,
                        blobSize,
                      )),
                ],
              ),
            ),
          ),
          Positioned(
            left:
                //  (blobSize * .13),
                randomNumber.nextDouble() * (blobSize * .13),
            bottom:
                // 50,
                randomNumber.nextDouble() *
                    ((availableHeight / 2) - (blobSize * 1.5)),
            child: Stack(
              children: [
                // Positioned(child: Test5Widget()),
                OuterBlob(
                  vote,
                  listSelected,
                  idx,
                  1,
                  blobSize,
                ),
                GgookGuage1(
                  animationController1,
                  animation1,
                  blobSize,
                ),
                Positioned(
                    left: 10,
                    top: 10,
                    child: InnerBlob(
                      address,
                      user,
                      vote,
                      listSelected,
                      idx,
                      1,
                      userVote,
                      model,
                      onTapDown,
                      onTapUp,
                      blobSize,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// RawMaterialButton version
// Widget ggookButton(
//   DatabaseAddressModel address,
//   UserModel user,
//   VoteModel vote,
//   List<int> listSelected,
//   int idx,
//   int choice,
//   UserVoteModel userVote,
//   GgookViewModel model,
// ) {
//   NavigationService _navigationService = locator<NavigationService>();
//   return RawMaterialButton(
//     onPressed: () {},
//     onLongPress: () {
//       print('longPressed');
//       print(idx);
//       print(listSelected.length);
//       print('vote' + (idx + 2).toString());
//       // 남은 투표 더 있을 때
//       if (idx + 1 < listSelected.length) {
//         List<int> tempList = userVote.voteSelected;
//         print(tempList);
//         tempList.fillRange(
//             listSelected[idx], listSelected[idx] + 1, choice + 1);

//         userVote.voteSelected = tempList;
//         print("after 1vote" + userVote.voteSelected.toString());
//         model.addUserVoteDB(address, userVote);

//         // model.counterUserVote(address, userVote.voteSelected);

//         _navigationService.navigateWithArgTo('ggook', [
//           address,
//           user,
//           vote,
//           listSelected,
//           idx + 1,
//           userVote,
//         ]);
//         // 남은 투표 없을 때
//       } else {
//         // TODO: userVote 모델로 만들어서 넘겨야함.
//         List<int> tempList = userVote.voteSelected;
//         print(tempList);
//         tempList.fillRange(
//             listSelected[idx], listSelected[idx] + 1, choice + 1);

//         userVote.voteSelected = tempList;
//         // userVote.isVoted = true;
//         print(tempList);
//         model.addUserVoteDB(address, userVote);
//         // 마지막 선택에서만 counter 콜해야됨
//         model.counterUserVote(address, userVote.voteSelected);
//         int newItem = user.item - listSelected.length;
//         model.updateUserItem(newItem);
//         _navigationService.navigateWithArgTo('startup', 2);
//       }
//     },
//     elevation: 2.0,
//     fillColor: Color(0xFFBDEEEF),
//     // child: Icon(
//     //   Icons.pause,
//     // //   size: 35.0,
//     // ),
//     padding: EdgeInsets.all(40.0),
//     shape: CircleBorder(),
//     child: Text(
//       vote.subVotes[listSelected[idx]].voteChoices[choice],
//       style: TextStyle(
//         fontSize: 14,
//         fontWeight: FontWeight.bold,
//         color: Color(0xFF9EA6F1),
//       ),
//     ),
//   );
// }

//LongPressGesturRecognizer version (누르는 시간 customized 가능)
// Widget ggookButton2(voteModel, idx, listSelected, userVote, uid, model) {
//   LongPressGestureRecognizer _longPressGesture = LongPressGestureRecognizer(
//     duration: Duration(milliseconds: 3000),
//   );
//   NavigationService _navigationService = locator<NavigationService>();

//   return RawGestureDetector(
//     gestures: <Type, GestureRecognizerFactory>{
//       LongPressGestureRecognizer:
//           GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
//               () => _longPressGesture, (_longPressGesture) {
//         _longPressGesture.onLongPress = () {
//           if (idx + 1 < listSelected.length) {
//             List<int> tempList = userVote.voteSelected;
//             tempList.fillRange(listSelected[idx], listSelected[idx] + 1, 1);

//             userVote.voteSelected = tempList;
//             print(tempList);
//             model.addUserVoteDB(userVote);

//             _navigationService.navigateWithArgTo(
//               'ggook',
//               [uid, voteModel, listSelected, idx + 1],
//             );
//           } else {
//             // TODO: userVote 모델로 만들어서 넘겨야함.
//             List<int> tempList = userVote.voteSelected;
//             tempList.fillRange(listSelected[idx], listSelected[idx] + 1, 1);

//             userVote.voteSelected = tempList;
//             userVote.isVoted = true;
//             print(tempList);
//             model.addUserVoteDB(userVote);

//             _navigationService.navigateWithArgTo(
//               'voteComment',
//               uid,
//             );
//           }
//         };
//       }),
//     },
//     child: ClipRRect(
//       borderRadius: BorderRadius.circular(100),
//       child: Container(
//         color: Colors.blue,
//         width: 100,
//         height: 100,
//         alignment: Alignment.center,
//         // padding: EdgeInsets.all(40),
//         child: Text(
//           voteModel.subVotes[listSelected[idx]].voteChoices[0],
//           style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF9EA6F1)),
//         ),
//       ),
//     ),
//   );
// }

class InnerBlob extends StatefulWidget {
  final DatabaseAddressModel address;
  final UserModel user;
  final VoteModel vote;
  final List<int> listSelected;
  final int idx;
  final int choice;
  final UserVoteModel userVote;
  final GgookViewModel model;
  final Function onTapDown;
  final Function onTapUp;
  final double blobSize;

  InnerBlob(
    this.address,
    this.user,
    this.vote,
    this.listSelected,
    this.idx,
    this.choice,
    this.userVote,
    this.model,
    this.onTapDown,
    this.onTapUp,
    this.blobSize,
  );
  @override
  _InnerBlobState createState() => _InnerBlobState();
}

class _InnerBlobState extends State<InnerBlob> {
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
      duration: Duration(milliseconds: 600),
    );

    Color hexToColor(String code) {
      return Color(int.parse(code, radix: 16) + 0xFF0000000);
    }

    return GestureDetector(
      onTapDown: (details) {
        Vibration.vibrate();

        widget.onTapDown(choice);
        print(choice);
        print("tapped");
      },
      onTapUp: (details) {
        Vibration.cancel();
        widget.onTapUp(choice);
        print("tapped out");
      },
      child: RawGestureDetector(
        gestures: <Type, GestureRecognizerFactory>{
          LongPressGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
            () => _longPressGesture,
            (_longPressGesture) {
              _longPressGesture.onLongPress = () async {
                bool isVoting = true;
                print("long tapped");
                // if (await Vibration.hasVibrator()) {
                //   Vibration.vibrate();
                // }
                if (idx + 1 < listSelected.length) {
                  isVoting = model.checkIfVotingTime(address.category);
                  if (isVoting) {
                    List<int> tempList = userVote.voteSelected;
                    print(tempList);
                    tempList.fillRange(
                        listSelected[idx], listSelected[idx] + 1, choice + 1);

                    userVote.voteSelected = tempList;
                    userVote.isVoted = true;
                    print("after 1vote" + userVote.voteSelected.toString());
                    model.addUserVoteDB(address, userVote);
                    model.decreaseUserItem();
                    // model.counterUserVote(address, userVote.voteSelected);

                    _navigationService.navigateWithArgTo('ggook', [
                      address,
                      user,
                      vote,
                      userVote,
                      listSelected,
                      idx + 1,
                    ]);
                  } else {
                    showVoteNotAvailable(context);
                  }
                  // 남은 투표 없을 때
                } else {
                  isVoting = model.checkIfVotingTime(address.category);
                  // TODO: userVote 모델로 만들어서 넘겨야함.
                  if (isVoting) {
                    List<int> tempList = userVote.voteSelected;
                    print(tempList);
                    tempList.fillRange(
                        listSelected[idx], listSelected[idx] + 1, choice + 1);

                    userVote.voteSelected = tempList;
                    userVote.isVoted = true;
                    print(tempList);
                    model.addUserVoteDB(address, userVote);
                    model.decreaseUserItem();
                    // 마지막 선택에서만 counter 콜해야됨
                    // int newItem = user.item - listSelected.length;
                    // model.updateUserItem(newItem);
                    model.counterUserVote(address, userVote.voteSelected);

                    showVoteSummary(context, vote, tempList);
                  } else {
                    showVoteNotAvailable(context);
                  }

                  // _navigationService.navigateWithArgTo('startup', 1);
                }
              };
            },
          )
        },
        child: Blob.animatedFromID(
            size: widget.blobSize - 20,
            id: [
              '10-7-88922',
              '10-7-848634',
              '10-7-863638',
              '10-7-63404',
              '10-7-424041',
            ],
            child: Center(
              child: Container(
                alignment: Alignment.center,
                height: 40,
                width: widget.blobSize - 70,
                // color: Colors.blue,
                child: AutoSizeText(
                  vote.subVotes[listSelected[idx]].voteChoices[choice],
                  // "삼성바이오로직스",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'AppleSDB',
                  ),
                  maxLines: 1,
                ),
              ),
            ),
            styles: BlobStyles(
              color: Colors.white,
              //  vote.subVotes[listSelected[idx]].issueCode.length == 1
              //     ? choice == 0
              //         ? Color(0xFFFF3E3E)
              //         : Color(0xFF3485FF)
              //     : hexToColor(
              //         vote.subVotes[listSelected[idx]].colorCode[choice]),
              // color: Color(0xFFFFDE34).withOpacity(.5),
            ),
            controller: blobCtrl,
            loop: true,
            duration: Duration(milliseconds: 2000)),
      ),
    );
  }

  Future showVoteSummary(
      BuildContext context, VoteModel vote, List<int> tempList) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          var formatKoreanDate = DateFormat('MM' + "월" + " " + "dd" + "일");
          return WillPopScope(
            onWillPop: () {},
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)), //this right here
              child: Container(
                height: 300,
                width: deviceWidth * .9,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 14,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatKoreanDate.format(strToDate(vote.voteDate)) +
                                "의 예측 완료!",
                            style: TextStyle(
                              fontFamily: 'AppleSDB',
                              fontSize: 26,
                              letterSpacing: -.2,
                            ),
                          ),
                          // SizedBox(
                          //   height: 4,
                          // ),
                          Text(
                            "아래와 같이 예측하셨네요 😎",
                            style: TextStyle(
                                fontFamily: 'AppleSDM',
                                fontSize: 16,
                                color: Color(0xFF323232)),
                          ),
                          // SizedBox(height: 12),
                          SizedBox(
                            height: 16,
                          ),
                          Container(
                            // color: Colors.blue,
                            height: 80,
                            child: ListView.builder(
                              itemCount: vote.voteCount,
                              itemBuilder: (context, index) {
                                TextStyle selectedTitle = TextStyle(
                                  fontFamily: 'AppleSDB',
                                  fontSize: 20,
                                  color: Colors.black,
                                  height: 1,
                                );
                                TextStyle notSelectedTitle = TextStyle(
                                  fontFamily: 'AppleSDM',
                                  fontSize: 20,
                                  color: Colors.grey,
                                  height: 1,
                                );
                                TextStyle selectedUp = TextStyle(
                                  fontFamily: 'AppleSDB',
                                  fontSize: 18,
                                  color: Color(0xFFFF3E3E),
                                  height: 1,
                                );

                                TextStyle selectedDown = TextStyle(
                                  fontFamily: 'AppleSDB',
                                  fontSize: 18,
                                  color: Color(0xFF3485FF),
                                  height: 1,
                                );

                                int length =
                                    vote.subVotes[index].issueCode.length;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    length == 1
                                        ? Row(
                                            children: [
                                              Text(vote.subVotes[index].title,
                                                  style: tempList[index] == 0
                                                      ? notSelectedTitle
                                                      : selectedTitle),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              tempList[index] == 0
                                                  ? Container()
                                                  : tempList[index] == 1
                                                      ? Text(
                                                          vote.subVotes[index]
                                                              .voteChoices[0],
                                                          style: selectedUp,
                                                        )
                                                      : Text(
                                                          vote.subVotes[index]
                                                              .voteChoices[1],
                                                          style: selectedDown,
                                                        ),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              Text(
                                                vote.subVotes[index]
                                                    .voteChoices[0],
                                                style: tempList[index] == 0
                                                    ? notSelectedTitle
                                                    : tempList[index] == 1
                                                        ? selectedTitle
                                                        : notSelectedTitle,
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                "VS",
                                                style: notSelectedTitle,
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                vote.subVotes[index]
                                                    .voteChoices[1],
                                                style: tempList[index] == 0
                                                    ? notSelectedTitle
                                                    : tempList[index] == 2
                                                        ? selectedTitle
                                                        : notSelectedTitle,
                                              ),
                                            ],
                                          ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),

                          // SizedBox(
                          //   height: 8,
                          // ),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  // width: deviceWidth * .27,
                                  child: ChatBubble(
                                    clipper: ChatBubbleClipper3(
                                        type: BubbleType.receiverBubble),
                                    alignment: Alignment.bottomLeft,
                                    backGroundColor: Color(0xFFFFF6F6),
                                    child: AutoSizeText(
                                      "예측을 수정하거나 추가할 수 있어요!",
                                      style: TextStyle(
                                          fontFamily: 'AppleSDL',
                                          fontSize: 14,
                                          color: Color(0xFF555555)),
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Expanded(
                                flex: 6,
                                child: Container(
                                  // color: Colors.red,
                                  // width: deviceWidth * .3,
                                  child: ChatBubble(
                                    clipper: ChatBubbleClipper3(
                                        type: BubbleType.sendBubble),
                                    alignment: Alignment.bottomRight,
                                    // margin:
                                    //     EdgeInsets.only(top: 20),
                                    backGroundColor: Color(0xFFFFF6F6),
                                    child:
                                        AutoSizeText("다른 유저의 예측과\n의견을 볼 수 있어요!",
                                            style: TextStyle(
                                              fontFamily: 'AppleSDL',
                                              fontSize: 14,
                                              color: Color(0xFF555555),
                                            ),
                                            maxLines: 2),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              FlatButton(
                                minWidth: deviceWidth * .28,
                                onPressed: () {
                                  Navigator.pop(context);
                                  _navigationService.navigateWithArgTo(
                                      'startup', 0);
                                },
                                child: Text(
                                  "홈으로 이동",
                                  style: TextStyle(
                                      fontFamily: 'AppleSDM',
                                      color: Colors.white),
                                ),
                                color: const Color(0xFF989898),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: RaisedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _navigationService.navigateWithArgTo(
                                        'startup', 1);
                                  },
                                  child: Text(
                                    "커뮤니티로 이동",
                                    style: TextStyle(
                                        fontFamily: 'AppleSDM',
                                        color: Colors.white),
                                  ),
                                  color: const Color(0xFF1EC8CF),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Future showVoteNotAvailable(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {},
            child: Platform.isIOS
                ? CupertinoAlertDialog(
                    title: Text("예측이 마감되었습니다."),
                    content: Text("평일 오전 8시 50분부터 오후 4시까지\n예측에 참여할 수 없습니다.."),
                    actions: [
                      CupertinoDialogAction(
                        child: Text("홈으로 돌아가기"),
                        onPressed: () {
                          Navigator.pop(context);
                          _navigationService.navigateWithArgTo('startup', 0);
                        },
                      )
                    ],
                  )
                : AlertDialog(
                    title: Text("예측이 마감되었습니다."),
                    content: Text("평일 오전 8시 50분부터 오후 4시까지\n예측에 참여할 수 없습니다.."),
                    actions: [
                      FlatButton(
                        child: Text("홈으로 돌아가기"),
                        onPressed: () {
                          Navigator.pop(context);
                          _navigationService.navigateWithArgTo('startup', 0);
                        },
                      )
                    ],
                  ),
          );
        });
  }
}

class OuterBlob extends StatefulWidget {
  final VoteModel vote;
  final List<int> listSelected;
  final int idx;
  final int choice;
  final double blobSize;
  OuterBlob(this.vote, this.listSelected, this.idx, this.choice, this.blobSize);

  @override
  _OuterBlobState createState() => _OuterBlobState();
}

class _OuterBlobState extends State<OuterBlob> {
  BlobController blobCtrl;

  @override
  void dispose() {
    // blobCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    VoteModel vote = widget.vote;
    List<int> listSelected = widget.listSelected;
    int idx = widget.idx;

    int choice = widget.choice;
    Color hexToColor(String code) {
      return Color(int.parse(code, radix: 16) + 0xFF0000000);
    }

    return Blob.animatedFromID(
        size: widget.blobSize,
        id: [
          '10-7-848634',
          '10-7-863638',
          '10-7-63404',
          '10-7-424041',
          '10-7-88922'
        ],
        styles: BlobStyles(
          color: vote.subVotes[listSelected[idx]].issueCode.length == 1
              ? choice == 0
                  ? Color(0xFFFFC8F3)
                  : Color(0xFFB2FAFF)
              : hexToColor(vote.subVotes[listSelected[idx]].colorCode[choice]),
        ),
        controller: blobCtrl,
        loop: true,
        duration: Duration(milliseconds: 2000));
  }
}

class GgookGuage0 extends StatefulWidget {
  final AnimationController animationController0;
  final Animation animation0;
  final double blobSize;

  GgookGuage0(
    this.animationController0,
    this.animation0,
    this.blobSize,
  );
  @override
  _GgookGuage0State createState() => _GgookGuage0State();
}

class _GgookGuage0State extends State<GgookGuage0>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // _animationController =
    //     AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    // animation =
    //     Tween<double>(begin: 0.0, end: 100.0).animate(_animationController);
    // _animationController.addListener(() {
    //   setState(() {});
    // });
    // _animationController.repeat();
  }

  @override
  void dispose() {
    widget.animationController0.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AnimationController _animationController0 = widget.animationController0;
    Animation animation0 = widget.animation0;
    bool isForwarding = false;

    print("FORWARDING" + isForwarding.toString()); // return Transform.rotate(
    //   angle: (animation.value * 0.6) * 360.0,
    //   child: Container(
    //     width: 200,
    //     height: 200,
    //     decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
    //   ),
    // );
    return AnimatedBuilder(
        animation: animation0,
        builder: (context, child) {
          return GestureDetector(
            onTapDown: (_) {
              print("PieChart tapped");
              _animationController0.forward();
            },
            onTapUp: (_) {
              _animationController0.reverse();
            },
            child: CustomPaint(
                size: Size(
                  widget.blobSize + 10,
                  widget.blobSize + 10,
                ),
                painter: PieChart0(percentage: animation0.value)),
          );
        });
  }
}

class PieChart0 extends CustomPainter {
  double percentage = 0;

  PieChart0({this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;

    double radius = math.min(size.width / 2, size.height / 2);
    Offset center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, radius, paint);

    double arcAngle = 2 * math.pi * (percentage / 100);

    paint..color = Color(0xFF91E0FD);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2 - (math.pi / 6), arcAngle, true, paint);
  }

  @override
  bool shouldRepaint(PieChart0 old) {
    return old.percentage != percentage;
  }
}

class GgookGuage1 extends StatefulWidget {
  final AnimationController animationController1;
  final Animation animation1;
  final double blobSize;

  GgookGuage1(
    this.animationController1,
    this.animation1,
    this.blobSize,
  );
  @override
  _GgookGuage1State createState() => _GgookGuage1State();
}

class _GgookGuage1State extends State<GgookGuage1>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // _animationController =
    //     AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    // animation =
    //     Tween<double>(begin: 0.0, end: 100.0).animate(_animationController);
    // _animationController.addListener(() {
    //   setState(() {});
    // });
    // _animationController.repeat();
  }

  @override
  void dispose() {
    widget.animationController1.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AnimationController _animationController1 = widget.animationController1;
    Animation animation1 = widget.animation1;
    bool isForwarding = false;

    print("FORWARDING" + isForwarding.toString()); // return Transform.rotate(
    //   angle: (animation.value * 0.6) * 360.0,
    //   child: Container(
    //     width: 200,
    //     height: 200,
    //     decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
    //   ),
    // );
    return AnimatedBuilder(
        animation: animation1,
        builder: (context, child) {
          return GestureDetector(
            onTapDown: (_) {
              print("PieChart tapped");
              _animationController1.forward();
            },
            onTapUp: (_) {
              _animationController1.reverse();
            },
            child: CustomPaint(
                size: Size(
                  widget.blobSize + 10,
                  widget.blobSize + 10,
                ),
                painter: PieChart1(percentage: animation1.value)),
          );
        });
  }
}

class PieChart1 extends CustomPainter {
  double percentage = 0;

  PieChart1({this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;

    double radius = math.min(size.width / 2, size.height / 2);
    Offset center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, radius, paint);

    double arcAngle = 2 * math.pi * (percentage / 100);

    paint..color = Color(0xFF91E0FD);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2 - (math.pi / 6), arcAngle, true, paint);
  }

  @override
  bool shouldRepaint(PieChart1 old) {
    return old.percentage != percentage;
  }
}
