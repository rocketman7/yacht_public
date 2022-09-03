import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' as refresh;
import 'package:yachtOne/yacht_design_system/yds_color.dart';
import 'package:yachtOne/yacht_design_system/yds_font.dart';

// 텍스트, 숫자 로딩 중에 쓰는 네모박스 그라데이션 위젯
class TextLoadingWidget extends StatefulWidget {
  TextLoadingWidget({
    Key? key,
    required this.height,
    required this.width,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  State<TextLoadingWidget> createState() => _TextLoadingWidgetState();
}

class _TextLoadingWidgetState extends State<TextLoadingWidget> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 800),
  )..repeat(reverse: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        // tween: Tween(begin: 0.0, end: 1.0),
        // duration: Duration(milliseconds: 500),
        builder: (context, _) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                yachtGrey,
                Color(0xff545758).withOpacity(.6),
                yachtGrey,
              ], stops: [
                0,
                _controller.value,
                1,
              ]),
            ),
            height: widget.height,
            width: widget.width,
            // color: yachtWhite,
          );
        });
  }
}

Container appBarWithoutCloseButton({required String title, double? height}) {
  return Container(
    height: height ?? 60.w,
    color: yachtDarkGrey,
    child: Center(child: Text(title, style: head3Style)),
  );
}

class YachtCustomHeader extends refresh.RefreshIndicator {
  final refresh.OuterBuilder? outerBuilder;
  final String? releaseText, idleText, refreshingText, completeText, failedText, canTwoLevelText;
  final Widget? releaseIcon, idleIcon, refreshingIcon, completeIcon, failedIcon, canTwoLevelIcon, twoLevelView;

  /// icon and text middle margin
  final double spacing;
  final refresh.IconPosition iconPos;

  final TextStyle textStyle;

  const YachtCustomHeader({
    Key? key,
    refresh.RefreshStyle refreshStyle: refresh.RefreshStyle.Follow,
    // double height: 80.w,
    Duration completeDuration: const Duration(milliseconds: 600),
    this.outerBuilder,
    this.textStyle: const TextStyle(color: Colors.grey),
    this.releaseText,
    this.refreshingText,
    this.canTwoLevelIcon,
    this.twoLevelView,
    this.canTwoLevelText,
    this.completeText,
    this.failedText,
    this.idleText,
    this.iconPos: refresh.IconPosition.left,
    this.spacing: 15.0,
    this.refreshingIcon,
    this.failedIcon: const Icon(Icons.error, color: Colors.grey),
    this.completeIcon: const Icon(Icons.done, color: Colors.grey),
    this.idleIcon = const Icon(Icons.arrow_downward, color: Colors.grey),
    this.releaseIcon = const Icon(Icons.refresh, color: Colors.grey),
  }) : super(
          key: key,
          refreshStyle: refreshStyle,
          completeDuration: completeDuration,
          // height: height,
        );

  @override
  State createState() {
    // TODO: implement createState
    return _YachtCustomHeaderState();
  }
}

class _YachtCustomHeaderState extends refresh.RefreshIndicatorState<YachtCustomHeader> {
  Widget _buildText(mode) {
    refresh.RefreshString strings = refresh.KrRefreshString();
    return Text(
        mode == refresh.RefreshStatus.canRefresh
            ? widget.releaseText ?? strings.canRefreshText!
            : mode == refresh.RefreshStatus.completed
                ? widget.completeText ?? strings.refreshCompleteText!
                : mode == refresh.RefreshStatus.failed
                    ? widget.failedText ?? strings.refreshFailedText!
                    : mode == refresh.RefreshStatus.refreshing
                        ? widget.refreshingText ?? strings.refreshingText!
                        : mode == refresh.RefreshStatus.idle
                            ? widget.idleText ?? strings.idleRefreshText!
                            : mode == refresh.RefreshStatus.canTwoLevel
                                ? widget.canTwoLevelText ?? strings.canTwoLevelText!
                                : "",
        style: widget.textStyle.copyWith(color: yachtLightGrey));
  }

  Widget _buildIcon(mode) {
    Widget? icon = mode == refresh.RefreshStatus.canRefresh
        ? widget.releaseIcon
        : mode == refresh.RefreshStatus.idle
            ? widget.idleIcon
            : mode == refresh.RefreshStatus.completed
                ? widget.completeIcon
                : mode == refresh.RefreshStatus.failed
                    ? widget.failedIcon
                    : mode == refresh.RefreshStatus.canTwoLevel
                        ? widget.canTwoLevelIcon
                        : mode == refresh.RefreshStatus.canTwoLevel
                            ? widget.canTwoLevelIcon
                            : mode == refresh.RefreshStatus.refreshing
                                ? widget.refreshingIcon ??
                                    SizedBox(
                                      width: 25.0,
                                      height: 25.0,
                                      child: defaultTargetPlatform == TargetPlatform.iOS
                                          ? const CupertinoActivityIndicator()
                                          : const CircularProgressIndicator(strokeWidth: 2.0),
                                    )
                                : widget.twoLevelView;
    return icon ?? Container();
  }

  @override
  bool needReverseAll() {
    // TODO: implement needReverseAll
    return false;
  }

  @override
  Widget buildContent(BuildContext context, refresh.RefreshStatus? mode) {
    // TODO: implement buildContent
    Widget textWidget = _buildText(mode);
    Widget iconWidget = _buildIcon(mode);
    List<Widget> children = <Widget>[iconWidget, textWidget];
    final Widget container = Wrap(
      spacing: widget.spacing,
      textDirection: widget.iconPos == refresh.IconPosition.left ? TextDirection.ltr : TextDirection.rtl,
      direction: widget.iconPos == refresh.IconPosition.bottom || widget.iconPos == refresh.IconPosition.top
          ? Axis.vertical
          : Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      verticalDirection: widget.iconPos == refresh.IconPosition.bottom ? VerticalDirection.up : VerticalDirection.down,
      alignment: WrapAlignment.center,
      children: children,
    );
    return widget.outerBuilder != null
        ? widget.outerBuilder!(container)
        : Container(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: container,
            ),
            // color: Colors.blue,
            height: ScreenUtil().statusBarHeight + 80.w,
          );
  }
}
