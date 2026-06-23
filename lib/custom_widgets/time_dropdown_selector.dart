
import 'package:flutter/material.dart';



class TimeDropdown extends StatefulWidget {
  final void Function(DateTime) onTimeSelected;
  final DateTime? initialTime;

  const TimeDropdown({
    required this.onTimeSelected,
    this.initialTime,
    super.key,
  });

  @override
  _TimeDropdownState createState() => _TimeDropdownState();
}

class _TimeDropdownState extends State<TimeDropdown> {
  late int selectedHour;
  late int selectedMinute;
  late String selectedPeriod;

  final List<int> hours = List.generate(12, (i) => i + 1);      // 1–12
  final List<int> minutes = List.generate(60, (i) => i);        // 0–59
  final List<String> periods = ['AM', 'PM'];

  @override
  void initState() {
    super.initState();

    if (widget.initialTime != null) {
      final time = TimeOfDay.fromDateTime(widget.initialTime!);
      selectedHour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      selectedMinute = time.minute;
      selectedPeriod = time.period == DayPeriod.am ? 'AM' : 'PM';
    } else {
      selectedHour = 12;
      selectedMinute = 0;
      selectedPeriod = 'AM';
    }

    _notifyParent(); // Notify parent with initial selection
  }

  void _notifyParent() {
    int hour24 = selectedHour % 12;
    if (selectedPeriod == 'PM') hour24 += 12;
    if (selectedPeriod == 'AM' && selectedHour == 12) hour24 = 0;

    DateTime time = DateTime(0, 1, 1, hour24, selectedMinute);
    widget.onTimeSelected(time);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Hour
        DropdownButton<int>(
          value: selectedHour,
          onChanged: (val) {
            setState(() => selectedHour = val!);
            _notifyParent();
          },
          items: hours.map((h) {
            return DropdownMenuItem<int>(
              value: h,
              child: Text(h.toString().padLeft(2, '0')),
            );
          }).toList(),
        ),

        const Text(':'),

        // Minute
        DropdownButton<int>(
          value: selectedMinute,
          onChanged: (val) {
            setState(() => selectedMinute = val!);
            _notifyParent();
          },
          items: minutes.map((m) {
            return DropdownMenuItem<int>(
              value: m,
              child: Text(m.toString().padLeft(2, '0')),
            );
          }).toList(),
        ),

        const SizedBox(width: 8),

        // AM/PM
        DropdownButton<String>(
          value: selectedPeriod,
          onChanged: (val) {
            setState(() => selectedPeriod = val!);
            _notifyParent();
          },
          items: periods.map((p) {
            return DropdownMenuItem<String>(
              value: p,
              child: Text(p),
            );
          }).toList(),
        ),
      ],
    );
  }
}