import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DashboardScreenContent();
  }
}

class _DashboardScreenContent extends StatefulWidget {
  const _DashboardScreenContent({Key? key}) : super(key: key);

  @override
  State<_DashboardScreenContent> createState() => _DashboardScreenContentState();
}

class _DashboardScreenContentState extends State<_DashboardScreenContent> {
  static const Color primaryPurple = Colors.purple;
  static const Color primaryRed = Colors.red;
  static const Color primaryPink = Colors.pink;

  String selectedZone = 'Todas las zonas';
  String selectedPerformance = 'Todos los rendimientos';
  
  final List<String> zonas = [
    'Todas las zonas',
    'Centro Monterrey',
    'San Pedro Garza García',
    'Santa Catarina',
    'San Nicolás',
    'Guadalupe',
    'Apodaca'
  ];
  
  final List<Map<String, String>> performanceFilters = [
    {'label': 'Todos los rendimientos', 'value': 'Todos los rendimientos'},
    {'label': 'NPS Alto (>90)', 'value': 'nps_high'},
    {'label': 'NPS Medio (70-90)', 'value': 'nps_medium'},
    {'label': 'NPS Bajo (<70)', 'value': 'nps_low'},
    {'label': 'Fill Rate Alto (>95%)', 'value': 'fill_high'},
    {'label': 'Fill Rate Medio (85-95%)', 'value': 'fill_medium'},
    {'label': 'Fill Rate Bajo (<85%)', 'value': 'fill_low'},
  ];

  // Datos de ejemplo basados en script.py
  final List<Map<String, dynamic>> puntosVenta = [
    // Centro Monterrey - Tiendas con buen rendimiento
    {
      'nombre': 'OXXO Centro',
      'geometry': {'lat': 25.6866, 'lng': -100.3161},
      'zonaGeografica': 'Centro Monterrey',
      'estado': 'Activo',
      'tipoNegocio': 'Tienda de Conveniencia',
      'nps': 92,
      'fillRate': 97.5,
      'damageRate': 0.8,
      'ultimaVisita': '15/03/2024',
      'especialista': 'Juan Pérez',
    },
    {
      'nombre': 'OXXO Centro 2',
      'geometry': {'lat': 25.6766, 'lng': -100.3061},
      'zonaGeografica': 'Centro Monterrey',
      'estado': 'Activo',
      'tipoNegocio': 'Tienda de Conveniencia',
      'nps': 95,
      'fillRate': 98.0,
      'damageRate': 0.5,
      'ultimaVisita': '14/03/2024',
      'especialista': 'Juan Pérez',
    },
    // San Pedro - Tiendas con rendimiento medio
    {
      'nombre': 'OXXO San Pedro',
      'geometry': {'lat': 25.6586, 'lng': -100.3778},
      'zonaGeografica': 'San Pedro Garza García',
      'estado': 'Activo',
      'tipoNegocio': 'Tienda de Conveniencia',
      'nps': 85,
      'fillRate': 92.0,
      'damageRate': 1.2,
      'ultimaVisita': '13/03/2024',
      'especialista': 'María García',
    },
    {
      'nombre': 'OXXO San Pedro 2',
      'geometry': {'lat': 25.6486, 'lng': -100.3678},
      'zonaGeografica': 'San Pedro Garza García',
      'estado': 'Activo',
      'tipoNegocio': 'Tienda de Conveniencia',
      'nps': 88,
      'fillRate': 93.5,
      'damageRate': 1.0,
      'ultimaVisita': '12/03/2024',
      'especialista': 'María García',
    },
    // Santa Catarina - Tiendas con rendimiento bajo
    {
      'nombre': 'OXXO Santa Catarina',
      'geometry': {'lat': 25.6736, 'lng': -100.4586},
      'zonaGeografica': 'Santa Catarina',
      'estado': 'Activo',
      'tipoNegocio': 'Tienda de Conveniencia',
      'nps': 65,
      'fillRate': 82.0,
      'damageRate': 2.5,
      'ultimaVisita': '11/03/2024',
      'especialista': 'Carlos Rodríguez',
    },
    {
      'nombre': 'OXXO Santa Catarina 2',
      'geometry': {'lat': 25.6836, 'lng': -100.4486},
      'zonaGeografica': 'Santa Catarina',
      'estado': 'Activo',
      'tipoNegocio': 'Tienda de Conveniencia',
      'nps': 68,
      'fillRate': 84.5,
      'damageRate': 2.2,
      'ultimaVisita': '10/03/2024',
      'especialista': 'Carlos Rodríguez',
    },
    // San Nicolás - Mezcla de rendimientos
    {
      'nombre': 'OXXO San Nicolás',
      'geometry': {'lat': 25.7417, 'lng': -100.3022},
      'zonaGeografica': 'San Nicolás',
      'estado': 'Activo',
      'tipoNegocio': 'Tienda de Conveniencia',
      'nps': 91,
      'fillRate': 96.0,
      'damageRate': 0.9,
      'ultimaVisita': '09/03/2024',
      'especialista': 'Juan Pérez',
    },
    {
      'nombre': 'OXXO San Nicolás 2',
      'geometry': {'lat': 25.7517, 'lng': -100.2922},
      'zonaGeografica': 'San Nicolás',
      'estado': 'Activo',
      'tipoNegocio': 'Tienda de Conveniencia',
      'nps': 75,
      'fillRate': 88.0,
      'damageRate': 1.8,
      'ultimaVisita': '08/03/2024',
      'especialista': 'Juan Pérez',
    },
    // Guadalupe - Mezcla de rendimientos
    {
      'nombre': 'OXXO Guadalupe',
      'geometry': {'lat': 25.6775, 'lng': -100.2597},
      'zonaGeografica': 'Guadalupe',
      'estado': 'Activo',
      'tipoNegocio': 'Tienda de Conveniencia',
      'nps': 94,
      'fillRate': 97.0,
      'damageRate': 0.7,
      'ultimaVisita': '07/03/2024',
      'especialista': 'María García',
    },
    {
      'nombre': 'OXXO Guadalupe 2',
      'geometry': {'lat': 25.6875, 'lng': -100.2697},
      'zonaGeografica': 'Guadalupe',
      'estado': 'Activo',
      'tipoNegocio': 'Tienda de Conveniencia',
      'nps': 72,
      'fillRate': 86.0,
      'damageRate': 2.0,
      'ultimaVisita': '06/03/2024',
      'especialista': 'María García',
    },
  ];

  List<Map<String, dynamic>> get filteredPuntosVenta {
    print('Filtrando puntos de venta:');
    print('Zona seleccionada: $selectedZone');
    print('Rendimiento seleccionado: $selectedPerformance');
    
    final filtered = puntosVenta.where((punto) {
      bool matchesZone = selectedZone == 'Todas las zonas' || 
                        punto['zonaGeografica'] == selectedZone;
      
      bool matchesPerformance = selectedPerformance == 'Todos los rendimientos';
      if (selectedPerformance != 'Todos los rendimientos') {
        switch (selectedPerformance) {
          case 'nps_high':
            matchesPerformance = punto['nps'] > 90;
            break;
          case 'nps_medium':
            matchesPerformance = punto['nps'] >= 70 && punto['nps'] <= 90;
            break;
          case 'nps_low':
            matchesPerformance = punto['nps'] < 70;
            break;
          case 'fill_high':
            matchesPerformance = punto['fillRate'] > 95;
            break;
          case 'fill_medium':
            matchesPerformance = punto['fillRate'] >= 85 && punto['fillRate'] <= 95;
            break;
          case 'fill_low':
            matchesPerformance = punto['fillRate'] < 85;
            break;
        }
      }
      
      print('Evaluando punto: ${punto['nombre']}');
      print('- Zona: ${punto['zonaGeografica']} (matches: $matchesZone)');
      print('- NPS: ${punto['nps']}, Fill Rate: ${punto['fillRate']} (matches: $matchesPerformance)');
      
      return matchesZone && matchesPerformance;
    }).toList();
    
    print('Total de puntos filtrados: ${filtered.length}');
    print('Puntos que pasaron el filtro:');
    for (var punto in filtered) {
      print('- ${punto['nombre']} (${punto['zonaGeografica']})');
    }
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard Arca Continental',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'magistral',
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [primaryPurple, primaryRed, primaryPink],
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilters(),
            _buildSectionTitle('Resumen General'),
            _buildKPICards(),
            _buildSectionTitle('Distribución Geográfica'),
            _buildMapSection(),
            _buildSectionTitle('Análisis por Zona'),
            _buildDistributionCharts(),
            _buildSectionTitle('Rendimiento de Especialistas'),
            _buildSpecialistMetrics(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filtros',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Helvetica',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedZone,
                  decoration: InputDecoration(
                    labelText: 'Zona Geográfica',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: zonas.map((String zona) {
                    return DropdownMenuItem<String>(
                      value: zona,
                      child: Text(
                        zona,
                        style: const TextStyle(
                          fontFamily: 'Helvetica',
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedZone = newValue;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedPerformance,
                  decoration: InputDecoration(
                    labelText: 'Rendimiento',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: performanceFilters.map((Map<String, String> filter) {
                    return DropdownMenuItem<String>(
                      value: filter['value'],
                      child: Text(
                        filter['label']!,
                        style: const TextStyle(
                          fontFamily: 'Helvetica',
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedPerformance = newValue;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Helvetica',
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 40,
            height: 3,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryPurple, primaryRed],
              ),
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPICards() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 325,
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 10,
          childAspectRatio: 1.5,
          children: [
            _buildKPICard(
              'NPS Promedio',
              '85',
              'Satisfacción del Cliente',
              Icons.sentiment_satisfied_alt,
              primaryPurple,
            ),
            _buildKPICard(
              'Fill Rate',
              '95.5%',
              'Inventario Completo',
              Icons.inventory,
              primaryRed,
            ),
            _buildKPICard(
              'Damage Rate',
              '1.2%',
              'Productos Dañados',
              Icons.warning,
              primaryPink,
            ),
            _buildKPICard(
              'Puntos Activos',
              '75%',
              'Tiendas Operativas',
              Icons.store,
              Colors.deepPurple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKPICard(String title, String value, String subtitle, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontFamily: 'Helvetica',
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
                fontFamily: 'Helvetica',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
                fontFamily: 'Helvetica',
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    final filteredPuntos = filteredPuntosVenta;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'El mapa muestra la distribución de puntos de venta ${selectedZone != 'Todas las zonas' ? 'en $selectedZone' : 'en el área metropolitana de Monterrey'}. '
            'Cada marcador representa una tienda, permitiendo visualizar la cobertura y densidad de la red de ventas.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontFamily: 'Helvetica',
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 300,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(77),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: Stack(
              children: [
                FlutterMap(
                  options: const MapOptions(
                    initialCenter: LatLng(25.6866, -100.3161),
                    initialZoom: 12,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.rulfoapp',
                    ),
                    MarkerLayer(
                      markers: filteredPuntos.map((punto) {
                        return Marker(
                          point: LatLng(
                            punto['geometry']['lat'],
                            punto['geometry']['lng'],
                          ),
                          width: 40,
                          height: 40,
                          child: Tooltip(
                            message: '${punto['nombre']}\nNPS: ${punto['nps']}\nÚltima visita: ${punto['ultimaVisita']}',
                            child: Icon(
                              Icons.location_on,
                              color: primaryPurple,
                              size: 40,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Card(
                    elevation: 4,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Leyenda',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryPurple,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on, color: primaryPurple, size: 20),
                              const SizedBox(width: 4),
                              const Text('Punto de Venta'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDistributionCharts() {
    final filteredPuntos = filteredPuntosVenta;
    // Calcular distribución basada en los puntos filtrados
    final Map<String, double> zonaDistribution = {};
    for (var punto in filteredPuntos) {
      final zona = punto['zonaGeografica'];
      zonaDistribution[zona] = (zonaDistribution[zona] ?? 0) + 1;
    }
    
    // Convertir a porcentajes
    final total = filteredPuntos.length;
    final sections = zonaDistribution.entries.map((entry) {
      final percentage = (entry.value / total * 100).round();
      return PieChartSectionData(
        value: entry.value,
        title: '${entry.key}\n$percentage%',
        color: _getColorForZona(entry.key),
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Helvetica',
        ),
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Este gráfico muestra la distribución de puntos de venta por zona geográfica${selectedPerformance != 'Todos los rendimientos' ? ' según el filtro de rendimiento seleccionado' : ''}.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontFamily: 'Helvetica',
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: PieChart(
              PieChartData(
                sections: sections,
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                startDegreeOffset: -90,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForZona(String zona) {
    switch (zona) {
      case 'Centro Monterrey':
        return primaryPurple;
      case 'San Pedro Garza García':
        return primaryRed;
      case 'Santa Catarina':
        return primaryPink;
      default:
        return Colors.deepPurple;
    }
  }

  Widget _buildSpecialistMetrics() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'El gráfico muestra el rendimiento de cada especialista basado en el NPS promedio '
            'de sus puntos de venta asignados, permitiendo identificar áreas de oportunidad y mejores prácticas.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: 85,
                        color: primaryPurple,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: 92,
                        color: primaryRed,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(
                        toY: 78,
                        color: primaryPink,
                      ),
                    ],
                  ),
                ],
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const titles = ['Juan', 'María', 'Carlos'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            titles[value.toInt()],
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}