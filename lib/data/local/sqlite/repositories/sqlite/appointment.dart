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
            'start_time_utc': startTimeUtc as int,
            'duration_in_minutes': durationInMinutes as int,
            'color': color as String,
          }
          in maps)
        Appointment(
          id: id,
          title: title,
          startTimeUtc: DateTime.fromMillisecondsSinceEpoch(
            startTimeUtc,
            isUtc: true,
          ),
          durationInMinutes: durationInMinutes,
          color: ColorParser.fromARGBString(color),
        ),
    ];
  }

  Future<List<Appointment>> listBetweenStartTimes(int begin, int end) async {
    final db = await SqliteDB.instance;
    final List<Map<String, Object?>> maps = await db.query(
      'appointment',
      where: 'start_time_utc >= ? AND start_time_utc < ?',
      whereArgs: [begin, end],
      orderBy: 'start_time_utc',
    );

    return [
      for (final {
            'id': id as String,
            'title': title as String,
            'start_time_utc': startTimeUtc as int,
            'duration_in_minutes': durationInMinutes as int,
            'color': color as String,
          }
          in maps)
        Appointment(
          id: id,
          title: title,
          startTimeUtc: DateTime.fromMillisecondsSinceEpoch(
            startTimeUtc,
            isUtc: true,
          ),
          durationInMinutes: durationInMinutes,
          color: ColorParser.fromARGBString(color),
        ),
    ];
  }
}
