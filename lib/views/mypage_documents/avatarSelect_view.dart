import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../view_models/avatarSelect_viewmodel.dart';

class MypageAvatarSelectView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MypageAvatarSelectViewModel>.reactive(
      viewModelBuilder: () => MypageAvatarSelectViewModel(),
      builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: Text('My Page:Avatar Select'),
          ),
          body: model.hasError
              ? Container(
                  child: Text('error발생. 뒤로가기 버튼을 눌러 페이지를 벗어나신 후 다시 시도하세요.'),
                )
              : Center(
                  child: model.isBusy
                      ? CircularProgressIndicator()
                      : Column(
                          children: [
                            Container(
                              height: 400,
                              child: ListView.builder(
                                itemCount: model.avatarNum,
                                itemBuilder: (context, index) =>
                                    makesAvatarListView(model, index),
                              ),
                            ),
                            RaisedButton(
                              onPressed: () {
                                model.emptyCacheAll();
                              },
                              child: Text('clear cache'),
                            ),
                          ],
                        ))),
    );
  }

  makesAvatarListView(MypageAvatarSelectViewModel model, int index) {
    return Container(
        child: model.paintChachedNetworkImage(index, width: 50, height: 50));
  }
}
