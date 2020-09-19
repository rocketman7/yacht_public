import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:yachtOne/views/constants/size.dart';

class NotVotingView extends StatefulWidget {
  @override
  _NotVotingViewState createState() => _NotVotingViewState();
}

class _NotVotingViewState extends State<NotVotingView> {
  bool selected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          height: deviceHeight,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: <Widget>[
                  Container(
                    color: Colors.green[50],
                    width: double.infinity,
                    height: deviceHeight * .12,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "01:05:30",
                          style: TextStyle(
                            fontFamily: 'Akrhip',
                            fontSize: deviceHeight * .12 * 0.45,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -2.5,
                          ),
                        ),
                        Text(
                          "예측마감까지 남은시간",
                          style: TextStyle(
                            // fontFamily: 'Akrhip',
                            fontSize: deviceHeight * .12 * 0.17,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      // color: Colors.black,
                      child: SingleChildScrollView(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        physics: BouncingScrollPhysics(
                            // android에서도 스크롤 많이 했을 때 바운스 생기게
                            parent: AlwaysScrollableScrollPhysics()),
                        // physics: (),
                        child: Column(
                          children: <Widget>[
                            singleChoice(
                              "KOSPI",
                              Color(0xFFFF74D5),
                            ),
                            singleChoice(
                              "KOSDAQ",
                              Color(0xFF2E57BA),
                            ),
                            singleChoice(
                              "USDKRW",
                              Colors.greenAccent,
                            ),
                            singleChoice(
                              "KOSPI",
                              Color(0xFFFF74D5),
                            ),
                            singleChoice(
                              "KOSPI",
                              Color(0xFFFF74D5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: Container(
                      color: Colors.blue,
                      height: deviceHeight * .07,
                      child: FlatButton(
                        color: Colors.black,
                        onPressed: () {},
                        minWidth: double.infinity,
                        // shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(30.0)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // alignment: Alignment.centerLeft,
                              children: <Widget>[
                                Text(
                                  "예측하러 가기",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: deviceHeight * .07 * .36,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget singleChoice(
    String text,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Container(
              height: deviceHeight * .15,
              // color: Colors.redAccent,
              child: FlatButton(
                color: color,
                onPressed: () {},
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.black,
                        width: 5,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(70.0)),
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: deviceHeight * .15 * .35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Transform.scale(
            scale: 2.0,
            child: CircularCheckBox(
              materialTapTargetSize: MaterialTapTargetSize.padded,
              visualDensity: VisualDensity(horizontal: 1, vertical: 0),
              value: this.selected,
              checkColor: Colors.white,
              activeColor: Color(0xFF1EC8CF),
              inactiveColor: Color(0xFF1EC8CF),
              disabledColor: Colors.grey,
              onChanged: (val) => this.setState(() {
                this.selected = !this.selected;
              }),
            ),
          ),
        ],
      ),
    );
  }
}
