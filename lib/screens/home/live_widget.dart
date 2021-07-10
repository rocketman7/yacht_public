import 'package:flutter/material.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/styles/size_config.dart';

class LiveWidget extends StatelessWidget {
  final QuestModel questModel;
  const LiveWidget({
    Key? key,
    required this.questModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _side = getProportionateScreenHeight(280);
    return Column(
      children: [
        Container(
          height: _side,
          width: _side,
          color: Colors.blue,
        )
      ],
    );
  }
}
