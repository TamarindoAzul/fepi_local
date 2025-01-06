import 'package:fepi_local/database/database_gestor.dart';
import 'package:flutter/material.dart';

class ActividadCardWidget extends StatefulWidget {
  final List<Map<String, dynamic>> actividades;

  const ActividadCardWidget({Key? key, required this.actividades})
      : super(key: key);

  @override
  _ActividadCardWidgetState createState() => _ActividadCardWidgetState();
}

class _ActividadCardWidgetState extends State<ActividadCardWidget> {
  // Función para generar el mapa con los datos del reporte
  Map<String, dynamic> _crearReporte(Map<String, dynamic> actividad, String reporte) {
    return {
      'id_ActCAP': actividad['id_ActCAP'],  // Asegúrate de tener un 'idReporte' en los datos
      'Reporte': reporte,
      'Estado': 'Inactivo',
    };
  }

  // Llamamos a la función de editar la actividad (pasamos el mapa con los datos)
  Future<void> _editarActividad(Map<String, dynamic> reporte) async {
    final db = DatabaseHelper();
    await db.editarActividad(reporte);
  }

  void _finalizarActividad(Map<String, dynamic> actividad) {
    TextEditingController reporteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Finalizar Actividad'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Por favor, redacta el reporte para finalizar.'),
              const SizedBox(height: 10),
              TextField(
                controller: reporteController,
                decoration: const InputDecoration(
                  labelText: 'Reporte',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Crear el reporte
                final reporte = _crearReporte(actividad, reporteController.text);
                
                // Llamamos a la función para actualizar la actividad en la base de datos
                _editarActividad(reporte);

                

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Actividad finalizada.')),
                );
              },
              child: const Text('Enviar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDetallesActividad(Map<String, dynamic> actividad) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Detalles de la Actividad'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Número de Capacitación: ${actividad['NumCapacitacion']}'),
              Text('Tema: ${actividad['TEMA']}'),
              Text('Clave Región: ${actividad['ClaveRegion']}'),
              Text('Nombre Microregión: ${actividad['NombreRegion']}'),
              Text('Fecha Programada: ${actividad['FechaProgramada']}'),
              Text('Estado: ${actividad['Estado']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _finalizarActividad(actividad);
              },
              child: const Text('Finalizar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actividades Activas'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: widget.actividades
            .where((actividad) => actividad['Estado'] == 'Activo')
            .map((actividad) {
          return Card(
            child: ListTile(
              title: Text('Fecha: ${actividad['FechaProgramada']}'),
              subtitle: Text('Tema: ${actividad['TEMA']}'),
              onTap: () => _mostrarDetallesActividad(actividad),
            ),
          );
        }).toList(),
      ),
    );
  }
}
