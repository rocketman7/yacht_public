import 'package:flutter/material.dart';
import 'package:get/get.dart';

RxDouble _offset = 0.0.obs;

class TestView extends StatelessWidget {
  TestView({
    Key? key,
  }) : super(key: key);

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      _offset(_scrollController.offset);
      print(_offset);
      // print(scrollController.offset);
    });
    return Scaffold(
        backgroundColor: Colors.orange[200],
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              title: Text(
                "test",
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 50,
                color: Colors.blue,
              ),
            ),
            SliverPersistentHeader(
              delegate: SectionHeaderDelegate(
                  Container(
                    // height: _offset.value.toDouble() > 150
                    //     ? 150
                    //     : 300 - _offset.value.toDouble(),
                    // width: _offset.value.toDouble() > 150
                    //     ? 150
                    //     : 300 - _offset.value.toDouble(),
                    color: Colors.deepOrangeAccent,
                  ),
                  Obx(
                    () => Container(
                      height: _offset.value.toDouble() > 250
                          ? 50
                          : 300 - _offset.value.toDouble(),
                      width: _offset.value.toDouble() > 250
                          ? 50
                          : 300 - _offset.value.toDouble(),
                      color: Colors.black,
                    ),
                  )),
              // floating: true,
              pinned: true,
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 150,
                color: Colors.yellow,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 300,
                color: Colors.amberAccent,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 300,
                color: Colors.red,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 300,
                color: Colors.blue,
              ),
            ),
          ],
        ));
  }
}

class SectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final Widget child2;
  // final double height;

  SectionHeaderDelegate(this.child, this.child2);

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: child,
        ),
        Obx(
          () => Align(
            alignment: Alignment(
                (_offset.value < 150)
                    ? 0
                    : _offset.value > 300
                        ? 1
                        : (_offset.value - 150) / 150,
                0),
            child: child2,
          ),
        )
      ],
    );
  }

  @override
  double get maxExtent => 300;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
