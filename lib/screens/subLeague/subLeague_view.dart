import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'subLeague_controller.dart';

class SubLeagueView extends StatelessWidget {
  final SubLeagueController _subLeagueController =
      Get.find<SubLeagueController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Obx(
                    () => Text(
                        '${_subLeagueController.allSubLeagues[_subLeagueController.pageIndexForUI.value].name}'),
                  ),
                  Row(
                    children: [
                      Spacer(),
                      ElevatedButton(
                          onPressed: () {
                            _subLeagueController.pageNavigateToLeft();
                          },
                          child: Text('left')),
                      Spacer(),
                      ElevatedButton(
                          onPressed: () {
                            _subLeagueController.pageNavigateToRight();
                          },
                          child: Text('right')),
                      Spacer(),
                    ],
                  ),
                  Obx(
                    () => Column(
                      children: [
                        Text(
                            '${_subLeagueController.allSubLeagues[_subLeagueController.pageIndexForUI.value].description}'),
                        Text(
                            '${_subLeagueController.allSubLeagues[_subLeagueController.pageIndexForUI.value]}'),
                        Text(
                            '${_subLeagueController.allSubLeagues[_subLeagueController.pageIndexForUI.value].rules[0]}'),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
