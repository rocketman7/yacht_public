import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../views/constants/size.dart';
import '../models/post_model.dart';
import '../view_models/community_view_model.dart';

class CommunityView extends StatefulWidget {
  final String category;
  final String issueCode;
  final String name;

  CommunityView(this.category, this.issueCode, this.name);

  @override
  _CommunityViewState createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CommunityViewModel>.reactive(
        viewModelBuilder: () =>
            CommunityViewModel(widget.category, widget.issueCode, widget.name),
        builder: (context, model, child) {
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  '${model.name}',
                  style: TextStyle(
                    fontFamily: 'AppleSDEB',
                    fontSize: 20.sp,
                    letterSpacing: -2.0,
                  ),
                ),
                elevation: 0,
              ),
              backgroundColor: Colors.white,
              body: model.hasError
                  ? Container(
                      child: Text('error발생. 페이지를 벗어나신 후 다시 시도하세요.'),
                    )
                  : model.isBusy
                      ? Container()
                      : SafeArea(
                          child: Column(
                            children: [
                              Container(
                                color: Colors.black,
                                height: 1,
                              ),
                              Expanded(child: buildCommentList(model))
                            ],
                          ),
                        ));
        });
  }

  Widget buildCommentList(CommunityViewModel model) {
    return StreamBuilder<List<PostModel>>(
      stream: model.getPost(),
      builder: (context, snapshot) {
        List<PostModel>? postList = snapshot.data;

        if (snapshot.data == null) {
          print('snapshot.data is null');
          return Container();
        } else if (snapshot.data!.length == 0) {
          print('snapshot.data is 0');
          return Container();
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            reverse: true,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {},
                child: Column(
                  children: [
                    Container(
                      color: Color(0xFFF2F2F2),
                      height: 1,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 12,
                        ),
                        Container(
                          height: 36,
                          width: 36,
                          child: FutureBuilder(
                            future: model.getAvatar(postList![index].uid),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                String? _avatar = snapshot.data.toString();
                                return CircleAvatar(
                                  maxRadius: 36,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage:
                                      AssetImage('assets/images/$_avatar.png'),
                                );
                              } else {
                                return Container(
                                  height: 36,
                                  width: 36,
                                );
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              FutureBuilder(
                                future: model.getNickName(postList[index].uid),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    String? _nickName =
                                        snapshot.data.toString();

                                    return Row(
                                      children: [
                                        Text(
                                          '$_nickName',
                                          style: TextStyle(
                                              fontFamily: 'AppleSDEB',
                                              fontSize: 12.sp,
                                              letterSpacing: -1.0,
                                              color: Color(0xFF979797)),
                                        ),
                                        postList[index].uid == model.uid
                                            ? Text(
                                                '(본인)',
                                                style: TextStyle(
                                                    fontFamily: 'AppleSDM',
                                                    fontSize: 12.sp,
                                                    letterSpacing: -1.0,
                                                    color: Color(0xFF979797)),
                                              )
                                            : Container(),
                                      ],
                                    );
                                  } else {
                                    return Text(
                                      '',
                                      style: TextStyle(
                                          fontFamily: 'AppleSDEB',
                                          fontSize: 12.sp,
                                          letterSpacing: -1.0,
                                          color: Color(0xFF979797)),
                                    );
                                  }
                                },
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                '7일 전',
                                style: TextStyle(
                                    fontFamily: 'AppleSDM',
                                    fontSize: 12.sp,
                                    letterSpacing: -1.0,
                                    color: Color(0xFF979797)),
                              ),
                            ]),
                            SizedBox(
                              height: 3,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: deviceWidth! - 74,
                                      child: Text(
                                        '${postList[index].postText}',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontFamily: 'AppleSDM',
                                            fontSize: 14.sp,
                                            height: 1.3,
                                            letterSpacing: -1.0,
                                            wordSpacing: 2.0,
                                            color: Color(0xFF000000)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 18,
                                      // child: Container(
                                      //   height: 10,
                                      //   color: Colors.red,
                                      // ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Container(
                                  width: deviceWidth! - 72,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        child: SvgPicture.asset(
                                            'assets/icons/heart.svg',
                                            color: Color(0xFF979797)),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        '${postList[index].likedBy!.length}',
                                        style: TextStyle(
                                            fontFamily: 'AppleSDM',
                                            fontSize: 12.sp,
                                            letterSpacing: -1.0,
                                            color: Color(0xFF979797)),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Container(
                                        width: 12,
                                        height: 12,
                                        child: SvgPicture.asset(
                                            'assets/icons/nested_comment.svg',
                                            color: Color(0xFF979797)),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        '${postList[index].replyList!.length}',
                                        style: TextStyle(
                                            fontFamily: 'AppleSDM',
                                            fontSize: 12.sp,
                                            letterSpacing: -1.0,
                                            color: Color(0xFF979797)),
                                      ),
                                      Spacer(),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            // color: Colors.red,
                                          ),
                                          height: 20,
                                          width: 20,
                                          child: Center(
                                            child: Container(
                                              width: 10,
                                              height: 10,
                                              child: SvgPicture.asset(
                                                  'assets/icons/menu-dots.svg',
                                                  color: Color(0xFF979797)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                postList[index].replyList!.length == 0
                                    ? Container()
                                    : Text(
                                        '답글 ${postList[index].replyList!.length}개',
                                        style: TextStyle(
                                            fontFamily: 'AppleSDB',
                                            fontSize: 12.sp,
                                            letterSpacing: -1.0,
                                            color: Color(0xFF1EC8CF)),
                                      )
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    )
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}

// Container(
//    width: 30,
//    height: 30,
//    padding: EdgeInsets.all(4),
//    // decoration: BoxDecoration(
//    //     borderRadius: BorderRadius.all(
//    //         Radius.circular(100.0)),
//    //     color: Color(0xFF1EC8CF),
//    //     border: Border.all(
//    //         color: Colors.white,
//    //         width: 2)),
//    child: SvgPicture.asset(
//      'assets/icons/dog_foot.svg',
//      color: Color(0xFF1EC8CF),
//    ),
//  ),

// FutureBuilder(
//                       future: model.getAvatar(voteComment.uid),
//                       builder: (context, snapshot) {
//                         if (snapshot.hasData) {
//                           String _avatar = snapshot.data;
//                           print("FutureBUilder" + snapshot.data.toString());
//                           return Container(
//                               height: 40,
//                               width: 40,
//                               child: avatarWidgetWithoutItem(_avatar));
//                         } else {
//                           return Container(
//                             height: 40,
//                             width: 40,
//                           );
//                         }
//                       }),

// Widget buildCommentList(
//     SubjectCommunityViewModel model,
//   ) {
//     return StreamBuilder<List<VoteCommentModel>>(
//         stream: model.getPost(model.newAddress),
//         builder: (context, snapshot) {
//           List<VoteCommentModel> beforeCommentList = snapshot.data;

//           if (snapshot.data == null) {
//             return Container();
//           } else if (snapshot.data.length == 0) {
//             return Center(
//               child: Text(
//                 "아직 의견이 없습니다.\n ${model.user.userName}님이 첫 번째 의견을 나눠보세요.",
//                 style: TextStyle(
//                   fontFamily: 'DmSans',
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF999999),
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             );
//           } else {
//             List<dynamic> blockList = model.user.blockList;
//             List<VoteCommentModel> commentList = [];
//             if (blockList != null) {
//               for (int i = 0; i < beforeCommentList.length; i++) {
//                 if (blockList.contains(beforeCommentList[i].uid)) {
//                   print("NOT Contain");
//                 } else {
//                   commentList.add(beforeCommentList[i]);
//                 }
//               }
//             } else {
//               commentList = beforeCommentList;
//             }
//             return Container(

//                 // height: deviceHeight * .55,
//                 child: ListView.builder(
//                     key: _scaffoldKey,
//                     controller: _commentScrollController,
//                     // addAutomaticKeepAlives: true,
//                     itemCount: commentList.length,
//                     scrollDirection: Axis.vertical,
//                     reverse: true,
//                     itemBuilder: (context, index) {
//                       return buildColumn(
//                           model, commentList[index], commentList, index);
//                     }));
//           }
//         });
//   }
