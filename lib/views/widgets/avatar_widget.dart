import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget avatarWidget(String avatarImage, int itemNum) {
  return Container(
    height: 82,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 72,
          width: 72,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(color: Color(0xFF1EC8CF), width: 2)),
        ),
        Container(
          height: 60,
          width: 60,
          child: CircleAvatar(
            maxRadius: 60,
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage('assets/images/$avatarImage.png'),
          ),
        ),
        Positioned(
          left: 17,
          top: 66,
          child: Stack(
            children: [
              Container(
                width: 38,
                height: 16,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                    color: Color(0xFF1EC8CF),
                    border: Border.all(color: Colors.white, width: 2)),
              ),
              Positioned(
                // top: 3,
                top: 3.5,
                left: 6,
                child: Container(
                  width: 9,
                  height: 9,
                  // child: Image.asset('assets/images/itemlogo.png'),
                  child: SvgPicture.asset(
                    'assets/icons/dog_foot.svg',
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
              Positioned(
                  // top: 1,
                  top: 1.5,
                  left: 20,
                  child: Text(
                    (itemNum ?? 0).toString(),
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ))
            ],
          ),
        )
      ],
    ),
  );
}

Widget avatarWidgetWithoutItem(
  String avatarImage,
) {
  return Container(
    // height: 40,
    child: Container(
      // height: 30,
      // width: 30,
      child: CircleAvatar(
        maxRadius: 60,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage('assets/images/$avatarImage.png'),
      ),
    ),
  );
}
