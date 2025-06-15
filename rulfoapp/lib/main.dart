import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rulfoapp/EntrevistaPage.dart';
import 'package:rulfoapp/pages/GuiaActitudPage.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'introPage.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      home: IntroPage1(),
      routes: {
        '/guia-actitud': (context) => const GuiaActitudPage(),
        '/entrevista': (context) => const EntrevistaPage(),
      },
    );
  }
}
