import 'package:flutter/material.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

List<PopupMenuItem> communityShowMore = [
  PopupMenuItem(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    // value: index,
    height: 20.w,
    value: 'block',
    child: Container(
        child: Center(
            child: Text(
      '차단',
      style: contentStyle,
    ))),
  ),
  PopupMenuItem(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    // value: index,
    value: 'report',
    height: 20.w,
    child: Container(
        child: Center(
            child: Text(
      '신고',
      style: contentStyle,
    ))),
  ),
];

List<PopupMenuItem> communityMyShowMore = [
  PopupMenuItem(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    // value: index,
    height: 20.w,
    value: 'edit',
    child: Container(
        child: Center(
            child: Text(
      '수정',
      style: contentStyle,
    ))),
  ),
  PopupMenuItem(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    // value: index,
    height: 20.w,
    value: 'delete',
    child: Container(
        child: Center(
            child: Text(
      '삭제',
      style: contentStyle,
    ))),
  ),
];

List<PopupMenuItem> commentMyShowMore = [
  PopupMenuItem(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    // value: index,
    height: 20.w,
    value: 'delete',
    child: Container(
        child: Center(
            child: Text(
      '삭제',
      style: contentStyle,
    ))),
  ),
];
