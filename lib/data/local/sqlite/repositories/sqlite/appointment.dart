import 'package:salus_gym/core/utils/color_parser.dart';
import 'package:salus_gym/data/local/sqlite/db.dart';

import 'package:salus_gym/data/models/appointment.dart';

class SqliteAppointmentRepository {
  Appointment _mapToAppointment(Map<String, Object?> map) {
    return Appointment(
      id: map['id'] as String,
      title: map['title'] as String,
      startTimeUtc: DateTime.fromMillisecondsSinceEpoch(
        map['start_time_utc'] as int,
        isUtc: true,
      ),
      durationInMinutes: map['duration_in_minutes'] as int,
      color: ColorParser.fromARGBString(map['color'] as String),
    );
  }

  Future<List<Appointment>> list() async {
    final db = await SqliteDB.instance;
    final List<Map<String, Object?>> maps = await db.query(
      'appointment',
      orderBy: 'start_time_utc',
    );

    return [for (final map in maps) _mapToAppointment(map)];
  }

  Future<List<Appointment>> listBetweenStartTimes(int begin, int end) async {
    final db = await SqliteDB.instance;
    final List<Map<String, Object?>> maps = await db.query(
      'appointment',
      where: 'start_time_utc >= ? AND start_time_utc < ?',
      whereArgs: [begin, end],
      orderBy: 'start_time_utc',
    );

    return [for (final map in maps) _mapToAppointment(map)];
  }

  Future<void> insert(Appointment appointment) async {
    final db = await SqliteDB.instance;
    await db.insert('appointment', appointment.toMap());
  }

  Future<void> update(Appointment appointment) async {
    final db = await SqliteDB.instance;
    await db.update(
      'appointment',
      appointment.toMap(),
      where: 'id = ?',
      whereArgs: [appointment.id],
    );
  }
}
