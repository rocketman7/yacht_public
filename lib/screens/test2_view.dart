import 'dart:async';

import 'package:flutter/material.dart';

class Test2View extends StatelessWidget {
  Test2View({Key? key}) : super(key: key);

  ScrollController scrollController = ScrollController(initialScrollOffset: 0);

  static StreamController<double> streamController = StreamController();
  late StreamSubscription streamSubscription;

  @override
  Widget build(BuildContext context) {
    print("test 2 view built");
    scrollController.addListener(() {
      streamController.add(scrollController.offset);
      // print(scrollController.offset);
    });

    // streamSubscription = streamController.stream.listen((event) {
    //   print(event);
    // });
    return Scaffold(
        body: ListView.builder(
            controller: scrollController,
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                height: 100,
                color: index.remainder(2) == 1 ? Colors.red : Colors.blue,
              );
            }));
  }
}
