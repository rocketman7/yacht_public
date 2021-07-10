import 'package:flutter/material.dart';
import 'package:yachtOne/screens/home/home_view.dart';

class StartupView extends StatelessWidget {
  const StartupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: TabBarView(
            // 기존 방식으로 바꿔야 함
            physics: NeverScrollableScrollPhysics(),
            children: [
              HomeView(),
              Container(color: Colors.blue),
              Container(color: Colors.red)
            ],
          ),
          bottomNavigationBar: Container(
            height: 70,
            color: Colors.white,
            child: TabBar(
              indicatorPadding: EdgeInsets.zero,
              // indicatorSize:  0,
              // labelPadding: EdgeInsets.ze,
              labelColor: Colors.black,
              tabs: [
                Tab(
                  // child: Container(
                  //   color: Colors.red,
                  // ),
                  icon: Icon(Icons.home),
                  text: 'home',
                ),
                Tab(
                  icon: Icon(Icons.chat),
                  text: 'chat',
                ),
                Tab(
                  icon: Icon(Icons.people),
                  text: 'my',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
