import 'package:flutter/material.dart';
import 'customized_date_helper.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DateWidget extends StatelessWidget {
  final defaultDateFormat = 'd';
  final defaultMonthFormat = 'MMM';
  final defaultWeekDayFormat = 'EEE';

  final double height;
  final double width;
  final DateTime date;
  final TextStyle monthTextStyle;
  final TextStyle selectedMonthTextStyle;
  final String monthFormat;
  final TextStyle dateTextStyle;
  final TextStyle selectedDateTextStyle;
  final String dateFormat;
  final TextStyle weekDayTextStyle;
  final TextStyle disabledMonthTextStyle;
  final TextStyle disabledDateTextStyle;
  final TextStyle disabledWeekDayTextStyle;
  final TextStyle selectedWeekDayTextStyle;
  final String weekDayFormat;
  final VoidCallback onTap;
  final VoidCallback onLongTap;
  final Decoration defaultDecoration;
  final Decoration selectedDecoration;
  final Decoration disabledDecoration;
  final bool isSelected;
  final bool isDisabled;
  final EdgeInsetsGeometry padding;
  final List<LabelType> labelOrder;
  final bool isLabelUppercase;

  const DateWidget({
    Key key,
    @required this.date,
    this.width,
    this.height,
    this.onTap,
    this.onLongTap,
    this.isSelected = false,
    this.isDisabled = false,
    this.monthTextStyle,
    this.selectedMonthTextStyle,
    this.monthFormat,
    this.dateTextStyle,
    this.selectedDateTextStyle,
    this.dateFormat,
    this.weekDayTextStyle,
    this.disabledMonthTextStyle,
    this.disabledDateTextStyle,
    this.disabledWeekDayTextStyle,
    this.selectedWeekDayTextStyle,
    this.weekDayFormat,
    this.defaultDecoration,
    this.selectedDecoration = const BoxDecoration(color: Colors.cyan),
    this.disabledDecoration = const BoxDecoration(color: Colors.grey),
    this.padding,
    this.labelOrder,
    this.isLabelUppercase = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline6;
    final subTitleStyle = Theme.of(context).textTheme.subtitle2;

    final monthStyle = isSelected
        ? selectedMonthTextStyle ?? monthTextStyle ?? subTitleStyle
        : isDisabled
            ? disabledMonthTextStyle
            : monthTextStyle ?? subTitleStyle;
    final dateStyle = isSelected
        ? selectedDateTextStyle ?? dateTextStyle ?? titleStyle
        : isDisabled
            ? disabledDateTextStyle
            : dateTextStyle ?? titleStyle;
    final dayStyle = isSelected
        ? selectedWeekDayTextStyle ?? weekDayTextStyle ?? subTitleStyle
        : isDisabled
            ? disabledWeekDayTextStyle
            : weekDayTextStyle ?? subTitleStyle;

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      onLongPress: isDisabled ? null : onLongTap,
      child: Container(
        width: 48.w,
        height: height.h - 16.h,
        decoration: isSelected
            ? selectedDecoration
            : isDisabled
                ? disabledDecoration
                : defaultDecoration,
        child: Padding(
          padding: padding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 2,
                width: width * (1 / 3),
                color: Colors.white,
              ),
              SizedBox(
                height: 10,
              ),
              ...labelOrder.map((type) {
                Text text;
                switch (type) {
                  case LabelType.month:
                    text = Text(
                      isLabelUppercase
                          ? _monthLabel().toUpperCase()
                          : _monthLabel(),
                      style: monthStyle,
                    );
                    break;
                  case LabelType.date:
                    text = Text(
                      DateFormat(dateFormat ?? defaultDateFormat).format(date),
                      style: dateStyle,
                    );
                    break;
                  case LabelType.weekday:
                    text = Text(
                      isLabelUppercase
                          ? _weekDayLabel().toUpperCase()
                          : _weekDayLabel(),
                      style: dayStyle,
                    );
                    break;
                }
                return text;
              }).toList(growable: false)
            ],
          ),
        ),
      ),
    );
  }

  String _monthLabel() {
    return DateFormat(monthFormat ?? defaultMonthFormat).format(date);
  }

  String _weekDayLabel() {
    return DateFormat(weekDayFormat ?? defaultWeekDayFormat).format(date);
  }
}
