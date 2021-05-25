import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';

import '../constants/size_config.dart';
import '../constants/view_constants.dart';

class TestHomeView extends StatefulWidget {
  @override
  _TestHomeViewState createState() => _TestHomeViewState();
}

class _TestHomeViewState extends State<TestHomeView> {
  late ScrollController _scrollController;
  double _currentHeight = 0;
  @override
  void initState() {
    _scrollController = ScrollController(initialScrollOffset: 0);
    _scrollController.addListener(() {
      print(_scrollController.offset);
      setState(() {
        _currentHeight = _scrollController.offset;
      });
    });

    // TODO: implement initState
    super.initState();
  }

  List<dynamic> imgList = [0, 1, 2, 3];
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    // 퀘스트 카드 샘플
    final List<Widget> imageSliders = imgList
        .map(
          (item) => Container(
            decoration: BoxDecoration(
              color: Color(0xFFB3E7F2),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            margin: const EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text("5,000,000원",
                            style: Theme.of(context).textTheme.headline5
                            // textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints.expand(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star,
                            size: 50,
                          )
                        ],
                      ),
                    ),
                    // Image.network(item, fit: BoxFit.cover, width: 1000.0),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF82C0D9), Color(0xFF82C0D9)],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 20.0),
                        child: Center(
                          child: Text('월간 리그 상금 Top 10',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(fontSize: 20, color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        )
        .toList();

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: appBackgroundColor.withBlue(20),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {},
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Community'),
          // BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My')
        ],
      ),
      body: Container(
        // color: appBackgroundColor,
        child: SafeArea(
            child: Scaffold(
          // backgroundColor: Colors.black,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                elevation: 0.0, // 스크롤했을 때 SliverAppbar 아래 shadow.

                backgroundColor: kPrimaryBackGroundColorLight,
                // textTheme:
                // TextTheme(headline6: TextStyle(color: Colors.black)),
                // title: Text("APP TITLE"),
                pinned: true,
                expandedHeight: 100,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.fromLTRB(16, 0, 0, 16),
                  centerTitle: false,
                  title: GestureDetector(
                    onTap: () {
                      Get.snackbar("title", "message");
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("요트  ",
                            style: Theme.of(context).textTheme.headline6),
                        Text(
                          "나만의 투자 항해 ⛵️",
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'AppleSDB',
                            letterSpacing: -1,
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // SliverPersistentHeader(
              //   delegate: CustomSliverAppBarDelegate(expandedHeight: 200),
              //   pinned: true,
              // ),
              buildHomeContents(imageSliders)
            ],
          ),
        )),
      ),
    );
  }

  Widget buildHomeContents(List<Widget> imageSliders) {
    // const TextStyle _titleStyle =
    //     TextStyle(color: Colors.black, fontSize: 22, fontFamily: 'AppleSD');

    const EdgeInsets _titlePadding =
        EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    return SliverToBoxAdapter(
      child: Container(
        // height: 9900,
        // color: Colors.red,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: _titlePadding,
              child: Text(
                "이 달의 상금 주식",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Container(
              height: getProportionateScreenHeight(65),
              decoration: BoxDecoration(
                color: Color(0xFFD4EC82),
              ),
              // borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "총 10,000,000원",
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(fontSize: 28, color: Colors.black87),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  SvgPicture.asset(
                    'assets/icons/bottom_rank2.svg',
                    color: Colors.black87,
                    height: 32,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 12,
            ),
            VerticalSliderDemo(
              imageSliders: imageSliders,
            ),
            SizedBox(
              height: 32,
            ),
            Padding(
              padding: _titlePadding,
              child: Text(
                "꾸욱 점수 얻기",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: imgList.map((e) {
                  return Padding(
                    padding: e == 0
                        ? const EdgeInsets.only(left: 16.0)
                        : const EdgeInsets.only(left: 0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            buildSqaureQuest(),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.timer,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text("12:34:00",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16))
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 16,
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Padding(
              padding: _titlePadding,
              child: Text(
                "이 달의 랭킹",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                  children: List.generate(5, (index) {
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          // color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      height: 60,
                      child: Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.grey),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 20,
                                width: 100,
                                color: Color(0xffc2c2c2),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                height: 20,
                                width: 150,
                                color: Color(0xffc2c2c2),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    index < 4 ? SizedBox(height: 12) : Container(),
                  ],
                );
              })),
            ),
            SizedBox(
              height: 32,
            ),
            Padding(
              padding: _titlePadding,
              child: Text(
                "오늘의 마켓",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                  children: List.generate(3, (index) {
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          // color: Colors.red,
                          borderRadius: BorderRadius.circular(10)),
                      height: 60,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Container(
                                    // color: Colors.red,
                                    child: Text(
                                      "뉴스내용뉴스내용뉴스내용뉴스내용뉴스내용뉴스내용뉴스내용뉴스내용뉴스내용뉴스내용뉴스내용뉴스내용뉴스내용",
                                      style: TextStyle(
                                          height: 1.5,
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: 'AppleSDM'),
                                      maxLines: 2,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                    index < 2
                        ? Divider(
                            color: Colors.grey,
                          )
                        : Container(),
                    // SizedBox(height: 12),
                  ],
                );
              })),
            ),
            SizedBox(
              height: 32,
            ),
            Padding(
              padding: _titlePadding,
              child: Text(
                "스토리",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: imgList.map((e) {
                    return Row(
                      children: [
                        Container(
                          height: 240,
                          width: 200,
                          decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "재미난 주식 이야기",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'AppleSDB',
                                      fontSize: 28),
                                ),
                                Text(
                                  "보러가기",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'AppleSDB',
                                      fontSize: 16),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        )
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            // Container(
            //   height: 200,
            //   decoration: BoxDecoration(border: Border.all(width: 4)),
            // ),
            // Container(
            //   height: 200,
            //   decoration: BoxDecoration(border: Border.all(width: 4)),
            // ),
            // Container(
            //   height: 200,
            //   decoration: BoxDecoration(border: Border.all(width: 4)),
            // )
          ],
        ),
      ),
    );
  }

  Container buildSqaureQuest() {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
          color: Colors.blueGrey, borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "카테고리",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.white),
            ),
            Text(
              "꾸욱 3점",
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(color: Colors.white),
            ),
            Text(
              "포인트를 차지하세요",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

class VerticalSliderDemo extends StatelessWidget {
  final List<Widget>? imageSliders;

  const VerticalSliderDemo({Key? key, this.imageSliders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 150,
        child: CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 2.4,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
            autoPlay: true,
          ),
          items: imageSliders,
        ));
  }
}

class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  const CustomSliverAppBarDelegate({
    required this.expandedHeight,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    final size = 60;
    final top = expandedHeight - shrinkOffset - size / 2;

    return Stack(
      fit: StackFit.expand,
      // overflow: Overflow.visible,
      children: [
        buildBackground(shrinkOffset),
        buildAppBar(shrinkOffset),
        // Positioned(
        //   top: top,
        //   left: 20,
        //   right: 20,
        //   child: buildFloating(shrinkOffset),
        // ),
      ],
    );
  }

  double appear(double shrinkOffset) => shrinkOffset / expandedHeight;

  double disappear(double shrinkOffset) => 1 - shrinkOffset / expandedHeight;
  Widget buildAppBar(double shrinkOffset) => Opacity(
        opacity: appear(shrinkOffset),
        child: AppBar(
          title: Text("TITLE"),
          centerTitle: true,
        ),
      );

  Widget buildBackground(double shrinkOffset) => Opacity(
        opacity: disappear(shrinkOffset),
        child: Image.network(
          'https://source.unsplash.com/random?mono+dark',
          fit: BoxFit.cover,
        ),
      );
  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
