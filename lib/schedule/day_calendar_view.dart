import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salus_gym/schedule/appointment.dart';
import 'package:salus_gym/schedule/day_calendar.dart';

class DayCalendarView extends StatefulWidget {
  const DayCalendarView({super.key});

  @override
  _DayCalendarViewState createState() => _DayCalendarViewState();
}

class _DayCalendarViewState extends State<DayCalendarView> {
  DateTime selectedDate = DateTime.now();

  List<Appointment> getAppointmentsForDate(DateTime date) {
    final today = DateTime(date.year, date.month, date.day);
    if (date.day == DateTime.now().day) {
      return [
        Appointment(
          title: 'Reunião de Equipe',
          startTime: today.add(const Duration(hours: 9)),
          endTime: today.add(const Duration(hours: 10, minutes: 30)),
          color: Colors.orange,
        ),
        Appointment(
          title: 'Almoço com Cliente',
          startTime: today.add(const Duration(hours: 12)),
          endTime: today.add(const Duration(hours: 13)),
          color: Colors.green,
        ),
        Appointment(
          title: 'Desenvolvimento Feature X',
          startTime: today.add(const Duration(hours: 14)),
          endTime: today.add(const Duration(hours: 16)),
          color: Colors.blue,
        ),
        Appointment(
          title: 'Café Rápido',
          startTime: today.add(
            const Duration(hours: 15, minutes: 30),
          ), // Sobreposição
          endTime: today.add(const Duration(hours: 16, minutes: 15)),
          color: Colors.purple,
        ),
        Appointment(
          title: 'Planejamento Sprint',
          startTime: today.add(const Duration(hours: 16, minutes: 30)),
          endTime: today.add(const Duration(hours: 17, minutes: 30)),
          color: Colors.redAccent,
        ),
      ];
    }
    return [];
  }

  void _goToPreviousDay() {
    setState(() {
      selectedDate = selectedDate.subtract(Duration(days: 1));
    });
  }

  void _goToNextDay() {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat(
      'EEEE, d \'de\' MMMM \'de\' y',
      'pt_BR',
    ).format(selectedDate);

    return Column(
      children: [
        Container(
          color: Colors.grey[100],
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left),
                onPressed: _goToPreviousDay,
              ),
              Expanded(
                child: Text(
                  formattedDate,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: _goToNextDay,
              ),
            ],
          ),
        ),
        Expanded(
          child: DayCalendar(
            appointments: getAppointmentsForDate(selectedDate),
          ),
        ),
      ],
    );
  }
}
