import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                          child: Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: ListView(
                                children: noticeList(model),
                              )),
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
        model.selectNoticeDetail(i);
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
                          maxLines: model.isSelected[i] ? 100 : 1,
                          overflow: model.isSelected[i]
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
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
                  model.isSelected[i]
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
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

    model.isSelected[i]
        ? result.add(Container(
            color: Color(0xFFFAFAFA),
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
              child: Text(
                '${model.noticeModel[i].content.replaceAll("\\n", "\n")}',
                style: TextStyle(
                    fontSize: 16,
                    letterSpacing: -0.28,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ))
        : result.add(Container());
  }

  return result;
}
