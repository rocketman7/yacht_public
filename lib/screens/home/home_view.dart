import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yachtOne/screens/chart/chart_view.dart';
import 'package:yachtOne/screens/home/home_view_model.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/style_constants.dart';

import 'home_award_card_widget.dart';
import 'quest_widget.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeViewModel homeViewModel = Get.put(HomeViewModel());

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _scrollController = ScrollController(initialScrollOffset: 0);
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              elevation: 0.0, // 스크롤했을 때 SliverAppbar 아래 shadow.
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              // textTheme: TextTheme(headline6: TextStyle(color: Colors.black)),
              // title: Text("APP TITLE"),
              pinned: true,
              expandedHeight: 140,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.fromLTRB(16, 0, 0, 32),
                centerTitle: false,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      "요트  ",
                      style: titleStyle.copyWith(
                        color: Colors.black,
                        // textBaseline: TextBaseline.alphabetic,
                      ),
                    ),
                    Text(
                      "나만의 투자 항해 ⛵️",
                      style: detailStyle.copyWith(
                        color: Colors.grey,
                        // textBaseline: TextBaseline.alphabetic,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                // height: 200,
                // color: Colors.amber,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: kHorizontalPadding,
                      child: Text(
                        "이 달의 상금 주식",
                        style: subtitleStyle,
                      ),
                    ),
                    verticalSpaceMedium,
                    Container(
                      // height: 60,
                      padding: dialogPadding,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                      ),
                      // borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "총 10,000,000원",
                            style: titleStyle,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          SvgPicture.asset(
                            'assets/icons/bottom_rank2.svg',
                            color: Colors.white54,
                            height: 32,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 200,
                // color: Colors.red,
                child: Center(
                    child: Text(
                  "상금 carousel",
                  style: titleStyle,
                )),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                // height: 200,
                // color: Colors.amber,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: kHorizontalPadding,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "오늘의 퀘스트",
                            style: subtitleStyle,
                          ),
                          verticalSpaceSmall,
                          Text(
                            "마감시간 전에 퀘스트에 참여하세요!",
                            style: contentStyle.copyWith(
                                color: Colors.black.withOpacity(.7)),
                          ),
                        ],
                      ),
                    ),
                    verticalSpaceMedium,
                  ],
                ),
              ),
            ),
            GetBuilder<HomeViewModel>(
                init: HomeViewModel(),
                builder: (homeViewModel) {
                  print("is Loading? ${homeViewModel.isLoading}");
                  return SliverToBoxAdapter(
                      child: Container(
                    // color: Colors.amber.withOpacity(.3),
                    height: getProportionateScreenHeight(220),
                    child: homeViewModel.isLoading
                        ? Container(
                            height: getProportionateScreenHeight(170),
                            // color: Colors.red,
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  index == 0
                                      ? SizedBox(
                                          width: kHorizontalPadding.left,
                                        )
                                      : Container(),
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed('quest',
                                          arguments:
                                              homeViewModel.allQuests![0]);
                                    },
                                    child: QuestWidget(
                                        questModel:
                                            homeViewModel.allQuests![0]),
                                  ),
                                  horizontalSpaceLarge
                                ],
                              );
                            }),
                  ));
                }),
            SliverToBoxAdapter(
              child: Container(
                height: 200,
                color: Colors.lime,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 450,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text("Go To Stock Info"),
                      onPressed: () {
                        Get.toNamed('stockInfo');
                      },
                    ),
                    ElevatedButton(
                      child: Text("Go To Design System"),
                      onPressed: () {
                        Get.toNamed('designSystem');
                      },
                    ),
                    ElevatedButton(
                      child: Text("Go To Quest View"),
                      onPressed: () {
                        Get.toNamed('quest',
                            arguments: homeViewModel.allQuests![0]);
                      },
                    ),
                    ElevatedButton(
                      child: Text("Count Test"),
                      onPressed: () {
                        print(DateTime.now());
                        FirestoreService().countTest(0);
                      },
                    ),
                    ElevatedButton(
                      child: Text("Go To Award View (Old)"),
                      onPressed: () {
                        Get.toNamed('awardold');
                      },
                    ),
                    HomeAwardCardWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
