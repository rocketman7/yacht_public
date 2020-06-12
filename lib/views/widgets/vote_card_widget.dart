import 'package:flutter/material.dart';
import 'package:yachtOne/models/vote_model.dart';
import 'package:yachtOne/views/constants/size.dart';

class VoteCard extends StatelessWidget {
  final int idx;
  final VoteModel vote;
  VoteCard(this.idx, this.vote);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: size.height * .44,
        width: size.width * .60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Color(0xFF060D15),
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: Offset(3.0, 3.0),
              blurRadius: 3.0,
              color: Colors.black,
            ),
          ],
        ),
        child: Stack(
          alignment: AlignmentDirectional.topStart,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image(
                height: size.width * .60,
                width: size.width * .60,
                fit: BoxFit.cover,
                image: NetworkImage(vote.subVotes[idx].voteImgUrl),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: gap_xxl,
                horizontal: gap_m,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          vote.subVotes[idx].voteChoices[0],
                          style: TextStyle(color: Colors.white, fontSize: 40,
                              // foreground: Paint()
                              //   ..strokeWidth = 1
                              //   ..color = Colors.black
                              //   ..style = PaintingStyle.stroke,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(3.0, 3.0),
                                  blurRadius: 3.0,
                                  color: Colors.black,
                                )
                              ]
                              // fontFamily: 'NanumHandWriting',
                              ),
                        ),
                      ),
                      SizedBox(
                        height: gap_xl,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'vs',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(3.0, 3.0),
                                  blurRadius: 3.0,
                                  color: Colors.black,
                                )
                              ]),
                        ),
                      ),
                      SizedBox(
                        height: gap_xl,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          vote.subVotes[idx].voteChoices[1],
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(3.0, 3.0),
                                  blurRadius: 3.0,
                                  color: Colors.black,
                                ),
                              ]
                              // fontFamily: 'NanumHandWriting',
                              ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        width: size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              vote.subVotes[idx].title,
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(3.0, 3.0),
                                    blurRadius: 3.0,
                                    color: Colors.black,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: gap_xl,
                            ),
                            Text(
                              vote.subVotes[idx].numVoted.toString() + ' Voted',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(3.0, 3.0),
                                    blurRadius: 3.0,
                                    color: Colors.black,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
