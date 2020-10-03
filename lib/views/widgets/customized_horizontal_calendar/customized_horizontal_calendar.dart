import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'customized_date_helper.dart';
import 'customized_date_widget.dart';

typedef DateBuilder = bool Function(DateTime dateTime);
// typedef BaseDateBuilder = List<DateTime> Function(DateTime dateTime);
typedef DateSelectionCallBack = void Function(DateTime dateTime);

class HorizontalCalendar extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final double height;
  final double dateWidth;
  final TextStyle monthTextStyle;
  final TextStyle selectedMonthTextStyle;
  final String monthFormat;
  final TextStyle dateTextStyle;
  final TextStyle selectedDateTextStyle;
  final String dateFormat;
  final TextStyle weekDayTextStyle;
  final TextStyle selectedWeekDayTextStyle;
  final TextStyle disabledMonthTextStyle;
  final TextStyle disabledDateTextStyle;
  final TextStyle disabledWeekDayTextStyle;
  final String weekDayFormat;
  final DateSelectionCallBack onDateSelected;
  final DateSelectionCallBack onDateLongTap;
  final DateSelectionCallBack onDateUnSelected;
  final VoidCallback onMaxDateSelectionReached;
  final Decoration defaultDecoration;
  final Decoration selectedDecoration;
  final Decoration disabledDecoration;
  final DateBuilder isDateDisabled;
  final DateTime initialSelectedDates;
  final ScrollController scrollController;
  final double spacingBetweenDates;
  final EdgeInsetsGeometry padding;
  final List<LabelType> labelOrder;
  final int minSelectedDateCount;
  final int maxSelectedDateCount;
  final bool isLabelUppercase;

  HorizontalCalendar({
    Key key,
    this.height = 100,
    this.dateWidth,
    @required this.firstDate,
    @required this.lastDate,
    this.scrollController,
    this.onDateSelected,
    this.onDateLongTap,
    this.onDateUnSelected,
    this.onMaxDateSelectionReached,
    this.minSelectedDateCount = 0,
    this.maxSelectedDateCount = 1,
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
    this.selectedDecoration,
    this.disabledDecoration,
    this.isDateDisabled,
    this.initialSelectedDates,
    this.spacingBetweenDates = 8.0,
    this.padding = const EdgeInsets.all(8.0),
    this.labelOrder = const [
      LabelType.month,
      LabelType.date,
      LabelType.weekday,
    ],
    this.isLabelUppercase = false,
  })  : assert(firstDate != null),
        assert(lastDate != null),
        assert(
          toDateMonthYear(lastDate) == toDateMonthYear(firstDate) ||
              toDateMonthYear(lastDate).isAfter(toDateMonthYear(firstDate)),
        ),
        assert(labelOrder != null && labelOrder.isNotEmpty,
            'Label Order should not be empty'),
        assert(minSelectedDateCount <= maxSelectedDateCount),
        // assert(minSelectedDateCount <= initialSelectedDates.length,
        //     "You must provide at least $minSelectedDateCount initialSelectedDates"),
        // assert(maxSelectedDateCount >= initialSelectedDates.length,
        //     "You can't provide more than $maxSelectedDateCount initialSelectedDates"),
        super(key: key);

  @override
  _HorizontalCalendarState createState() => _HorizontalCalendarState();
}

class _HorizontalCalendarState extends State<HorizontalCalendar> {
  final List<DateTime> allDates = [];
  final List<DateTime> selectedDates = [];

  void _scrollToBottom() {
    if (widget.scrollController.hasClients) {
      widget.scrollController.animateTo(
          widget.scrollController.position.maxScrollExtent - 85,
          duration: Duration(milliseconds: 1000),
          curve: Curves.elasticOut);
    } else {
      Timer(Duration(milliseconds: 400), () => _scrollToBottom());
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollToBottom();
    allDates.addAll(getDateList(widget.firstDate, widget.lastDate));
    selectedDates.add(toDateMonthYear(widget.initialSelectedDates));
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return Container(
      height: widget.height,
      child: Center(
        child: ListView.builder(
          controller: widget.scrollController ?? ScrollController(),
          scrollDirection: Axis.horizontal,
          itemCount: allDates.length,
          itemBuilder: (context, index) {
            final date = allDates[index];
            return Row(
              children: <Widget>[
                DateWidget(
                  key: Key(date.toIso8601String()),
                  height: widget.height,
                  width: widget.dateWidth,
                  padding: widget.padding,
                  isSelected: selectedDates.contains(date),
                  isDisabled: widget.isDateDisabled != null
                      ? widget.isDateDisabled(date)
                      : false,
                  date: date,
                  monthTextStyle: widget.monthTextStyle,
                  selectedMonthTextStyle: widget.selectedMonthTextStyle,
                  monthFormat: widget.monthFormat,
                  dateTextStyle: widget.dateTextStyle,
                  selectedDateTextStyle: widget.selectedDateTextStyle,
                  dateFormat: widget.dateFormat,
                  weekDayTextStyle: widget.weekDayTextStyle,
                  disabledMonthTextStyle: widget.disabledMonthTextStyle,
                  disabledDateTextStyle: widget.disabledDateTextStyle,
                  disabledWeekDayTextStyle: widget.disabledWeekDayTextStyle,
                  selectedWeekDayTextStyle: widget.selectedWeekDayTextStyle,
                  weekDayFormat: widget.weekDayFormat,
                  defaultDecoration: widget.defaultDecoration,
                  selectedDecoration: widget.selectedDecoration,
                  disabledDecoration: widget.disabledDecoration,
                  labelOrder: widget.labelOrder,
                  isLabelUppercase: widget.isLabelUppercase ?? false,
                  onTap: () {
                    if (!selectedDates.contains(date)) {
                      if (widget.maxSelectedDateCount == 1 &&
                          selectedDates.length == 1) {
                        selectedDates.clear();
                      } else if (widget.maxSelectedDateCount ==
                          selectedDates.length) {
                        if (widget.onMaxDateSelectionReached != null) {
                          widget.onMaxDateSelectionReached();
                        }
                        return;
                      }

                      selectedDates.add(date);
                      if (widget.onDateSelected != null) {
                        widget.onDateSelected(date);
                      }
                    } else if (selectedDates.length >
                        widget.minSelectedDateCount) {
                      final isRemoved = selectedDates.remove(date);
                      if (isRemoved && widget.onDateUnSelected != null) {
                        widget.onDateUnSelected(date);
                      }
                    }
                    setState(() {});
                  },
                  onLongTap: () => widget.onDateLongTap != null
                      ? widget.onDateLongTap(date)
                      : null,
                ),
                SizedBox(width: widget.spacingBetweenDates),
              ],
            );
          },
        ),
      ),
    );
  }
}
