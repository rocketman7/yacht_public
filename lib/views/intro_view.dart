import 'dart:math';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'constants/size.dart';

class IntroView extends StatefulWidget {
  @override
  _IntroViewState createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> with TickerProviderStateMixin {
  // 애니메이션 컨트롤러, 애니메이션 선언
  AnimationController _firstAnimationController;
  Animation _firstAnimation;

  AnimationController _secondAnimationController;
  Animation _secondAnimation;

  AnimationController _thirdAnimationController;
  Animation _thirdAnimation;

  AnimationController _fourthAnimationController;
  Animation _fourthAnimation;

  double firstWidth = 1;

  @override
  void initState() {
    super.initState();
    _firstAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Tween은 _animation의 두 사이 값을 지정
    _firstAnimation = Tween<double>(begin: 1.0, end: 2.0).animate(
      CurvedAnimation(
        curve: Curves.easeIn,
        parent: _firstAnimationController,
      ),
    );

    _firstAnimationController.repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    _firstAnimationController.addListener(() {
      setState(() {
        firstWidth = _firstAnimation.value;
      });
    });
  }

  @override
  void dispose() {
    _firstAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    deviceHeight = size.height;
    deviceWidth = size.width;
    double containerHeight = deviceHeight * .09;
    double sizedBoxHeight = deviceHeight * .018;
    TextStyle titleStyleWhite = TextStyle(
      fontSize: 26.sp,
      fontFamily: 'AppleSDB',
      color: Colors.white,
      // height: 1,
    );
    TextStyle titleStyleBlack = TextStyle(
      fontSize: 26.sp,
      fontFamily: 'AppleSDB',
      color: Colors.black,
      // height: 1,
    );
    return Scaffold(
        backgroundColor: Color(0xFFF7F6F7),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(8, 32, 8, 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // SizedBox(height: 40),
                SvgPicture.asset(
                  'assets/images/logo_ggook_letter.svg',
                  width: 110,
                  height: 110,
                ),
                SizedBox(height: 20),
                SvgPicture.asset(
                  'assets/images/logo_description.svg',
                  width: 110,
                  // height: 110,
                ),
                SizedBox(height: 40),
                // Row(
                //   children: <Widget>[
                //     Container(
                //       width: 20 + firstWidth * 100,
                //       height: containerHeight,
                //       decoration: BoxDecoration(
                //           border: Border.all(
                //             width: 4.0,
                //             color: Color(0xFF1EC8CF),
                //           ),
                //           borderRadius: BorderRadius.circular(
                //             40,
                //           )),
                //     ),
                //     SizedBox(width: 8),
                //     Expanded(
                //       flex: 1,
                //       child: Container(
                //         // width: 50,
                //         height: containerHeight,
                //         decoration: BoxDecoration(
                //             border: Border.all(
                //               width: 4.0,
                //               color: Color(0xFF2E57BA),
                //             ),
                //             borderRadius: BorderRadius.circular(
                //               40,
                //             )),
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(height: sizedBoxHeight),
                // Row(
                //   children: <Widget>[
                //     Container(
                //       width: 200 - firstWidth * 25,
                //       height: containerHeight,
                //       decoration: BoxDecoration(
                //           border: Border.all(
                //             width: 4.0,
                //             color: Color(0xFFCD859C),
                //           ),
                //           borderRadius: BorderRadius.circular(
                //             40,
                //           )),
                //     ),
                //     SizedBox(width: 15),
                //     Expanded(
                //       flex: 1,
                //       child: Container(
                //         // width: 50,
                //         height: containerHeight,
                //         decoration: BoxDecoration(
                //             border: Border.all(
                //               width: 4.0,
                //               color: Color(0xFF427D6A),
                //             ),
                //             borderRadius: BorderRadius.circular(
                //               40,
                //             )),
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(height: sizedBoxHeight),
                // Row(
                //   children: <Widget>[
                //     Container(
                //       alignment: Alignment.centerLeft,
                //       padding: EdgeInsets.symmetric(
                //         horizontal: 22,
                //       ),
                //       width: 165,
                //       height: containerHeight,
                //       decoration: BoxDecoration(
                //         color: Color(0xFFFFD601),
                //         borderRadius: BorderRadius.circular(
                //           40,
                //         ),
                //       ),
                //       child: Text(
                //         "주식예측",
                //         style: titleStyleWhite,
                //       ),
                //     ),
                //     SizedBox(width: 12),
                //     Expanded(
                //       flex: 1,
                //       child: Container(
                //         // width: 50,
                //         height: containerHeight,
                //         decoration: BoxDecoration(
                //             border: Border.all(
                //               width: 4.0,
                //               color: Color(0xFFD17F2C),
                //             ),
                //             borderRadius: BorderRadius.circular(
                //               40,
                //             )),
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(height: sizedBoxHeight),
                // Row(
                //   children: <Widget>[
                //     Container(
                //       alignment: Alignment.centerLeft,
                //       padding: EdgeInsets.symmetric(
                //         horizontal: 22,
                //       ),
                //       width: 230,
                //       height: containerHeight,
                //       decoration: BoxDecoration(
                //         color: Color(0xFF2E57B9),
                //         borderRadius: BorderRadius.circular(
                //           40,
                //         ),
                //       ),
                //       child: Text(
                //         "퀴즈앱",
                //         style: titleStyleWhite,
                //       ),
                //     ),
                //     SizedBox(width: 12),
                //     Expanded(
                //       flex: 1,
                //       child: Container(
                //         // width: 50,
                //         height: containerHeight,
                //         decoration: BoxDecoration(
                //             border: Border.all(
                //               width: 4.0,
                //               color: Color(0xFFD17F2C),
                //             ),
                //             borderRadius: BorderRadius.circular(
                //               40,
                //             )),
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(height: sizedBoxHeight),
                // Row(
                //   children: <Widget>[
                //     Expanded(
                //       child: Container(
                //         alignment: Alignment.centerLeft,
                //         padding: EdgeInsets.symmetric(
                //           horizontal: 22,
                //         ),
                //         // width: 230,
                //         height: containerHeight,
                //         decoration: BoxDecoration(
                //           color: Color(0xFF1EC8CF),
                //           borderRadius: BorderRadius.circular(
                //             40,
                //           ),
                //         ),
                //         child: Text(
                //           "꾸욱",
                //           style: titleStyleBlack,
                //         ),
                //       ),
                //     ),
                //     SizedBox(width: 12),
                //     Container(
                //         width: containerHeight,
                //         height: containerHeight,
                //         padding: EdgeInsets.all(10),
                //         decoration: BoxDecoration(
                //             border: Border.all(
                //               width: 4.0,
                //               color: Color(0xFFB063E2),
                //             ),
                //             borderRadius: BorderRadius.circular(
                //               40,
                //             )),
                //         child: SvgPicture.asset(
                //           'assets/icons/dog_foot.svg',
                //         )),
                //   ],
                // ),
                // SizedBox(height: sizedBoxHeight),
                // Row(
                //   children: <Widget>[
                //     Container(
                //       width: 20 + firstWidth * 100,
                //       height: containerHeight,
                //       decoration: BoxDecoration(
                //           border: Border.all(
                //             width: 4.0,
                //             color: Color(0xFFCD859C),
                //           ),
                //           borderRadius: BorderRadius.circular(
                //             40,
                //           )),
                //     ),
                //     SizedBox(width: 8),
                //     Container(
                //       width: containerHeight,
                //       height: containerHeight,
                //       padding: EdgeInsets.all(10),
                //       decoration: BoxDecoration(
                //           border: Border.all(
                //             width: 4.0,
                //             color: Color(0xFF2E57B9),
                //           ),
                //           borderRadius: BorderRadius.circular(
                //             40,
                //           )),
                //       child: SvgPicture.asset(
                //         'assets/icons/dog_foot.svg',
                //         color: Color(0xFF2E57B9),
                //       ),
                //     ),
                //     SizedBox(width: 8),
                //     Expanded(
                //       flex: 1,
                //       child: Container(
                //         // width: 50,
                //         height: containerHeight,
                //         decoration: BoxDecoration(
                //             border: Border.all(
                //               width: 4.0,
                //               color: Color(0xFF427D6A),
                //             ),
                //             borderRadius: BorderRadius.circular(
                //               40,
                //             )),
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(height: sizedBoxHeight),
                // Row(
                //   children: <Widget>[
                //     Container(
                //       width: firstWidth * 85,
                //       height: containerHeight,
                //       decoration: BoxDecoration(
                //           border: Border.all(
                //             width: 4.0,
                //             color: Color(0xFF427D6A),
                //           ),
                //           borderRadius: BorderRadius.circular(
                //             40,
                //           )),
                //     ),
                //     SizedBox(width: 15),
                //     Expanded(
                //       flex: 1,
                //       child: Container(
                //         // width: 50,
                //         height: containerHeight,
                //         decoration: BoxDecoration(
                //             border: Border.all(
                //               width: 4.0,
                //               color: Color(0xFFD17F2C),
                //             ),
                //             borderRadius: BorderRadius.circular(
                //               40,
                //             )),
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(height: sizedBoxHeight),
                // Row(
                //   children: <Widget>[
                //     Container(
                //       width: 300 - firstWidth * 70,
                //       height: containerHeight,
                //       decoration: BoxDecoration(
                //           border: Border.all(
                //             width: 4.0,
                //             color: Color(0xFFB467E1),
                //           ),
                //           borderRadius: BorderRadius.circular(
                //             40,
                //           )),
                //     ),
                //     SizedBox(width: 15),
                //     Expanded(
                //       flex: 1,
                //       child: Container(
                //         // width: 50,
                //         height: containerHeight,
                //         decoration: BoxDecoration(
                //             border: Border.all(
                //               width: 4.0,
                //               color: Color(0xFF1EC8CF),
                //             ),
                //             borderRadius: BorderRadius.circular(
                //               40,
                //             )),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ));
  }
}
