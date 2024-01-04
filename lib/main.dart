import 'package:expence_tracker/service/google_sheets_api.dart';
import 'package:expence_tracker/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleSheetsApi().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expence Tracker',
      home: HomePage(),
    );
  }
}
