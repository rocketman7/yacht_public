import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../view_models/faq_view_model.dart';

class FaqView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FaqViewModel>.reactive(
        viewModelBuilder: () => FaqViewModel(),
        builder: (context, model, child) {
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  '자주 묻는 질문',
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
                                children: faqList(model),
                              )),
                        ));
        });
  }
}

List<Widget> faqList(FaqViewModel model) {
  List<Widget> result = [];

  for (int i = 0; i < model.faqModel!.length; i++) {
    result.add(GestureDetector(
      // 이거 해줘야 나머지 페딩영역 선택해도 탭 됨
      behavior: HitTestBehavior.opaque,
      onTap: () {
        model.selectFaqDetail(i);
      },
      child: Padding(
        padding: EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // padding: EdgeInsets.symmetric(
                  //   vertical: 2,
                  //   horizontal: 13,
                  // ),
                  width: 50,
                  height: 20,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(
                        30,
                      )),
                  child: Center(
                    child: Text(
                      "${model.faqModel![i].category}",
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
                    child: Text('${model.faqModel![i].title}',
                        maxLines: model.isSelected[i] ? 100 : 1,
                        overflow: model.isSelected[i]
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'DmSans',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.28))),
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
                '${model.faqModel![i].content!.replaceAll("\\n", "\n")}',
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
