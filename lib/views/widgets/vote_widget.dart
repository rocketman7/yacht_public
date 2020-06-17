import 'package:flutter/material.dart';
import 'package:yachtOne/views/constants/size.dart';

Widget kkuuk(
    voteModel, voteIdx, voteList, userVote, uid, _navigationService, model) {
  return Stack(
    children: <Widget>[
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0, 1],
            colors: <Color>[
              const Color(0xFF7BE0C8),
              const Color(0xFF53D3D8),
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
              color: Colors.white,
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
              color: Colors.white.withOpacity(.7),
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
              color: Colors.white.withOpacity(.7),
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

              _navigationService.navigateTo('');
            }
          },
          hoverColor: Colors.white,
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

              _navigationService.navigateTo('');
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
