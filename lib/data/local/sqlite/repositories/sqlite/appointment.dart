import 'package:intl/intl.dart';
import 'package:salus_gym/core/utils/color_parser.dart';
import 'package:salus_gym/data/local/sqlite/db.dart';

import 'package:salus_gym/schedule/appointment.dart';

class SqliteAppointmentRepository {
  Future<List<Appointment>> list() async {
    final db = await SqliteDB.instance;
    final List<Map<String, Object?>> maps = await db.query(
      'appointment',
      orderBy: 'start_time_utc',
    );

    return [
      for (final {
            'id': id as String,
            'title': title as String,
            'start_time_utc': startTimeUtc as String,
            'duration_in_minutes': durationInMinutes as int,
            'color': color as String,
          }
          in maps)
        Appointment(
          id: id,
          title: title,
          startTime:
              DateFormat('yyyy-MM-ddTHH:mm').parseUTC(startTimeUtc).toLocal(),
          durationInMinutes: durationInMinutes,
          color: ColorParser.fromARGBString(color),
        ),
    ];
  }
}
