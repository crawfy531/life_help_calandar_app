
import 'package:flutter/material.dart';


class DateDropdownSelector extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime)? onDateChanged;

  const DateDropdownSelector({
    super.key,
    this.initialDate,
    this.onDateChanged,
  });

  @override
  _DateDropdownSelectorState createState() => _DateDropdownSelectorState();
}

class _DateDropdownSelectorState extends State<DateDropdownSelector> {
  late int selectedYear;
  late int selectedMonth;
  late int selectedDay;

  @override
  void initState() {
    super.initState();
    final init = widget.initialDate ?? DateTime.now();
    selectedYear = init.year;
    selectedMonth = init.month;
    selectedDay = init.day;
  }

  void notifyDateChanged() {
    final newDate = DateTime(selectedYear, selectedMonth, selectedDay);
    widget.onDateChanged?.call(newDate);
  }

  List<int> getYears() => List.generate(100, (i) => DateTime.now().year + i);
  List<int> getMonths() => List.generate(12, (i) => i + 1);
  int daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;
  List<int> getDays(int year, int month) =>
      List.generate(daysInMonth(year, month), (i) => i + 1);

  @override
  Widget build(BuildContext context) {
    final dayOptions = getDays(selectedYear, selectedMonth);
    if (selectedDay > dayOptions.length) selectedDay = dayOptions.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Month
        DropdownButton<int>(
          value: selectedMonth,
          onChanged: (value) {
            setState(() {
              selectedMonth = value!;
              notifyDateChanged();
            });
          },
          items: getMonths().map((month) => DropdownMenuItem(
            value: month,
            child: Text(month.toString()),
          )).toList(),
        ),
        SizedBox(width: 10),

        // Day
        DropdownButton<int>(
          value: selectedDay,
          onChanged: (value) {
            setState(() {
              selectedDay = value!;
              notifyDateChanged();
            });
          },
          items: dayOptions.map((day) => DropdownMenuItem(
            value: day,
            child: Text(day.toString()),
          )).toList(),
        ),
        SizedBox(width: 10),

        // Year
        DropdownButton<int>(
          value: selectedYear,
          onChanged: (value) {
            setState(() {
              selectedYear = value!;
              notifyDateChanged();
            });
          },
          items: getYears().map((year) => DropdownMenuItem(
            value: year,
            child: Text(year.toString()),
          )).toList(),
        ),
      ],
    );
  }
}
