import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../locator.dart';
import '../../models/user_model.dart';
import '../../models/user_vote_model.dart';
import '../../models/vote_model.dart';
import '../../models/database_address_model.dart';
import '../../services/navigation_service.dart';
import '../../view_models/ggook_view_model.dart';
import '../../views/constants/size.dart';

Widget ggookWidget(
  DatabaseAddressModel address,
  UserModel user,
  VoteModel vote,
  List<int> listSelected,
  int idx,
  UserVoteModel userVote,
  GgookViewModel model,
) {
  return Stack(
    children: <Widget>[
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0, 0.5, 1],
            colors: <Color>[
              Colors.white,
              Color(0xFFC4FEF3),
              Colors.white,
            ],
          ),
        ),
      ),
      Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            vote.subVotes[listSelected[idx]].title,
            style: TextStyle(
              color: Color(0xff5F5F5F),
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: gap_m,
          ),
          Text(
            vote.subVotes[listSelected[idx]].selectDescription ?? "",
            style: TextStyle(
              color: Color(0xff5F5F5F),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: gap_m,
          ),
          Text(
            "꾸욱 눌러서 투표하기",
            style: TextStyle(
              color: Color(0xff5F5F5F),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      )),
      Positioned(
          top: 240,
          left: 50,
          // child: RawMaterialButton
          child: ggookButton(
            address,
            user,
            vote,
            listSelected,
            idx,
            0,
            userVote,
            model,
          )),
      Positioned(
          bottom: 240,
          right: 50,
          child: ggookButton(
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
        model.counterUserVote(address, userVote.voteSelected);

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
