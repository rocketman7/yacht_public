import 'package:flutter/material.dart';
import 'package:yachtOne/locator.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/views/constants/size.dart';

Widget voteWidget(voteModel, voteIdx, voteList, userVote, uid, model) {
  NavigationService _navigationService = locator<NavigationService>();
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
        child: FlatButton(
          onPressed: () {
            print('pressed');
          },

          onLongPress: () {
            print('longPressed');
            print(voteIdx);
            print(voteList.length);
            print('vote' + (voteIdx + 2).toString());
            if (voteIdx + 1 < voteList.length) {
              List<int> tempList = userVote.voteSelected;
              tempList.fillRange(voteList[voteIdx], voteList[voteIdx] + 1, 1);

              userVote.voteSelected = tempList;
              print(tempList);
              model.addUserVoteDB(userVote);

              _navigationService.navigateWithArgTo(
                  'vote' + (voteIdx + 1).toString(),
                  [uid, voteModel, voteList, userVote]);
            } else {
              // TODO: userVote 모델로 만들어서 넘겨야함.
              List<int> tempList = userVote.voteSelected;
              tempList.fillRange(voteList[voteIdx], voteList[voteIdx] + 1, 1);

              userVote.voteSelected = tempList;
              userVote.isVoted = true;
              print(tempList);
              model.addUserVoteDB(userVote);

              _navigationService.navigateWithArgTo(
                  'voteComment', [uid, voteModel, voteList, userVote]);
            }
          },
          color: Color(0xFFBDEEEF),
          // elevation: 2.0,
          // fillColor: Color(0xFFBDEEEF),
          // child: Icon(
          //   Icons.pause,
          // //   size: 35.0,
          // ),
          padding: EdgeInsets.all(40.0),
          shape: CircleBorder(),

          child: Text(
            voteModel.subVotes[voteList[voteIdx]].voteChoices[0],
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF1929F),
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 240,
        right: 50,
        child: RawMaterialButton(
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

              _navigationService.navigateWithArgTo(
                  'vote' + (voteIdx + 1).toString(),
                  [uid, voteModel, voteList, userVote]);
            } else {
              // TODO: userVote 모델로 만들어서 넘겨야함.
              List<int> tempList = userVote.voteSelected;
              tempList.fillRange(voteList[voteIdx], voteList[voteIdx] + 1, 2);

              userVote.voteSelected = tempList;
              userVote.isVoted = true;
              print(tempList);
              model.addUserVoteDB(userVote);
              _navigationService.navigateWithArgTo(
                  'voteComment', [uid, voteModel, voteList, userVote]);
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
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9EA6F1)),
          ),
        ),
      ),
    ],
  );
}
