import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:salus_gym/app.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WindowManager.instance.ensureInitialized();
  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitle('Salus Gym');
  });
  initializeDateFormatting('pt_BR', null);
  runApp(const MyApp());
}
