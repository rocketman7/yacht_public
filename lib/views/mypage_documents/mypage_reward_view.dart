import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yachtOne/services/navigation_service.dart';

import '../../locator.dart';
import '../../view_models/mypage_reward_view_model.dart';

class MypageRewardView extends StatelessWidget {
  final NavigationService _navigationService = locator<NavigationService>();
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MypageRewardViewModel>.reactive(
      viewModelBuilder: () => MypageRewardViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              '내가 받은 상금 현황',
              style: TextStyle(fontSize: 20, fontFamily: 'AppleSDB'),
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
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 16, bottom: 16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: model.initTab ? null : model.moveTab,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                      width: 3,
                                      color: model.initTab
                                          ? Color(0xFF1EC8CF)
                                          : Colors.transparent,
                                    ))),
                                    child: Text('보유 중인 주식',
                                        style: TextStyle(
                                            color: model.initTab
                                                ? Colors.black
                                                : Colors.grey,
                                            fontSize: 24,
                                            fontFamily: 'AppleSDB')),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: model.initTab ? model.moveTab : null,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                      width: 3,
                                      color: model.initTab
                                          ? Colors.transparent
                                          : Color(0xFF1EC8CF),
                                    ))),
                                    child: Text('출고 완료한 주식',
                                        style: TextStyle(
                                            color: model.initTab
                                                ? Colors.grey
                                                : Colors.black,
                                            fontSize: 24,
                                            fontFamily: 'AppleSDB')),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: ListView(
                                    children: model.initTab
                                        ? makeUserRewardListBeforeDelivery(
                                            context, model)
                                        : makeUserRewardListAfterDelivery(
                                            model)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
        );
      },
    );
  }

  // 보유 중인 상금 List를 만드는
  List<Widget> makeUserRewardListBeforeDelivery(
      BuildContext context, MypageRewardViewModel model) {
    List<Widget> result = [];

    if (model.userRewardBeforeDeliveryCnt == 0) {
      result.add(Text(
        '보유 중인 주식이 없습니다.',
        style: TextStyle(fontSize: 16, fontFamily: 'AppleSDM'),
      ));
      return result;
    } else {
      for (int i = 0; i < model.userRewardModels.length; i++) {
        result.add(makeUserRewardListBeforeDeliveryItem(context, model, i));
      }
    }

    return result;
  }

  // 보유 중인 상금 List의 개별항목들을 만드는
  Widget makeUserRewardListBeforeDeliveryItem(
      BuildContext context, MypageRewardViewModel model, int index) {
    return (model.userRewardModels[index].deliveryStatus != -1)
        ? Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${model.userRewardModels[index].rewardTitle}',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'AppleSDM',
                              fontWeight: FontWeight.bold)),
                      Text(
                        '${model.dateFormChange(model.userRewardModels[index].awardDate)}',
                        style: TextStyle(
                            fontFamily: 'AppleSDL',
                            fontSize: 12,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      print("tax needed? " +
                          model.userRewardModels[index].isTax.toString());
                      (model.userRewardModels[index].deliveryStatus == 0)
                          ? showDeliveryDialogforLoad(context, model)
                          : (model.userModel.accNumber == null)
                              ? showDeliveryDialogforNotVerif(context, model)
                              : model.userRewardModels[index].isTax
                                  ? showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        String title = "주민등록번호 인증이 필요합니다.";
                                        String content =
                                            "주민등록번호 인증이 왜 필요한가요?\n\n상금으로 지급되는 주식은 사용자에게 기타소득이 됩니다. 1회의 기타소득 가치가 5만원이 넘을 경우, 기타소득 지급자인 주식회사 팀요트는 원천징수 의무자로서 기타소득 지급명세서 제출을 위해 사용자의 주민등록번호를 수집할 수 있습니다 (관련 법령 하단 참조). \n당사는 수집한 주민등록번호를 오직 기타소득 원천징수 지급명세서 작성 용도로만 활용한 후 즉시 폐기합니다.\n\n*관련 법령\n1) 소득세법 제145조(기타소득에 대한 원천징수 시기와 방법 및 원천징수영수증의 발급) ① 원천징수의무자가 기타소득을 지급할 때에는 그 기타소득금액에 원천징수세율을 적용하여 계산한 소득세를 원천징수한다. \n2) 제164조(지급명세서의 제출) ① 제2조에 따라 소득세 납세의무가 있는 개인에게 다음 각 호의 어느 하나에 해당하는 소득을 국내에서 지급하는 자는 대통령령으로 정하는 바에 따라 지급명세서를 그 지급일이 속하는 과세기간의 다음 연도 2월 말일까지 원천징수 관할 세무서장, 지방국세청장 또는 국세청장에게 제출하여야 한다.";
                                        String goCheckName = "인증하러 가기";
                                        String checkNameUrl =
                                            model.checkNameUrl + model.uid;
                                        return MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: AlertDialog(
                                            title: Text(title),
                                            content: SingleChildScrollView(
                                                child: Text(content)),
                                            actions: [
                                              FlatButton(
                                                child: Text("닫기"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              FlatButton(
                                                child: Text(goCheckName),
                                                onPressed: () {
                                                  Navigator.of(context).pop();

                                                  _launchURL(checkNameUrl);
                                                  // _navigationService
                                                  //     .navigateTo('portfolio');
                                                },
                                              )
                                            ],
                                          ),
                                        );
                                      })
                                  : showDeliveryDialog(context, model, index);
                    },
                    child: Row(
                      children: [
                        (model.userRewardModels[index].deliveryStatus == 1)
                            ? Text('출고하기',
                                style: TextStyle(
                                    fontSize: 16, fontFamily: 'AppleSDM'))
                            : Text('출고 대기중',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'AppleSDM',
                                    color: Color(0xFFFF402B))),
                        (model.userRewardModels[index].deliveryStatus == 1)
                            ? Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
              FutureBuilder(
                future: model.getHistoricalPrices(index),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data);
                    return Column(
                      children: makeUserRewardListBeforeDeliveryItemForEach(
                          model, index, snapshot.data),
                    );
                  } else {
                    return Column(
                      children: makeUserRewardListBeforeDeliveryItemForEach(
                          model, index, null),
                    );
                  }
                },
              ),
              SizedBox(
                height: 16,
              ),
              StreamBuilder<String>(
                  stream: model.getNameCheckResult(model.uid),
                  builder: (context, snapshot) {
                    print("reward index" + index.toString());
                    if (!snapshot.hasData) {
                      print("nodata");
                      return Container();
                    } else {
                      print("GETNAME SNAPSHOT" + snapshot.data.toString());
                      if (snapshot.data == "1") {
                        model.userRewardModels[index].isTax = false;
                        model.notifyListeners();
                      }
                      return Container();
                    }
                  }),
            ],
          )
        : Container();
  }

  // 보유 중인 상금 List에서 개별 주식들의 List를 만드는
  List<Widget> makeUserRewardListBeforeDeliveryItemForEach(
      MypageRewardViewModel model, int index, List<double> histPrices) {
    List<Widget> result = [];

    if (histPrices != null) {
      for (int i = 0;
          i < model.userRewardModels[index].listOfAward.length;
          i++) {
        print("STOCKNAME" +
            model.userRewardModels[index].listOfAward[i].stockName.toString());
        result.add(Column(
          children: [
            SizedBox(
              height: 8,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${model.userRewardModels[index].listOfAward[i].stockName}',
                        style: TextStyle(fontSize: 20, fontFamily: 'AppleSDM')),
                    Text(
                        '${model.userRewardModels[index].listOfAward[i].sharesNum}주',
                        style: TextStyle(fontSize: 18, fontFamily: 'AppleSDM')),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${model.priceFormChange(histPrices[i])}',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'AppleSDM',
                            fontWeight: FontWeight.bold,
                            color: model.judgeUporDown(histPrices[i], index, i)
                                ? Color(0xFFFF402B)
                                : Color(0xFF3150F4))),
                    Text('${model.calcReturn(histPrices[i], index, i)}',
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'AppleSDM',
                            color: model.judgeUporDown(histPrices[i], index, i)
                                ? Color(0xFFFF402B)
                                : Color(0xFF3150F4))),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              height: 1,
              color: Color(0xFFE3E3E3),
            ),
          ],
        ));
      }

      result.add(
        Container(
            height: 32,
            width: double.infinity,
            color: Color(0xFF1EC8CF).withOpacity(0.5),
            child: Center(
              child: Text(
                  '총액 ' +
                      model.priceFormChange(
                          model.calcTotalValueForHistPrice(index, histPrices)),
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'AppleSDM',
                  )),
            )),
      );
    } else {
      result.add(Container());
    }

    return result;
  }

  Future showDeliveryDialogforLoad(
      BuildContext context, MypageRewardViewModel model) {
    return showDialog(
      context: context,
      builder: (context) {
        if (Platform.isIOS) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: CupertinoAlertDialog(
              content: Text('이미 출고를 신청하셨습니다!\n출고에는 최대 2영업일이 소요될 수 있습니다.',
                  style: TextStyle(fontSize: 16, fontFamily: 'AppleSDM')),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('확인'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        } else {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: AlertDialog(
              content: Text('이미 출고를 신청하셨습니다!\n출고에는 최대 2영업일이 소요될 수 있습니다.',
                  style: TextStyle(fontSize: 16, fontFamily: 'AppleSDM')),
              actions: <Widget>[
                FlatButton(
                  child: Text('확인'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Future showDeliveryDialogforNotVerif(
      BuildContext context, MypageRewardViewModel model) {
    return showDialog(
      context: context,
      builder: (context) {
        if (Platform.isIOS) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: CupertinoAlertDialog(
              content: Text('아직 증권계좌를 인증하지 않으셨습니다. 증권계좌 인증 페이지로 이동할까요?',
                  style: TextStyle(fontSize: 16, fontFamily: 'AppleSDM')),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('아뇨'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                    child: Text('네'),
                    onPressed: () {
                      Navigator.pop(context);
                      model.navigateToAccountVerifView();
                    })
              ],
            ),
          );
        } else {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: AlertDialog(
              content: Text('아직 증권계좌를 인증하지 않으셨습니다. 증권계좌 인증 페이지로 이동할까요?',
                  style: TextStyle(fontSize: 16, fontFamily: 'AppleSDM')),
              actions: <Widget>[
                FlatButton(
                  child: Text('아뇨'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                    child: Text('네'),
                    onPressed: () {
                      Navigator.pop(context);
                      model.navigateToAccountVerifView();
                    })
              ],
            ),
          );
        }
      },
    );
  }

  Future showDeliveryDialog(
      BuildContext context, MypageRewardViewModel model, int deliveryIndex) {
    return showDialog(
      context: context,
      builder: (context) {
        if (Platform.isIOS) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: CupertinoAlertDialog(
              content: Column(
                children: [
                  Text('다음과 같이 출고신청하시겠습니까?\n\n',
                      style: TextStyle(fontSize: 16, fontFamily: 'AppleSDM')),
                  Text('-출고할 계좌-',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontFamily: 'AppleSDM')),
                  Text(
                      '${model.userModel.secName}\n${model.userModel.accName}\n${model.userModel.accNumber}\n\n',
                      style: TextStyle(fontSize: 16, fontFamily: 'AppleSDM')),
                  Text('-출고할 주식-',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontFamily: 'AppleSDM')),
                  Text('${model.deliveryStocksForDialog(deliveryIndex)}',
                      style: TextStyle(fontSize: 16, fontFamily: 'AppleSDM')),
                ],
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('아뇨'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                    child: Text('네'),
                    onPressed: () async {
                      await model.actDelivery(deliveryIndex);
                      Navigator.pop(context);
                    })
              ],
            ),
          );
        } else {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('다음과 같이 출고신청하시겠습니까?\n\n',
                      style: TextStyle(fontSize: 16, fontFamily: 'AppleSDM')),
                  Text('-출고할 계좌-',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontFamily: 'AppleSDM')),
                  Text(
                      '${model.userModel.secName}\n${model.userModel.accName}\n${model.userModel.accNumber}\n\n',
                      style: TextStyle(fontSize: 16, fontFamily: 'AppleSDM')),
                  Text('-출고할 주식-',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontFamily: 'AppleSDM')),
                  Text('${model.deliveryStocksForDialog(deliveryIndex)}',
                      style: TextStyle(fontSize: 16, fontFamily: 'AppleSDM')),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('아뇨'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                    child: Text('네'),
                    onPressed: () async {
                      await model.actDelivery(deliveryIndex);
                      Navigator.pop(context);
                    })
              ],
            ),
          );
        }
      },
    );
  }

  // 출고 완료한 상금 List를 만드는
  List<Widget> makeUserRewardListAfterDelivery(MypageRewardViewModel model) {
    List<Widget> result = [];

    if (model.userRewardAfterDeliveryCnt == 0) {
      result.add(Text(
        '출고한 주식이 없습니다.',
        style: TextStyle(fontSize: 16, fontFamily: 'AppleSDM'),
      ));
      return result;
    } else {
      for (int i = 0; i < model.userRewardModels.length; i++) {
        result.add(makeUserRewardListAfterDeliveryItem(model, i));
      }
    }

    return result;
  }

  // 출고 완료한인 상금 List의 개별항목들을 만드는
  Widget makeUserRewardListAfterDeliveryItem(
      MypageRewardViewModel model, int index) {
    return (model.userRewardModels[index].deliveryStatus != -1)
        ? Container()
        : Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${model.userRewardModels[index].rewardTitle}',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'AppleSDM',
                              fontWeight: FontWeight.bold)),
                      Text(
                        '${model.dateFormChange(model.userRewardModels[index].awardDate)}',
                        style: TextStyle(
                            fontFamily: 'AppleSDL',
                            fontSize: 12,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                  Spacer(),
                ],
              ),
              Column(
                children:
                    makeUserRewardListAfterDeliveryItemForEach(model, index),
              ),
              Container(
                  height: 36,
                  width: double.infinity,
                  color: Color(0xFF1EC8CF).withOpacity(0.5),
                  child: Center(
                      child: Row(
                    children: [
                      Spacer(),
                      Text(
                          '총액 ' +
                              model
                                  .priceFormChange(model.calcTotalValue(index)),
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'AppleSDM',
                          )),
                      Text('(출고 시점 기준)',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'AppleSDL',
                          )),
                      Spacer(),
                    ],
                  ))),
              SizedBox(
                height: 16,
              )
            ],
          );
  }

  // 출고 완료한 상금 List에서 개별 주식들의 List를 만드는
  List<Widget> makeUserRewardListAfterDeliveryItemForEach(
      MypageRewardViewModel model, int index) {
    List<Widget> result = [];

    for (int i = 0; i < model.userRewardModels[index].listOfAward.length; i++) {
      result.add(Column(
        children: [
          SizedBox(
            height: 8,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${model.userRewardModels[index].listOfAward[i].stockName}',
                      style: TextStyle(fontSize: 20, fontFamily: 'AppleSDM')),
                  Text(
                      '${model.userRewardModels[index].listOfAward[i].sharesNum}주',
                      style: TextStyle(fontSize: 18, fontFamily: 'AppleSDM')),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('출고완료',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'AppleSDM',
                          fontWeight: FontWeight.bold)),
                  Text('+0.00%',
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'AppleSDM',
                          color: Colors.transparent)),
                ],
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            height: 1,
            color: Color(0xFFE3E3E3),
          ),
        ],
      ));
    }

    return result;
  }
}
