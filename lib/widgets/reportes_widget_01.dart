import 'package:flutter/material.dart';

class ActividadesPage extends StatefulWidget {
  @override
  _ActividadesPageState createState() => _ActividadesPageState();
}

class _ActividadesPageState extends State<ActividadesPage> {
  // Map inicial con las actividades
  final List<Map<String, String>> actividades = [
    {"Actividad": "Revisar informe", "FE": "A1", "Fecha": "2024-12-16", "Estado": "activo"},
    {"Actividad": "Llamada con cliente", "FE": "A2", "Fecha": "2024-12-15", "Estado": "terminado"},
    {"Actividad": "Actualizar sistema", "FE": "A3", "Fecha": "2024-12-14", "Estado": "activo"},
  ];

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
              onPressed: () {
                if (reporteController.text.isNotEmpty) {
                  // Agregar el reporte al mapa
                  setState(() {
                    reportes.add({
                      "ID": DateTime.now().millisecondsSinceEpoch.toString(),
                      "Reporte": reporteController.text,
                      "Actividad": actividad["Actividad"]!,
                      "FE": actividad["FE"]!,
                      "Fecha": actividad["Fecha"]!,
                    });

                    // Cambiar el estado de la actividad a terminado
                    actividad["Estado"] = "terminado";
                  });
                  Navigator.pop(context); // Cerrar pop-up
                }
              },
              child: Text("Enviar"),
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
        title: Text('Gestión de Actividades'),
      ),
      body: ListView(
        children: actividades
            .where((actividad) => actividad["Estado"] == "activo")
            .map((actividad) {
          return Card(
            margin: EdgeInsets.all(10),
            elevation: 5,
            child: ListTile(
              title: Text(actividad["Actividad"]!),
              subtitle: Text("FE: ${actividad["FE"]} | Fecha: ${actividad["Fecha"]}"),
              trailing: ElevatedButton(
                onPressed: () => _showReporteDialog(actividad),
                child: Text("Reportar"),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
