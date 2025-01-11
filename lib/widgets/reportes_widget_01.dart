import 'package:fepi_local/routes/getSavedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fepi_local/database/database_gestor.dart';  // Asegúrate de importar la función

class ActividadesPage extends StatefulWidget {
  @override
  _ActividadesPageState createState() => _ActividadesPageState();
}

class _ActividadesPageState extends State<ActividadesPage> {
  int? idUsuario;  // Almacenar el idUsuario

  // Map para almacenar los reportes
  final List<Map<String, String>> reportes = [];

  // Controlador para el campo del reporte
  final TextEditingController reporteController = TextEditingController();

  // Método para abrir el pop-up
  void _showReporteDialog(Map<String, String> actividad) {
    reporteController.clear(); // Limpiar el campo antes de usar
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Agregar Reporte: ${actividad["Actividad"]}'),
          content: TextField(
            controller: reporteController,
            decoration: InputDecoration(
              labelText: "Escribe tu reporte aquí",
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cerrar pop-up
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (reporteController.text.isNotEmpty) {
                  // Agregar el reporte al mapa
                  setState(() {
                    reportes.add({
                      "ID": actividad["id_ActividadAcomp"]!,
                      "Reporte": reporteController.text,
                      "Actividad": actividad["Actividad"]!,
                       // Ahora directamente se usa "id_ActividadAcomp"
                      "Fecha": actividad["Fecha"]!,
                    });

                    // Cambiar el estado de la actividad a "terminado"
                    actividad["Estado"] = "terminado";
                  });
                  final db= await DatabaseHelper();
                  // Llamamos a la función para actualizar el estado y registrar el reporte
                  await db.cambiarEstadoYRegistrarReporte(
                    int.parse(actividad["id_ActividadAcomp"]!),  // id_ActividadAcomp directamente desde el mapa
                    idUsuario!,  // idUsuario
                    reporteController.text,  // Contenido del reporte
                    "Figura Educativa",  // Esto puede ser personalizado según sea necesario
                  );

                  Navigator.pop(context); // Cerrar pop-up
                }
                Navigator.pop(context);
              },
              child: Text("Enviar"),
            ),
          ],
        );
      },
    );
  }

  // Llamar a la función obtenerActividadesPorUsuario
  Future<Map<String, List<Map<String, dynamic>>>> _obtenerActividades() async {
    final db = await DatabaseHelper();

    // Obtener el idUsuario desde SharedPreferences
    final prefs = await getSavedPreferences();
    idUsuario = prefs['id_Usuario'] ?? 0;

    if (idUsuario == null) {
      throw Exception("No se encontró el idUsuario en SharedPreferences");
    }

    return await db.obtenerActividadesPorUsuario(idUsuario!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Actividades'),
      ),
      body: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
        future: _obtenerActividades(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Muestra un cargando mientras obtiene los datos
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay actividades disponibles.'));
          }

          // Mapeo de actividades a un formato de lista
          var actividades = snapshot.data!.values.expand((e) => e).toList();
          print(actividades); // Imprime la lista de actividades
          return ListView(
            children: actividades
                .where((actividad) => actividad['estado'] == 'activo')
                .map((actividad) {
              return Card(
                margin: EdgeInsets.all(10),
                elevation: 5,
                child: ListTile(
                  title: Text(actividad["nombreEC"]!),
                  subtitle: Text("Fecha: ${actividad["fecha"]} | Hora: ${actividad["hora"]}"),
                  trailing: ElevatedButton(
                    onPressed: () => _showReporteDialog({
                      "Actividad": actividad["nombreEC"]!,
                      "id_ActividadAcomp": actividad["id_ActividadAcomp"].toString(),  // Pasar directamente el id_ActividadAcomp
                      "Fecha": actividad["fecha"]!,
                      "Estado": actividad["estado"]!,
                    }),
                    child: Text("Reportar"),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
