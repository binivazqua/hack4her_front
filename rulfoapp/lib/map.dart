import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rulfoapp/models/NotificationItem.dart';
import 'appointment.dart';
import 'dashboardScreen.dart';

class Lugar {
  final String nombre;
  final String direccion;
  final int visitas;
  final String imagenUrl;

  Lugar(this.nombre, this.direccion, this.visitas, this.imagenUrl);
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final List<String> points = [
    'POINT (-100.2998256, 25.6244792)',
    'POINT (-100.2896037, 25.6538224)',
    'POINT (-100.2756426, 25.6535732)',
    'POINT (-100.3031637, 25.6734108)',
    'POINT (-100.3216174, 25.6597296)',
    'POINT (-100.2942107, 25.6553848)',
  ];

  // liSTA DE NOTIFICACIONES DUMMY
  final List<NotificationItem> dummyNotifications = [
    NotificationItem(
      title: 'Recordatorio de visita',
      body: 'Tienes una cita con la Dra. López el 15 de junio a las 4:30 PM.',
      date: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    NotificationItem(
      title: 'Actualización de información',
      body:
          'Tu perfil médico fue actualizado con los últimos resultados de EMG.',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    NotificationItem(
      title: 'Seguimiento pendiente',
      body:
          'No olvides completar el cuestionario de seguimiento antes del viernes.',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  final List<Lugar> lugares = [
    Lugar(
      'OXXO Paseo Acueducto', //si
      'Roma Sur, 64700 Monterrey, N.L',
      2,
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTkrn9PLqb-Ok3_Tt51N7PhDxXvi3FWM5Dbsg&s',
    ),
    Lugar(
      'Oxxo Junco de la Vega',
      'Calle Hidalgo 456',
      3,
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTkrn9PLqb-Ok3_Tt51N7PhDxXvi3FWM5Dbsg&s',
    ),
    Lugar(
      'Plaza Nuevo Sur', //no
      'Av. Vallarta 789',
      2,
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTkrn9PLqb-Ok3_Tt51N7PhDxXvi3FWM5Dbsg&s',
    ),
    Lugar(
      'Oxxo COLIMA II', //si
      'Insurgentes Sur 321',
      1,
      'https://i0.wp.com/www.colimanoticias.com/wp-content/uploads/2018/04/OXXO-noche.jpg?fit=924%2C600&ssl=1',
    ),
    Lugar(
      'Oxxo Av. Eugenio', //no
      'Blvd. López Mateos 567',
      4,
      'https://i0.wp.com/www.colimanoticias.com/wp-content/uploads/2018/04/OXXO-noche.jpg?fit=924%2C600&ssl=1',
    ),
    Lugar(
      'Oxxo Nueva Independencia', //no
      'Av. Tulum 890',
      0,
      'https://i0.wp.com/www.colimanoticias.com/wp-content/uploads/2018/04/OXXO-noche.jpg?fit=924%2C600&ssl=1',
    ),
  ];

  Lugar? selectedLugar;

  List<LatLng> parsedPoints(List<String> points) {
    return points.map((pointStr) {
      String cleaned = pointStr.replaceAll("POINT (", "").replaceAll(")", "");
      List<String> coords = cleaned.split(',');
      double lon = double.parse(coords[0].trim());
      double lat = double.parse(coords[1].trim());
      return LatLng(lat, lon);
    }).toList();
  }

  @override
  void initState() {
    super.initState();

    // Simula una notificación al arrancar
    Future.delayed(const Duration(seconds: 1), () {
      showSimpleNotification(
        const Text("Recordatorio de visita"),
        subtitle: const Text(
          "Tienes una visita programada a Oxxo Av. Eugenio el 15 de junio a las 4:30 PM.",
        ),
        background: Colors.indigo,
        leading: const Icon(Icons.calendar_today, color: Colors.white),
        duration: const Duration(seconds: 4),
      );
    });

    // Otra más tarde
    Future.delayed(const Duration(seconds: 4), () {
      showSimpleNotification(
        const Text("Actualización de información"),
        subtitle: const Text(
          "El historial de Oxxo Nueva Independencia tiene nuevos comentarios.",
        ),
        background: Colors.teal,
        leading: const Icon(Icons.update, color: Colors.white),
        duration: const Duration(seconds: 4),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<LatLng> coordinates = parsedPoints(points);
    final initialCenter = coordinates.isNotEmpty
        ? coordinates[0]
        : LatLng(25.65, -100.30);

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              MarkerLayer(
                markers: List.generate(coordinates.length, (index) {
                  final lugar = lugares[index];
                  return Marker(
                    point: coordinates[index],
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedLugar = lugar;
                        });
                      },
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.redAccent,
                        size: 40,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),

          if (selectedLugar != null)
            Positioned(
              top: 50,
              left: 100,
              right: 100,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          selectedLugar!.imagenUrl,
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedLugar!.nombre,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              selectedLugar!.direccion,
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${selectedLugar!.visitas} visitas',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  alignment: Alignment.centerLeft,
                                ),
                                onPressed: () {
                                  setState(() {
                                    selectedLugar = null;
                                  });
                                },
                                child: const Text(
                                  'Cerrar',
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: lugares.length,
                itemBuilder: (context, index) {
                  final lugar = lugares[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.98),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [BoxShadow(color: Colors.black)],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    lugar.nombre,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.store_mall_directory_outlined,
                                  size: 30,
                                  color: Colors.redAccent,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    lugar.direccion,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.visibility,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${lugar.visitas} visitas',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {}
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AppointmentScreen()),
            );
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DashboardScreen()),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'citas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_sharp),
            label: 'dashboard',
          ),
        ],
      ),
    );
  }
}
