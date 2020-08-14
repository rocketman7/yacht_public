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
    double displayRatio = size.height / size.width;
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: gap_xxxs,
        ),
        child: Container(
          height: displayRatio > 1.85 ? size.height * .44 : size.height * .49,
          width: displayRatio > 1.85 ? size.width * .60 : size.width * .55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            // color: Color(0xFFFFFFFF),
            boxShadow: <BoxShadow>[
              BoxShadow(
                offset: Offset(3.0, 3.0),
                blurRadius: 3.0,
                color: Colors.black,
              ),
            ],
          ),
          child: Stack(
            // alignment: AlignmentDirectional.topStart,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Color(0xFF0F2D3E),
                    // Colors.grey,
                    BlendMode.softLight,
                  ),
                  child: Image(
                    height: displayRatio > 1.85
                        ? size.height * .44
                        : size.height * .49,
                    width: displayRatio > 1.85
                        ? size.width * .60
                        : size.width * .55,
                    fit: BoxFit.cover,
                    image: NetworkImage(vote.subVotes[idx].voteImgUrl),
                  ),
                ),
              ),
              Positioned(
                top: displayRatio > 1.85
                    ? size.height * .44 * .63
                    : size.height * .49 * .63,
                child: Container(
                    height: displayRatio > 1.85
                        ? size.height * .44 * .25
                        : size.height * .49 * .25,
                    width: displayRatio > 1.85
                        ? size.width * .60
                        : size.width * .55,
                    color: Color(0xFF9CA2C0).withOpacity(.7),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: gap_s,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            "더블 탭 하여 선택",
                            style: TextStyle(
                              color: Color(0xFF302D2D),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: gap_m,
                        ),
                        Text(
                          vote.subVotes[idx].description,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          // overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            // shadows: <Shadow>[
                            //   Shadow(
                            //     offset: Offset(3.0, 3.0),
                            //     blurRadius: 3.0,
                            //     color: Colors.black,
                            //   )
                            // ],
                          ),
                        ),
                      ],
                    )),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  // vertical: gap_m,
                  horizontal: gap_m,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      // color: Colors.white,
                      child: SizedBox(
                        height: displayRatio > 1.85
                            ? size.width * .5
                            : size.width * .45,
                        width: displayRatio > 1.85
                            ? size.width * .60
                            : size.width * .55,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              vote.subVotes[idx].title,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 35,
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
                            Text(
                              vote.subVotes[idx].voteChoices[0],
                              style:
                                  TextStyle(color: Colors.white, fontSize: 28,
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
                            Text(
                              'vs',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(3.0, 3.0),
                                      blurRadius: 3.0,
                                      color: Colors.black,
                                    )
                                  ]),
                            ),
                            Text(
                              vote.subVotes[idx].voteChoices[1],
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
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
                          ],
                        ),
                      ),
                    ),
                    Container(
                      // color: Colors.white,
                      padding: EdgeInsets.only(
                        bottom: gap_l,
                      ),
                      width: size.width,
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          vote.subVotes[idx].numVoted.toString() + ' Voted',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontFamily: 'AdventPro',
                            color: Color(0xFFD2AEAE),
                            fontSize: 14,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 0,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
