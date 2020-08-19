import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yachtOne/locator.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/views/constants/size.dart';

Widget voteWidget(voteModel, voteIdx, voteList, userVote, uid, model) {
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
            voteModel.subVotes[voteList[voteIdx]].title,
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
            voteModel.subVotes[voteList[voteIdx]].description,
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
          child:
              ggookButton2(voteModel, voteIdx, voteList, userVote, uid, model)),
      Positioned(
          bottom: 240,
          right: 50,
          child:
              gookkButton(voteModel, voteIdx, voteList, userVote, uid, model)),
    ],
  );
}

// RawMaterialButton version
Widget gookkButton(voteModel, voteIdx, voteList, userVote, uid, model) {
  NavigationService _navigationService = locator<NavigationService>();
  return RawMaterialButton(
    onPressed: () {},
    onLongPress: () {
      print('longPressed');
      print(voteIdx);
      print(voteList.length);
      print('vote' + (voteIdx + 2).toString());
      if (voteIdx + 1 < voteList.length) {
        List<int> tempList = userVote.voteSelected;
        tempList.fillRange(voteList[voteIdx], voteList[voteIdx] + 1, 2);

        userVote.voteSelected = tempList;
        print(tempList);
        model.addUserVoteDB(userVote);
        model.counterUserVote(userVote.voteSelected);

        _navigationService.navigateWithArgTo(
            'ggook', [uid, voteModel, voteList, voteIdx + 1]);
      } else {
        // TODO: userVote 모델로 만들어서 넘겨야함.
        List<int> tempList = userVote.voteSelected;
        tempList.fillRange(voteList[voteIdx], voteList[voteIdx] + 1, 2);

        userVote.voteSelected = tempList;
        userVote.isVoted = true;
        print(tempList);
        model.addUserVoteDB(userVote);
        model.counterUserVote(userVote.voteSelected);
        _navigationService.navigateWithArgTo(
          'voteComment',
          uid,
        );
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
      voteModel.subVotes[voteList[voteIdx]].voteChoices[1],
      style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF9EA6F1)),
    ),
  );
}

//LongPressGesturRecognizer version (누르는 시간 customized 가능)
Widget ggookButton2(voteModel, voteIdx, voteList, userVote, uid, model) {
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
          if (voteIdx + 1 < voteList.length) {
            List<int> tempList = userVote.voteSelected;
            tempList.fillRange(voteList[voteIdx], voteList[voteIdx] + 1, 1);

            userVote.voteSelected = tempList;
            print(tempList);
            model.addUserVoteDB(userVote);

            _navigationService.navigateWithArgTo(
              'ggook',
              [uid, voteModel, voteList, voteIdx + 1],
            );
          } else {
            // TODO: userVote 모델로 만들어서 넘겨야함.
            List<int> tempList = userVote.voteSelected;
            tempList.fillRange(voteList[voteIdx], voteList[voteIdx] + 1, 1);

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
          voteModel.subVotes[voteList[voteIdx]].voteChoices[0],
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF9EA6F1)),
        ),
      ),
    ),
  );
}
