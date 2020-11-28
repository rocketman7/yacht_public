import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../view_models/oneOnOne_view_model.dart';

class OneOnOneView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OneOnOneViewModel>.reactive(
        viewModelBuilder: () => OneOnOneViewModel(),
        builder: (context, model, child) {
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  '1:1 문의',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                          child: Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 16,
                                      ),
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          model.changePage();
                                        },
                                        child: Column(
                                          children: [
                                            Text(
                                              '문의 작성',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: -0.28,
                                                  color: model.isPageOne
                                                      ? Colors.black
                                                      : Colors.black
                                                          .withOpacity(0.2)),
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Container(
                                              width: 64,
                                              height: model.isPageOne ? 2 : 0,
                                              color: Color(0xFF1EC8CF),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          model.changePage();
                                        },
                                        child: Column(
                                          children: [
                                            Text(
                                              '나의 문의',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: -0.28,
                                                  color: model.isPageOne
                                                      ? Colors.black
                                                          .withOpacity(0.2)
                                                      : Colors.black),
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Container(
                                              width: 64,
                                              height: model.isPageOne ? 0 : 2,
                                              color: Color(0xFF1EC8CF),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 1,
                                    color: Color(0xFFE3E3E3),
                                  ),
                                  model.isPageOne
                                      ? Expanded(
                                          child: ListView(
                                            children: [
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                  '문의 작성 기능은 아직 구현 전이니까 나의 문의 탭부터 확인 고고')
                                            ],
                                          ),
                                        )
                                      : Expanded(
                                          child: ListView(
                                            children: oneOnOneList(model),
                                          ),
                                        ),
                                ],
                              )),
                        ));
        });
  }
}

List<Widget> oneOnOneList(OneOnOneViewModel model) {
  List<Widget> result = [];

  for (int i = 0; i < model.oneOnOneModel.length; i++) {
    result.add(GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        model.selectOneOnOneDetail(i);
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
                      color: model.oneOnOneModel[i].state
                          ? Color(0xFF1EC8CF)
                          : Colors.black,
                      borderRadius: BorderRadius.circular(
                        30,
                      )),
                  child: Center(
                    child: Text(
                      model.oneOnOneModel[i].state ? '완료' : '대기',
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
                    child: Text('${model.oneOnOneModel[i].questionTitle}',
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
                '${model.oneOnOneModel[i].questionContent}',
                style: TextStyle(
                    fontSize: 16,
                    letterSpacing: -0.28,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ))
        : result.add(Container());

    model.isSelected[i] && model.oneOnOneModel[i].state
        ? result.add(Container(
            color: Color(0xFF1EC8CF).withOpacity(0.3),
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
              child: Text(
                '${model.oneOnOneModel[i].answer}',
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
