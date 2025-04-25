import 'package:flutter/material.dart';
import 'package:salus_gym/schedule/appointment.dart';

class DayCalendar extends StatelessWidget {
  final List<Appointment> appointments;
  final void Function(Appointment)? onAppointmentTap;

  const DayCalendar({
    super.key,
    required this.appointments,
    this.onAppointmentTap,
  });

  @override
  Widget build(BuildContext context) {
    final hourHeight = 70.0; // altura por hora

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: SizedBox(
            height: 24 * hourHeight,
            child: Stack(
              children: [
                _buildHourLines(hourHeight),
                ..._buildAppointments(hourHeight, constraints.maxWidth),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHourLines(double hourHeight) {
    return Column(
      children: List.generate(24, (index) {
        return Container(
          height: hourHeight,
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 60,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text('${index.toString().padLeft(2, '0')}:00'),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey.shade300)),
            ],
          ),
        );
      }),
    );
  }

  List<Widget> _buildAppointments(double hourHeight, double width) {
    return appointments.map((appointment) {
      final startMinutes =
          appointment.startTimeLocal.hour * 60 +
          appointment.startTimeLocal.minute;
      final endMinutes =
          appointment.endTimeLocal.hour * 60 + appointment.endTimeLocal.minute;
      final top = (startMinutes / 60) * hourHeight;
      final height = ((endMinutes - startMinutes) / 60) * hourHeight;

      return Positioned(
        top: top,
        left: 70, // deixa espaço para os horários
        right: 10,
        child: Container(
          height: height,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: appointment.color.withOpacity(0.8),
            borderRadius: BorderRadius.circular(6),
          ),
          child: TapRegion(
            child: Text(
              appointment.title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTapInside: (_) {
              if (onAppointmentTap != null) {
                onAppointmentTap!(appointment);
              }
            },
          ),
        ),
      );
    }).toList();
  }
}
