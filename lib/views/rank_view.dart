import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stacked/stacked.dart';

import '../models/rank_model.dart';
import '../view_models/rank_view_model.dart';
import '../views/constants/size.dart';
import '../views/loading_view.dart';

class RankView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // display setting
    Size size = MediaQuery.of(context).size;
    double displayRatio = size.height / size.width;

    return ViewModelBuilder<RankViewModel>.reactive(
        viewModelBuilder: () => RankViewModel(),
        builder: (context, model, child) {
          return Scaffold(
              body: model.hasError
                  ? Container(
                      child: Text('error발생. 뒤로가기 버튼을 눌러 페이지를 벗어나신 후 다시 시도하세요.'),
                    )
                  : model.isBusy
                      ? LoadingView()
                      : SafeArea(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    displayRatio > 1.85 ? gap_l : gap_xs),
                            child: Column(
                              children: [
                                // topBar(model.user),
                                SizedBox(
                                  height: displayRatio > 1.85 ? gap_l : gap_xs,
                                ),
                                Text(
                                    '추가 구현해야할 부분\n1. 내 순위 어떻게 보여줄지\n2. 공동순위 어떻게 처리할지'),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: model.rankModel.length,
                                    itemBuilder: (context, index) =>
                                        makesRankListView(
                                            model.rankModel[index],
                                            index,
                                            model.uid),
                                  ),
                                ),
                                RaisedButton(
                                  onPressed: () {
                                    // model.addRank();
                                  },
                                  child: Text('rank DB 추가(비활성화)'),
                                ),
                                Container(
                                  height: 30,
                                  color: Colors.grey,
                                  child: Text(
                                      '나중에 bottom navigation bar 등 들어올 영역'),
                                )
                              ],
                            ),
                          ),
                        ));
        });
  }

  makesRankListView(RankModel ranksModel, int index, String uid) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ranksModel.uid == uid
          ? Text(
              '${index + 1}등 : ${ranksModel.uid}/${ranksModel.userName}, combo:${ranksModel.combo}',
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          : Text(
              '${index + 1}등 : ${ranksModel.uid}/${ranksModel.userName}, combo:${ranksModel.combo}'),
    );
  }
}
