import 'package:flutter/material.dart';
import 'package:salus_gym/schedule/day_calendar_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salus Gym',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Salus Gym')),
        body: DayCalendarView(),
      ),
    );
  }
}
