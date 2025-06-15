import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'map.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'introPage.dart';
import 'services/notifications_services.dart';

class IntroPage1 extends StatefulWidget {
  const IntroPage1({super.key});

  @override
  State<IntroPage1> createState() => _IntroPage1State();
}

class _IntroPage1State extends State<IntroPage1> {
  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

 Future<void> _initNotifications() async {
  await notificationsService.initNotification();
  await notificationsService.scheduleNotification(
    id: 1,
    title: 'Recordatorio',
    body: '¡Tienes una cita pendiente hoy!',
    hour: 5,
    minute: 0,
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [Colors.purple, Colors.red, Colors.pink],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'lib/assets/logo.png',
                width: 300,
              )
                  .animate()
                  .fadeIn(
                      delay: const Duration(milliseconds: 500),
                      duration: const Duration(milliseconds: 1500)),

              const SizedBox(height: 2),
              const Text(
                'AC CONNECT',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontFamily: 'magistral',
                  fontWeight: FontWeight.w700,
                ),
              ).animate().fadeIn(
                  delay: const Duration(milliseconds: 700),
                  duration: const Duration(milliseconds: 1200)),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => MapScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white70,
                  foregroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  'iniciar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ).animate().fadeIn(
                  delay: const Duration(milliseconds: 900),
                  duration: const Duration(milliseconds: 1000)),
            ],
          ),
        ),
      ),
    );
  }
}
