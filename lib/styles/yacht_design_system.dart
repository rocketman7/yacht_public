import 'package:flutter/material.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/style_constants.dart';

class YachtDesignSystem extends StatelessWidget {
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

    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        body: ListView(
          padding: kSymmetricPadding,
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
                Text("종목 정보에 메인 가격", style: contentStyle),
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
                  SizedBox(width: 36),
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
            SizedBox(
              height: 100,
            )
          ],
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
