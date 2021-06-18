import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yachtOne/screens/chart/chart_view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                Get.toNamed('quest');
              },
            ),
          ],
        ),
      ),
    );
  }
}
