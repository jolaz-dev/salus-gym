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
  DateTime selectedDate = DateTime.now().copyWith(
    hour: 0,
    minute: 0,
    second: 0,
    millisecond: 0,
    microsecond: 0,
  );
  late Future<List<Appointment>> futureAppointments;

  @override
  void initState() {
    super.initState();
    _loadAppointments(selectedDate);
  }

  void _loadAppointments(DateTime date) {
    final repo = SqliteAppointmentRepository();
    final beginStartTime = date.toUtc().millisecondsSinceEpoch;
    final endStartTime =
        date.add(Duration(days: 1)).toUtc().millisecondsSinceEpoch;

    setState(() {
      selectedDate = date;
      futureAppointments = repo.listBetweenStartTimes(
        beginStartTime,
        endStartTime,
      );
    });
  }

  void _goToPreviousDay() {
    final newDate = selectedDate.subtract(Duration(days: 1));
    _loadAppointments(newDate);
  }

  void _goToNextDay() {
    final newDate = selectedDate.add(Duration(days: 1));
    _loadAppointments(newDate);
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
