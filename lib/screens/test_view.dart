import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yachtOne/screens/stock_info/stock_info_kr_view.dart';
import 'package:yachtOne/screens/test2_view.dart';

class TestView extends StatelessWidget {
  TestView({Key? key}) : super(key: key);

  late StreamSubscription<double> subscription;

  StreamController<double> localStreamController = StreamController();
  double offset = 0.0;

  @override
  Widget build(BuildContext context) {
    // subscription.onData((data) {
    //   print(data);
    //   setState(() {
    //     offset = data;
    //   });
    // });
    print("test 1 view built");
    subscription = Test2View.streamController.stream.listen((event) {
      // offset = event;
      // print(event);
      // setState(() {
      offset = event;
      localStreamController.add(offset);
      // });
    });
    return Scaffold(
        backgroundColor: Colors.orange[200],
        body: StreamBuilder<double>(
            stream: localStreamController.stream,
            initialData: 0.0,
            builder: (context, snapshot) {
              print("from local strema ${snapshot.data}");
              return Column(
                children: [
                  Container(
                    height: 200 - snapshot.data!,
                    color: Colors.red[400],
                  ),
                  Container(
                    height: 500,
                    color: Colors.blueGrey[200],
                    child: Test2View(),
                  ),
                ],
              );
            }));
  }
}
