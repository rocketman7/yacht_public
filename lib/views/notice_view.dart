import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../view_models/notice_view_model.dart';

class NoticeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NoticeViewModel>.reactive(
        viewModelBuilder: () => NoticeViewModel(),
        builder: (context, model, child) {
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
              body: model.hasError
                  ? Container(
                      child: Text('error발생. 페이지를 벗어나신 후 다시 시도하세요.'),
                    )
                  : model.isBusy
                      ? Container()
                      : SafeArea(
                          child: ListView(
                            children: noticeList(model),
                          ),
                        ));
        });
  }
}

List<Widget> noticeList(NoticeViewModel model) {
  List<Widget> result = [];

  for (int i = 0; i < model.noticeModel.length; i++) {
    result.add(GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        model.selectNotice(i);
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
                          fontFamily: 'AppleSDM',
                          fontSize: 12.sp,
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
                      Text(
                        '${model.noticeModel[i].title}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'AppleSDM',
                          fontSize: 16.sp,
                          letterSpacing: -0.28,
                        ),
                      ),
                      Text(
                        '${model.noticeDateTimeStr[i]}',
                        style: TextStyle(
                            fontSize: 12.sp,
                            letterSpacing: -0.28,
                            fontFamily: 'AppleSDM',
                            color: Color(0xFF787878)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Icon(
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
  }

  return result;
}
