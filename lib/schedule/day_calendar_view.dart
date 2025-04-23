import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salus_gym/data/local/sqlite/repositories/sqlite/appointment.dart';
import 'package:salus_gym/schedule/appointment.dart';
import 'package:salus_gym/schedule/day_calendar.dart';

class DayCalendarView extends StatefulWidget {
  const DayCalendarView({super.key});

  @override
  _DayCalendarViewState createState() => _DayCalendarViewState();
}

class _DayCalendarViewState extends State<DayCalendarView> {
  DateTime selectedDate = DateTime.now();
  late Future<List<Appointment>> futureAppointments;

  @override
  void initState() {
    super.initState();
    final repo = SqliteAppointmentRepository();
    futureAppointments = repo.list();
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
          child: FutureBuilder<List<Appointment>>(
            future: futureAppointments,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Erro ao carregar agenda'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text('Nenhuma entrada encontrada na agenda'),
                );
              }
              return DayCalendar(appointments: snapshot.data!);
            },
          ),
        ),
      ],
    );
  }
}
