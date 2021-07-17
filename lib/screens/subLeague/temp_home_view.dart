import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../styles/style_constants.dart';
import '../../handlers/numbers_handler.dart' as NumbersHandler;

import 'subLeague_controller.dart';
import 'subLeague_view.dart';

class TempHomeView extends StatelessWidget {
  // final SubLeagueController _subLeagueController = Get.put(SubLeagueController());
  final String leagueName;

  TempHomeView({required this.leagueName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF5F4F8),
        body: SafeArea(
          child: ListView(
            children: [
              SizedBox(
                height: 50.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Text(
                  '$leagueName의 상금 주식',
                  style: subtitleStyle.copyWith(color: Color(0xFF123A5F)),
                ),
              ),
              SizedBox(
                height: 0.0,
              ),
              GetBuilder<SubLeagueController>(
                // 여기서 init 을 해주니까 위에서 굳이 put 안해줘도 됨
                init: SubLeagueController(),
                builder: (controller) {
                  if (controller.isAllSubLeaguesLoaded) {
                    return HomeSubLeagueCardCarouselSliderWidget();
                  } else {
                    return HomeSubLeagueCardCarouselSliderWidgetForLoading();
                  }
                },
              ),
              Container(
                color: Colors.black,
                height: 10,
              )
            ],
          ),
        ));
  }
}

class HomeSubLeagueCardCarouselSliderWidget extends StatelessWidget {
  final SubLeagueController _subLeagueController =
      Get.find<SubLeagueController>();

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      options: CarouselOptions(
        viewportFraction: 3 / 4,
        enableInfiniteScroll: false,
        // aspectRatio: 0.5,
        // onPageChanged: (idx, _) {
        //   print('$idx');
        // },
      ),
      itemCount: _subLeagueController.allSubLeagues.length,
      itemBuilder: (context, index, realIndex) {
        return Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              onTap: () {
                _subLeagueController.pageIndexForUI = index.obs;
                Get.to(() => SubLeagueView());
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF38204B).withOpacity(0.18),
                      blurRadius: 12,
                      offset: Offset(0, 0),
                    ),
                  ],
                  color: Colors.white,
                ),
                height: 150.0,
                width: 275.0,
                child: Column(
                  children: [
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      '${_subLeagueController.allSubLeagues[index].name}',
                      style: contentStyle.copyWith(
                          color: Color(0xFF123A5F),
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 22.0,
                    ),
                    //원인지 달러인지 등도 나중에는 구분해줘야할 듯
                    Text(
                        '${NumbersHandler.toPriceKRW(_subLeagueController.allSubLeagues[index].totalValue)}원',
                        style: titleStyle.copyWith(
                            color: Color(0xFFEE5076),
                            fontSize: 30.0,
                            fontWeight: FontWeight.w900)),
                    SizedBox(
                      height: 18.0,
                    ),
                    Text(
                      '2021년 07월 31일까지',
                      style: detailStyle.copyWith(
                          color: Color(0xFF475A6C),
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      '상금 주식의 가치 기준일 2021년 04월 26일',
                      style: TextStyle(
                          color: Color(0xFF123A5F).withOpacity(0.3),
                          fontSize: 7.0,
                          fontWeight: FontWeight.w300),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class HomeSubLeagueCardCarouselSliderWidgetForLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 20.0,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF38204B).withOpacity(0.18),
                  blurRadius: 12,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
              color: Colors.white,
            ),
            height: 150.0,
            width: 275.0,
            child: Column(
              children: [],
            ),
          ),
        ],
      ),
    );
  }
}
