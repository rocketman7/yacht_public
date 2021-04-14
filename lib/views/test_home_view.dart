import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class TestHomeView extends StatefulWidget {
  @override
  _TestHomeViewState createState() => _TestHomeViewState();
}

class _TestHomeViewState extends State<TestHomeView> {
  ScrollController _scrollController;
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

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: SafeArea(
        child: Scaffold(
          body:
              //     SingleChildScrollView(
              //   child: Column(
              //     children: [
              //       Text("Test"),
              //     ],
              //   ),
              // )
              CustomScrollView(
            // controller: _scrollController,
            slivers: [
              SliverAppBar(
                pinned: true,
                title: Text(
                  'Flutter Slivers Demo',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color:
                          _currentHeight >= 200 ? Colors.black : Colors.white),
                ),
                backgroundColor: Color(0xFFEDF2F8),
                expandedHeight: 300,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                      "https://images.unsplash.com/photo-1603785608232-44c43cdc0d70?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHx0b3BpYy1mZWVkfDY4fEo5eXJQYUhYUlFZfHxlbnwwfHx8&auto=format&fit=crop&w=500&q=60",
                      fit: BoxFit.cover),
                ),
              ),
              SliverFillRemaining(
                fillOverscroll: true,
                child: Column(
                  children: [
                    Container(height: 180, child: Text("TEST")),
                    Container(height: 180, child: Text("TEST")),
                    Container(height: 180, child: Text("TEST")),
                  ],
                ),
              ),
              SliverFillRemaining(
                // fillOverscroll: true,
                child: Text("TEST"),
              ),
              SliverFillRemaining(
                // fillOverscroll: true,
                child: Text("TEST"),
              )
              // Container(
              //   height: 100,
              //   color: Colors.blue,
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Container(
              //   height: 100,
              //   color: Colors.red,
              // ),
              // Container(
              //   height: 100,
              //   color: Colors.blue,
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Container(
              //   height: 100,
              //   color: Colors.red,
              // ),
              // Container(
              //   height: 100,
              //   color: Colors.blue,
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Container(
              //   height: 100,
              //   color: Colors.red,
              // ),
              // Container(
              //   height: 100,
              //   color: Colors.blue,
              // ),

              // Container(
              //   height: 100,
              //   color: Colors.blue,
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Container(
              //   height: 100,
              //   color: Colors.red,
              // ),
              // Container(
              //   height: 100,
              //   color: Colors.blue,
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Container(
              //   height: 100,
              //   color: Colors.red,
              // ),
              // Container(
              //   height: 100,
              //   color: Colors.blue,
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Container(
              //   height: 100,
              //   color: Colors.red,
              // ),
              // Container(
              //   height: 100,
              //   color: Colors.blue,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
