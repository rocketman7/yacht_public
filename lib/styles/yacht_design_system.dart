import 'package:flutter/material.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/style_constants.dart';

class YachtDesignSystem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        body: ListView(
          padding: kSymmetricPadding,
          children: [
            Text(
              "Design System",
              style: headingStyle,
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
