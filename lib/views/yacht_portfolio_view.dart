import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:yachtOne/views/constants/size.dart';

import 'dart:math' as math;

class YachtPortfolioView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Container(
        color: Colors.grey,
        child: Text('dd'),
      )),
    );
  }
}

// class YachtPortfolioView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//           child: Column(
//         children: [
//           // Container(
//           //   height: 100,
//           //   width: 100,
//           // ),
//           // Container(height: 100, width: 100, color: Colors.red),
//           // Stack(
//           //   children: [
//           //     GestureDetector(
//           //       onTap: () {
//           //         print('dd1');
//           //       },
//           //       child: CustomPaint(
//           //           size: Size(100, 100),
//           //           painter: YachtPortfolioArcChart('4F77F7', 0.0, 60.0)),
//           //     ),
//           //     /*GestureDetector(
//           //       onTap: () {
//           //         print('dd2');
//           //       },
//           //       child: CustomPaint(
//           //           size: Size(100, 100),
//           //           painter: YachtPortfolioArcChart('5399E0', 60.0, 85.0)),
//           //     ),
//           //     GestureDetector(
//           //       onTap: () {
//           //         print('dd3');
//           //       },
//           //       child: CustomPaint(
//           //           size: Size(100, 100),
//           //           painter: YachtPortfolioArcChart('48BADD', 85.0, 94.0)),
//           //     ),
//           //     GestureDetector(
//           //       onTap: () {
//           //         print('dd4');
//           //       },
//           //       child: CustomPaint(
//           //           size: Size(100, 100),
//           //           painter: YachtPortfolioArcChart('4CEDE9', 94.0, 99.0)),
//           //     ),*/
//           //   ],
//           // ),
//           Stack(
//             children: [
//               CustomPaint(
//                   size: Size(300, 300),
//                   painter: YachtPortfolioArcChart('4F77F7', 50.0, 65.0)),
//               // CustomPaint(
//               //     size: Size(300, 300),
//               //     painter: YachtPortfolioArcChart('5399E0', 55.0, 60.0)),
//               Positioned(
//                 left: 300 / 2 +
//                     300 /
//                         2 *
//                         0.75 *
//                         math.cos(2 * math.pi * ((50.0 + 65.0) / 2 / 100)),
//                 top: 300 / 2 +
//                     300 /
//                         2 *
//                         0.75 *
//                         math.sin(2 * math.pi * ((50.0 + 65.0) / 2 / 100)),
//                 child: Container(
//                   width: 11 * 12.0 * 0.9 + 6,
//                   height: 22.0 + 12.0 + 6.0 + 9.0,
//                   color: Colors.grey,
//                   child: Column(
//                     children: [
//                       Text(
//                         '46%',
//                         style: TextStyle(
//                             fontSize: 22.0, fontWeight: FontWeight.bold),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 3,
//                           horizontal: 3,
//                         ),
//                         decoration: BoxDecoration(
//                             color: Color(0xFF4F77F7).withOpacity(0.8),
//                             borderRadius: BorderRadius.circular(
//                               5.0,
//                             )),
//                         child: Text(
//                           '한국타이어앤테크놀로지',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               // Positioned(
//               //   left: 300 / 2 +
//               //       300 /
//               //           2 *
//               //           0.75 *
//               //           math.cos(2 * math.pi * ((50.0 + 55.0) / 2 / 100)) -
//               //       11,
//               //   top: 300 / 2 +
//               //       300 /
//               //           2 *
//               //           0.75 *
//               //           math.sin(2 * math.pi * ((50.0 + 55.0) / 2 / 100)) -
//               //       11 / 2 -
//               //       6 -
//               //       8,
//               //   child:
//               //       // Container(
//               //       //   color: Colors.black,
//               //       //   height: 4,
//               //       //   width: 4,
//               //       // ),
//               //       Text(
//               //     '46%',
//               //     style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
//               //   ),
//               // ),
//               // Positioned(
//               //   left: 300 / 2 +
//               //       300 /
//               //           2 *
//               //           0.75 *
//               //           math.cos(2 * math.pi * ((50.0 + 55.0) / 2 / 100)) -
//               //       12 * 0.9 * 11 / 2 +
//               //       17,
//               //   top: 300 / 2 +
//               //       300 /
//               //           2 *
//               //           0.75 *
//               //           math.sin(2 * math.pi * ((50.0 + 55.0) / 2 / 100)) +
//               //       11 / 2,
//               //   child: Container(
//               //     padding: const EdgeInsets.symmetric(
//               //       vertical: 4,
//               //       horizontal: 4,
//               //     ),
//               //     decoration: BoxDecoration(
//               //         color: Color(0xFF4F77F7).withOpacity(0.8),
//               //         borderRadius: BorderRadius.circular(
//               //           5.0,
//               //         )),
//               //     child: Text(
//               //       '한국타이어앤테크놀로지',
//               //       style: TextStyle(
//               //         color: Colors.black,
//               //         fontSize: 12,
//               //       ),
//               //     ),
//               //   ),
//               // ),
//             ],
//           ),
//         ],
//       )),
//     );
//   }
// }

class YachtPortfolioArcChart extends CustomPainter {
  String color;
  double percentage1;
  double percentage2;

  YachtPortfolioArcChart(this.color, this.percentage1, this.percentage2);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(int.parse('FF$color', radix: 16))
      ..style = PaintingStyle.fill;

    double radius = size.width / 2;

    double arcAngle1 = 2 * math.pi * (percentage1 / 100);
    double arcAngle2 = 2 * math.pi * (percentage2 / 100);
    canvas.drawArc(
        Rect.fromCircle(center: Offset(300 / 2, 300 / 2), radius: radius),
        arcAngle1,
        arcAngle2 - arcAngle1,
        true,
        paint);
  }

  @override
  bool shouldRepaint(YachtPortfolioArcChart oldDelegate) {
    return false;
  }

  @override
  bool hitTest(Offset position) {
    print('$position');
    final Path path = Path();
    // path.
    path.moveTo(100 / 2, 100 / 2);
    path.addArc(Rect.fromCircle(center: Offset(100 / 2, 100 / 2), radius: 50),
        2 * math.pi * (percentage1 / 100), 2 * math.pi * (percentage2 / 100));

    return path.contains(position);
    // return super.hitTest(position);
  }

  // @override
  // bool hitTest(Offset position) {
  //   return paint.contains(position);
  // }
}
