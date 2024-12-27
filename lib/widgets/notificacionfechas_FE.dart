import 'package:fepi_local/constansts/app_colors.dart';
import 'package:fepi_local/constansts/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para manejar y formatear fechas

class ActividadesTable extends StatelessWidget {
  // Este es el mapa de actividades
  final Map<String, Map<String, String>> actividades = {
    'Actividad 1': {'Descripcion': 'Descripcion de la actividad 1', 'Fecha': '2024-12-20', 'Estado': 'activo'},
    'Actividad 2': {'Descripcion': 'Descripcion de la actividad 2', 'Fecha': '2024-12-15', 'Estado': 'inactivo'},
    'Actividad 3': {'Descripcion': 'Descripcion de la actividad 3', 'Fecha': '2024-12-15', 'Estado': 'activo'},
    'Actividad 4': {'Descripcion': 'Descripcion de la actividad 4', 'Fecha': '2020-01-05', 'Estado': 'activo'},
    'Actividad 5': {'Descripcion': 'Descripcion de la actividad 3', 'Fecha': '2025-02-04', 'Estado': 'activo'},
    'Actividad 6': {'Descripcion': '', 'Fecha': '2025-02-05', 'Estado': 'activo'},
  };

  @override
  Widget build(BuildContext context) {
    // Convertir el mapa en una lista de mapas para poder ordenarlo por fecha
    List<MapEntry<String, Map<String, String>>> listaActividades = actividades.entries.toList();
    
    // Ordenar la lista de actividades por la fecha más próxima
    listaActividades.sort((a, b) {
      DateTime fechaA = DateFormat('yyyy-MM-dd').parse(a.value['Fecha']!);
      DateTime fechaB = DateFormat('yyyy-MM-dd').parse(b.value['Fecha']!);
      return fechaA.compareTo(fechaB);
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: listaActividades.where((actividad) => actividad.value['Estado'] == 'activo').map((actividad) {
            DateTime fechaActividad = DateFormat('yyyy-MM-dd').parse(actividad.value['Fecha']!);
            bool fechaPasada = fechaActividad.isBefore(DateTime.now());
            return Card(
              color: fechaPasada ? AppColors.color4 : AppColors.color1, // Cambiar color si la fecha ya pasó
              margin: const EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    Text(
                      actividad.key,
                      style: AppTextStyles.secondBold(color: AppColors.color2)
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Fecha: ${actividad.value['Fecha']!}',
                      style: AppTextStyles.secondRegular(fontSize: 15),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      actividad.value['Descripcion']!,
                      style: AppTextStyles.secondRegular(color: AppColors.color2),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ActividadesTable(),
  ));
}
