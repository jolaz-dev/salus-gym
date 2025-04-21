import 'package:flutter/material.dart';

class Appointment {
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final Color color;

  Appointment({
    required this.title,
    required this.startTime,
    required this.endTime,
    this.color = Colors.blue,
  });
}
