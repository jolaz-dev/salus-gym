import 'package:flutter/material.dart';
import 'package:salus_gym/core/utils/color_parser.dart';

class Appointment {
  final String id;
  final String title;
  final DateTime startTimeUtc;
  final int durationInMinutes;
  final Color color;

  Appointment({
    required this.id,
    required this.title,
    required this.startTimeUtc,
    required this.durationInMinutes,
    required this.color,
  });

  DateTime get startTimeLocal => startTimeUtc.toLocal();
  DateTime get endTimeUtc =>
      startTimeUtc.add(Duration(minutes: durationInMinutes));
  DateTime get endTimeLocal => endTimeUtc.toLocal();

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'start_time_utc': startTimeUtc.millisecondsSinceEpoch,
      'duration_in_minutes': durationInMinutes,
      'color': ColorParser.toARGBString(color),
    };
  }
}
