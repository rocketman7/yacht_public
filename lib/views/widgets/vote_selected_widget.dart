import 'package:flutter/material.dart';
import 'package:yachtOne/models/vote_model.dart';
import 'package:yachtOne/views/constants/size.dart';

class VoteSelected extends StatelessWidget {
  final int idx;
  final VoteModel vote;
  VoteSelected(this.idx, this.vote);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double displayRatio = size.height / size.width;

    return Padding(
      padding: EdgeInsets.only(
        right: gap_xxxs,
      ),
      child: Container(
        height: displayRatio > 1.85 ? size.height * .2 : size.height * .2,
        width: displayRatio > 1.85
            ? size.height * .2 / 1.6
            : size.height * .2 / 1.4,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0, .5, 1],
            colors: <Color>[
              const Color(0xFF000000),
              const Color(0xFF176658),
              const Color(0xFF000000),
            ],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    vote.subVotes![idx].voteChoices![0],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      // fontWeight: FontWeight.bold,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 2.0,
                          color: Colors.black.withOpacity(.35),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  'vs',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    // fontWeight: FontWeight.bold,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 2.0,
                        color: Colors.black.withOpacity(.35),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  vote.subVotes![idx].voteChoices![1],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 2.0,
                        color: Colors.black.withOpacity(.35),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Text(
              "더블 탭 하여 선택 취소",
              style: TextStyle(
                color: Color(0xFFBAB8B8),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
