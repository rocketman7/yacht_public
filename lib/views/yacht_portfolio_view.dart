import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/views/constants/size.dart';

import '../view_models/yacht_portfolio_view_model.dart';
import 'notification_web_view.dart';

class YachtPortfolioView extends StatelessWidget {
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0.0);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<YachtPortfolioViewModel>.reactive(
        viewModelBuilder: () => YachtPortfolioViewModel(),
        builder: (context, model, child) {
          /*return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blue,
                title: Text(
                  '새포트폴리오~',
                  style: TextStyle(
                    fontFamily: 'AppleSDEB',
                    fontSize: 20.sp,
                    letterSpacing: -2.0,
                  ),
                ),
                elevation: 1,
              ),
              backgroundColor: Colors.white,
              body: model.hasError
                  ? Container(
                      child: Text('error발생. 페이지를 벗어나신 후 다시 시도하세요.'),
                    )
                  : model.isBusy
                      ? Container()
                      : SafeArea(
                          child: Container(
                          color: Colors.red,
                        )));*/
          return Scaffold(
            body: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  expandedHeight: 288,
                  backgroundColor: Colors.blue,
                  pinned: true,
                  elevation: 2,
                  centerTitle: true,
                  title: Container(
                    color: Colors.blue,
                    child: FadeOnScroll(
                      scrollController: _scrollController,
                      zeroOpacityOffset: 188,
                      fullOpacityOffset: 288,
                      child: Text(
                        '10,128,400원 - 요트 점수 Top 3',
                        style: TextStyle(
                          fontFamily: 'AppleSDL',
                          fontSize: 18,
                          letterSpacing: -2.0,
                        ),
                      ),
                    ),
                  ),
                  flexibleSpace: SafeArea(
                    child: AnimationScroll(
                      scrollController: _scrollController,
                      zeroOffset: 0,
                      fullOffset: 288,
                    ),
                  ),
                ),
                buildPortfolioBody(),
              ],
            ),
          );
        });
  }

  Widget buildPortfolioBody() => SliverList(
        delegate: SliverChildListDelegate([
          Container(
            color: Colors.grey,
            height: 100,
          ),
          Container(
            color: Colors.black,
            height: 100,
          ),
          Container(
            color: Colors.white,
            height: 100,
          ),
          Container(
            color: Colors.grey,
            height: 100,
          ),
          Container(
            color: Colors.black,
            height: 100,
          ),
          Container(
            color: Colors.white,
            height: 100,
          ),
          Container(
            color: Colors.grey,
            height: 100,
          ),
          Container(
            color: Colors.black,
            height: 100,
          ),
          Container(
            color: Colors.white,
            height: 100,
          ),
          Container(
            color: Colors.black,
            height: 100,
          ),
          Container(
            color: Colors.grey,
            height: 100,
          ),
          Container(
            color: Colors.white,
            height: 100,
          ),
        ]),
      );
}

// 아래로 스크롤할 때 title을 서서히 Fade In 시켜주는 stateful widget
class FadeOnScroll extends StatefulWidget {
  final ScrollController scrollController;
  final double zeroOpacityOffset;
  final double fullOpacityOffset;
  final Widget child;

  FadeOnScroll(
      {Key key,
      @required this.scrollController,
      @required this.child,
      this.zeroOpacityOffset = 0,
      this.fullOpacityOffset = 0});

  @override
  _FadeOnScrollState createState() => _FadeOnScrollState();
}

class _FadeOnScrollState extends State<FadeOnScroll> {
  double _offset;

  @override
  initState() {
    super.initState();
    _offset = widget.scrollController.offset;
    widget.scrollController.addListener(_setOffset);
  }

  @override
  dispose() {
    widget.scrollController.removeListener(_setOffset);
    super.dispose();
  }

  void _setOffset() {
    setState(() {
      _offset = widget.scrollController.offset;
    });
  }

  double _calculateOpacity() {
    if (_offset <= widget.zeroOpacityOffset)
      return 0;
    else if (_offset >= widget.fullOpacityOffset)
      return 1;
    else
      return (_offset - widget.zeroOpacityOffset) /
          (widget.fullOpacityOffset - widget.zeroOpacityOffset);
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _calculateOpacity(),
      child: widget.child,
    );
  }
}

// 아래로 스크롤할 때 기타요소들 애니메이션(크기조절, fade 등) 해주는 stateful widget
class AnimationScroll extends StatefulWidget {
  final ScrollController scrollController;
  final double zeroOffset;
  final double fullOffset;

  AnimationScroll(
      {Key key,
      @required this.scrollController,
      this.zeroOffset = 0,
      this.fullOffset = 0});

  @override
  _AnimationScrollState createState() => _AnimationScrollState();
}

class _AnimationScrollState extends State<AnimationScroll> {
  double _offset;

  @override
  initState() {
    super.initState();
    _offset = widget.scrollController.offset;
    widget.scrollController.addListener(_setOffset);
  }

  @override
  dispose() {
    widget.scrollController.removeListener(_setOffset);
    super.dispose();
  }

  void _setOffset() {
    setState(() {
      _offset = widget.scrollController.offset;
    });
  }

  double _calculateHeight() {
    if (_offset <= widget.zeroOffset)
      return 288;
    else if (_offset >= widget.fullOffset - kToolbarHeight)
      return kToolbarHeight;
    else
      return (widget.fullOffset - _offset);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: _calculateHeight(),
          color: Colors.amber,
        ),
      ],
    );
  }
}
