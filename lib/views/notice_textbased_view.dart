import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/notice_model.dart';

class NoticeTextBasedView extends StatelessWidget {
  final NoticeModel noticeModel;

  NoticeTextBasedView(this.noticeModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '공지사항',
          style: TextStyle(
            fontFamily: 'AppleSDEB',
            fontSize: 20.sp,
            letterSpacing: -2.0,
          ),
        ),
        elevation: 1,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${noticeModel.title}',
                maxLines: 100,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontFamily: 'AppleSDEB',
                  fontSize: 20.sp,
                  letterSpacing: -2.0,
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Text(
                '${noticeModel.noticeDateTime.toDate().toString().substring(0, 4)}.${noticeModel.noticeDateTime.toDate().toString().substring(5, 7)}.${noticeModel.noticeDateTime.toDate().toString().substring(8, 10)}',
                style: TextStyle(
                  fontFamily: 'AppleSDEM',
                  fontSize: 12.sp,
                  letterSpacing: -0.28,
                  color: Color(0xFF787878),
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              Container(
                height: 1,
                color: Color(0xFFF2F2F2),
              ),
              SizedBox(
                height: 16.h,
              ),
              Expanded(
                child: ListView(
                  children: [
                    Text(
                      '${noticeModel.content.replaceAll("\\n", "\n")}',
                      style: TextStyle(
                          fontFamily: 'AppleSDEM', fontSize: 16.h, height: 1.5
                          // letterSpacing: 1,
                          ),
                    ),
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

/*List<Widget> noticeList(NoticeTextBasedViewModel model) {
  List<Widget> result = [];

  for (int i = 0; i < model.noticeModel.length; i++) {
    result.add(GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // model.selectNoticeDetail(i);
      },
      child: Padding(
        padding: EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 20,
                  decoration: BoxDecoration(
                      color: model.isNew[i] ? Color(0xFFFFCA42) : Colors.black,
                      borderRadius: BorderRadius.circular(
                        30,
                      )),
                  child: Center(
                    child: Text(
                      model.isNew[i]
                          ? "NEW"
                          : "${model.noticeModel[i].category}",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'DmSans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.28),
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${model.noticeModel[i].title}',
                          // maxLines: model.isSelected[i] ? 100 : 1,
                          // overflow: model.isSelected[i]
                          //     ? TextOverflow.visible
                          //     : TextOverflow.ellipsis,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'DmSans',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.28)),
                      Text(
                        '${model.noticeDateTimeStr[i]}',
                        style: TextStyle(
                            fontSize: 12,
                            letterSpacing: -0.28,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF787878)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Icon(
                  // model.isSelected[i]
                  //     ? Icons.keyboard_arrow_up
                  //     : Icons.keyboard_arrow_down,
                  Icons.keyboard_arrow_right,
                  size: 20,
                )
              ],
            ),
          ],
        ),
      ),
    ));
    result.add(Container(
      height: 1,
      color: Color(0xFFF2F2F2),
    ));

    // model.isSelected[i]
    //     ? result.add(Container(
    //         color: Color(0xFFFAFAFA),
    //         child: Padding(
    //           padding:
    //               const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
    //           child: Text(
    //             '${model.noticeModel[i].content.replaceAll("\\n", "\n")}',
    //             style: TextStyle(
    //                 fontSize: 16,
    //                 letterSpacing: -0.28,
    //                 fontWeight: FontWeight.w500),
    //           ),
    //         ),
    //       ))
    //     : result.add(Container());
  }

  return result;
}
*/
