import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salus_gym/data/local/sqlite/repositories/sqlite/appointment.dart';
import 'package:salus_gym/data/models/appointment.dart';
import 'package:salus_gym/schedule/appointment_form.dart';
import 'package:salus_gym/schedule/day_calendar.dart';

class DayCalendarView extends StatefulWidget {
  const DayCalendarView({super.key});

  @override
  State<DayCalendarView> createState() => _DayCalendarViewState();
}

class _DayCalendarViewState extends State<DayCalendarView> {
  late DateTime selectedDate;

  DateTime _toStartOfDay(DateTime date) {
    return date.copyWith(
      hour: 0,
      minute: 0,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );
  }

  late Future<List<Appointment>> futureAppointments;

  @override
  void initState() {
    super.initState();
    selectedDate = _toStartOfDay(DateTime.now());
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

  Future<void> _createAppointment() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: AppointmentForm(
              onSubmit: (appointment) async {
                final repo = SqliteAppointmentRepository();
                await repo.insert(appointment);
                Navigator.of(context).pop(); // fecha o modal
                _loadAppointments(selectedDate); // recarrega os compromissos
              },
              appointment: Appointment(
                id: '',
                title: '',
                startTimeUtc: selectedDate.add(Duration(hours: 9)).toUtc(),
                durationInMinutes: 60,
                color: Colors.blue,
              ),
            ),
          ),
    );
  }

  Future<void> _editAppointment(Appointment appointment) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: AppointmentForm(
              appointment: appointment,
              onSubmit: (updated) async {
                final repo = SqliteAppointmentRepository();
                await repo.update(updated);
                Navigator.of(context).pop();
                _loadAppointments(_toStartOfDay(updated.startTimeLocal));
              },
            ),
          ),
    );
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
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _createAppointment,
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right),
                    onPressed: _goToNextDay,
                  ),
                ],
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
              return DayCalendar(
                appointments: snapshot.data!,
                onAppointmentTap: _editAppointment,
              );
            },
          ),
        ),
      ],
    );
  }
}
