import 'package:flutter/material.dart'; 
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'introPage.dart';
import 'services/notifications_services.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar zonas horarias
  tz.initializeTimeZones();

await notificationsService.initNotification(); 


  runApp(MyApp()); 
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: IntroPage1(),
    );
  }
}
