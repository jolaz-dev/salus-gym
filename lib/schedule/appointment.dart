import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salus_gym/core/utils/color_parser.dart';

class Appointment {
  final String id;
  final String title;
  final DateTime startTime;
  final int durationInMinutes;
  final Color color;

  Appointment({
    required this.id,
    required this.title,
    required this.startTime,
    required this.durationInMinutes,
    required this.color,
  });

  DateTime get endTime => startTime.add(Duration(minutes: durationInMinutes));

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'start_time_utc': DateFormat('yyyy-MM-ddTHH:mm').format(startTime),
      'duration_in_minutes': durationInMinutes,
      'color': ColorParser.toARGBString(color),
    };
  }
}
