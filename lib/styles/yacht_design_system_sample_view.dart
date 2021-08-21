import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

class YachtDesignSystemSampleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<FontWeight> _notoSansFontWeightList = [
      FontWeight.w200,
      FontWeight.w300,
      FontWeight.w400,
      FontWeight.w500,
      FontWeight.w700,
      FontWeight.w900,
    ];
    List<FontWeight> _appleSDFontWeightList = [
      FontWeight.w100,
      FontWeight.w200,
      FontWeight.w300,
      FontWeight.w400,
      FontWeight.w500,
      FontWeight.w600,
      FontWeight.w700,
      FontWeight.w800,
      FontWeight.w900,
    ];

    // SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: kSymmetricPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "Design System",
                style: headingStyleEN,
              ),
              Divider(),
              Text("디자인 시스템", style: headingStyle.copyWith(color: Colors.blue)),
              Divider(),
              verticalSpaceMedium,
              Text(
                "한글 폰트",
                style: headingStyle,
              ),
              verticalSpaceMedium,
              // _testingFonts(
              //     '노토산스고딕한글', 30, 'AppleSDGothicNeo', _appleSDFontWeightList),
              _testingFonts(
                  '노토산스고딕한글', 28, 'NotoSansKR', _notoSansFontWeightList),
              verticalSpaceMedium,
              Divider(),
              verticalSpaceMedium,
              Text(
                "글씨 스타일",
                style: headingStyle,
              ),
              verticalSpaceMedium,
              // Text("헤드 1"),
              // verticalSpaceSmall,

              // Text("헤드 2"),
              // verticalSpaceSmall,
              // Text("헤드 3"),
              verticalSpaceSmall,
              Text("메뉴 타이틀", style: titleStyle),
              verticalSpaceSmall,
              Text("서브 타이틀 ", style: subtitleStyle),
              verticalSpaceSmall,
              Text("컨텐트 스타일은 일반적인 본문 내용을 ", style: contentStyle),
              verticalSpaceSmall,
              Text("자세한 내용을 기술할 때 ", style: detailStyle),
              verticalSpaceSmall,
              verticalSpaceMedium,
              Divider(),
              verticalSpaceMedium,
              Text(
                "숫자 스타일",
                style: headingStyle,
              ),
              verticalSpaceMedium,
              Row(
                children: [
                  Text(
                    "￦54,750",
                    style: headingStyleEN,
                  ),
                  SizedBox(width: 16),
                  Text("시장 관련 숫자는 DmSans",
                      style: contentStyle.copyWith(fontFamily: 'DmSans')),
                ],
              ),
              verticalSpaceSmall,
              Text(
                "+1,750 (+7.1%)",
                style: detailPriceStyle.copyWith(color: bullColorKR),
              ),
              verticalSpaceSmall,
              Text(
                "-1,750 (-7.1%)",
                style: detailPriceStyle.copyWith(color: bearColorKR),
              ),
              verticalSpaceSmall,
              Padding(
                padding: kHorizontalPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("시가",
                                style: ohlcInfoStyle.copyWith(
                                    color: Colors.grey[600])),
                            Text("72,500", style: ohlcPriceStyle)
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("고가",
                                style: ohlcInfoStyle.copyWith(
                                    color: Colors.grey[600])),
                            Text("72,500", style: ohlcPriceStyle)
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("거래량",
                                style: ohlcInfoStyle.copyWith(
                                    color: Colors.grey[600])),
                            Text("72,500", style: ohlcPriceStyle)
                          ],
                        )
                      ],
                    )),
                    horizontalSpaceExtraLarge,
                    Expanded(
                        child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("종가",
                                style: ohlcInfoStyle.copyWith(
                                    color: Colors.grey[600])),
                            Text("72,500", style: ohlcPriceStyle)
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("저가",
                                style: ohlcInfoStyle.copyWith(
                                    color: Colors.grey[600])),
                            Text("72,500", style: ohlcPriceStyle)
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("변동",
                                style: ohlcInfoStyle.copyWith(
                                    color: Colors.grey[600])),
                            Text("-2.24%", style: ohlcPriceStyle)
                          ],
                        )
                      ],
                    ))
                  ],
                ),
              ),
              verticalSpaceMedium,
              Divider(),
              verticalSpaceMedium,
              Text(
                "버튼 스타일",
                style: headingStyle,
              ),
              verticalSpaceMedium,
              // verticalSpaceExtraLarge
              Text(
                "토글 버튼",
                style: subtitleStyle,
              ),
              verticalSpaceMedium,
              Row(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        color: toggleButtonColor,
                        borderRadius: BorderRadius.circular(70),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      child: Icon(
                        Icons.auto_graph,
                        size: 18,
                      )),
                  horizontalSpaceSmall,
                  Container(
                    decoration: BoxDecoration(
                      color: toggleButtonColor,
                      borderRadius: BorderRadius.circular(70),
                    ),
                    // color: Colors.blueGrey.shade100,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Text(
                      "1주일",
                      style: detailStyle,
                    ),
                  ),
                  horizontalSpaceSmall,
                  Container(
                    decoration: BoxDecoration(
                      // color: toggleButton,
                      borderRadius: BorderRadius.circular(70),
                    ),
                    // color: Colors.blueGrey.shade100,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Text(
                      "분기",
                      style: detailStyle,
                    ),
                  ),
                  horizontalSpaceSmall,
                  Container(
                    decoration: BoxDecoration(
                      color: toggleButtonColor,
                      borderRadius: BorderRadius.circular(70),
                    ),
                    // color: Colors.blueGrey.shade100,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Text(
                      "연간",
                      style: detailStyle,
                    ),
                  ),
                ],
              ),
              verticalSpaceMedium,
              Divider(),
              // Divider(),
              verticalSpaceMedium,
              Text(
                "컨테이너 스타일",
                style: headingStyle,
              ),
              verticalSpaceMedium,
              Text(
                "퀘스트 카드 선택 컨테이너",
                style: subtitleStyle,
              ),
              verticalSpaceMedium,
              Text(
                "종목 1개 상하",
                style: contentStyle,
              ),
              verticalSpaceSmall,
              QuestCard01(),
              verticalSpaceSmall,
              QuestCard02(),
              verticalSpaceMedium,
              Divider(),

              verticalSpaceMedium,
              Text(
                "다이얼로그 스타일",
                style: headingStyle,
              ),
              verticalSpaceMedium,
              Text(
                "퀘스트 최종 선택",
                style: contentStyle,
              ),
              Container(
                height: 500,
                color: Colors.grey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: dialogPadding,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        height: 200,
                        width: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            AutoSizeText(
                              "7/4 종목 상승 하락 대결",
                              maxLines: 2,
                              style: contentStyle,
                            ),
                            // verticalSpaceSmall,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/secLogo/hana.png',
                                  height: reactiveHeight(60),
                                  width: reactiveHeight(60),
                                ),
                                horizontalSpaceMedium,
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      "삼성바이오로직스",
                                      style: subtitleStyle,
                                    ),
                                    verticalSpaceExtraSmall,
                                    Text(
                                      "선택을 확정하시겠어요?",
                                      maxLines: 2,
                                      style: contentStyle,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        color: bullColorKR.withOpacity(.4),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "취소",
                                          style: subtitleStyle.copyWith(
                                              color:
                                                  Colors.white.withOpacity(.8)),
                                        ),
                                      )),
                                ),
                                horizontalSpaceMedium,
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        color: bullColorKR,
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(.1),
                                              offset: Offset(3, 3),
                                              blurRadius: 5,
                                              spreadRadius: 2)
                                        ]),
                                    child: Center(
                                      child: Text(
                                        "확인",
                                        style: subtitleStyle.copyWith(
                                            color:
                                                Colors.white.withOpacity(.9)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: dialogPadding,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        height: 250,
                        width: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            // Container(),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  AutoSizeText(
                                    "7/5 ~ 7/9 주간 수익률 킹 대결",
                                    maxLines: 2,
                                    style: contentStyle,
                                  ),
                                  Image.asset(
                                    'assets/images/secLogo/hana.png',
                                    height: reactiveHeight(60),
                                    width: reactiveHeight(60),
                                  ),
                                  // verticalSpaceSmall,
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "삼성바이오로직스",
                                        style: subtitleStyle,
                                      ),
                                      verticalSpaceExtraSmall,
                                      Text(
                                        "선택을 확정하시겠어요?",
                                        maxLines: 2,
                                        style: contentStyle,
                                      ),
                                      verticalSpaceMedium,
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        color: bullColorKR.withOpacity(.4),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "취소",
                                          style: subtitleStyle.copyWith(
                                              color:
                                                  Colors.white.withOpacity(.8)),
                                        ),
                                      )),
                                ),
                                horizontalSpaceMedium,
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        color: bullColorKR,
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(.1),
                                              offset: Offset(3, 3),
                                              blurRadius: 5,
                                              spreadRadius: 2)
                                        ]),
                                    child: Center(
                                      child: Text(
                                        "확인",
                                        style: subtitleStyle.copyWith(
                                            color:
                                                Colors.white.withOpacity(.9)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ]),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 240,
                    color: Colors.blueAccent,
                    // decoration: primaryBoxDecoration.copyWith(
                    //     color: Colors.blueAccent, boxShadow: [primaryBoxShadow]),
                    child: Center(
                        child: Text(
                      "test",
                      style: TextStyle(fontSize: 26),
                    )),
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: 100.w,
                    height: 240.h,
                    color: Colors.blueAccent,
                    // decoration: primaryBoxDecoration.copyWith(
                    //     color: Colors.blueAccent, boxShadow: [primaryBoxShadow]),
                    child: Center(
                        child: Text(
                      "test",
                      style: TextStyle(fontSize: 26.sp),
                    )),
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: reactiveWidth(100),
                    height: reactiveHeight(240),
                    color: Colors.blueAccent,
                    // decoration: primaryBoxDecoration.copyWith(
                    //     color: Colors.blueAccent, boxShadow: [primaryBoxShadow]),
                    child: Center(
                        child: Text(
                      "test",
                      style: TextStyle(fontSize: 26),
                    )),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                width: 100.w,
                height: 240.h,
                color: Colors.blueAccent,
                // decoration: primaryBoxDecoration.copyWith(
                //     color: Colors.blueAccent, boxShadow: [primaryBoxShadow]),
                child: Center(
                    child: Text(
                  "test",
                  style: TextStyle(fontSize: 26.sp),
                )),
              ),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _testingFonts(
    String text,
    double fontSize,
    String fontFamily,
    List<FontWeight> fontWeight,
  ) {
    return Column(
      children: List.generate(fontWeight.length, (index) {
        return Column(
          children: [
            Container(
              color: Colors.blueGrey[100],
              child: Text(
                text + ' w' + ((fontWeight[index].index + 1) * 100).toString(),
                style: TextStyle(
                  fontSize: fontSize,
                  fontFamily: fontFamily,
                  fontWeight: fontWeight[index],
                  wordSpacing: -1,
                  height: 1.1,
                ),
              ),
            ),
            SizedBox(height: 4)
            // Divider(),
          ],
        );
      }),
    );
  }
}

class QuestCard01 extends StatefulWidget {
  const QuestCard01({
    Key? key,
  }) : super(key: key);

  @override
  _QuestCard01State createState() => _QuestCard01State();
}

class _QuestCard01State extends State<QuestCard01> {
  double selectedOpaticy = 0.3;
  double unselectedOpacity = 0.1;
  bool upSelected = true;
  bool downSelected = true;
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFA8C6D2).withOpacity(.3),
          ),
          height: 140,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "7월 5일 삼성전자는?",
                style: subtitleStyle,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        upSelected = !upSelected;
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                          color: bullColorKR.withOpacity(
                              upSelected ? selectedOpaticy : unselectedOpacity),
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "상승",
                        style: subtitleStyle.copyWith(
                            color: upSelected ? bullColorKR : Colors.grey),
                      ),
                    ),
                  ),
                  horizontalSpaceExtraLarge,
                  InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        downSelected = !downSelected;
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                          color: bearColorKR.withOpacity(downSelected
                              ? selectedOpaticy
                              : unselectedOpacity),
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "하락",
                        style: subtitleStyle.copyWith(
                            color: downSelected ? bearColorKR : Colors.grey),
                        // style: subtitleStyle.copyWith(
                        //   color: bearColorKR,
                        // ),
                      ),
                    ),
                  ),
                ],
              ),
              InkWell(
                  onTap: () {
                    HapticFeedback.heavyImpact();
                  },
                  child: Text(
                    "예측 완료하기",
                    style: subtitleStyle.copyWith(
                        color: (upSelected || downSelected)
                            ? contentStyle.color
                            : Colors.grey),
                  )),
            ],
          ),
          // color: Colors.blue,
        ),
      ),
    );
  }
}

class QuestCard02 extends StatefulWidget {
  const QuestCard02({
    Key? key,
  }) : super(key: key);

  @override
  _QuestCard02State createState() => _QuestCard02State();
}

class _QuestCard02State extends State<QuestCard02> {
  double selectedOpaticy = 0.3;
  double unselectedOpacity = 0.1;
  bool upSelected = true;
  bool downSelected = true;
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFF1E2017).withOpacity(.9),
          ),
          height: 140,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "7월 5일 삼성전자는?".toString(),
                style: subtitleStyle.copyWith(color: Color(0xFFE5E5E4)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        upSelected = !upSelected;
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                          color: Color(0xFFE2C2C6)
                              .withOpacity(upSelected ? 1.0 : .2),
                          // bullColorKR.withOpacity(
                          //     upSelected ? selectedOpaticy : unselectedOpacity),
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "상승",
                        style: subtitleStyle.copyWith(
                            color: upSelected ? bullColorKR : Colors.grey),
                      ),
                    ),
                  ),
                  horizontalSpaceExtraLarge,
                  InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        downSelected = !downSelected;
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                          color: Color(0xFF98C4D9)
                              .withOpacity(downSelected ? 1.0 : .2),
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "하락",
                        style: subtitleStyle.copyWith(
                            color: downSelected ? bearColorKR : Colors.grey),
                        // style: subtitleStyle.copyWith(
                        //   color: bearColorKR,
                        // ),
                      ),
                    ),
                  ),
                ],
              ),
              InkWell(
                  onTap: () {
                    HapticFeedback.heavyImpact();
                  },
                  child: Text(
                    "예측 완료하기",
                    style: subtitleStyle.copyWith(
                      color: (upSelected || downSelected)
                          ? Colors.white
                          : Color(0xFF1E2017),
                    ),
                  )),
            ],
          ),
          // color: Colors.blue,
        ),
      ),
    );
  }
}
