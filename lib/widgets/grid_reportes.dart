import 'package:fepi_local/constansts/app_colors.dart';
import 'package:fepi_local/database/database_gestor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart'; // Librería para ver PDF
import 'package:intl/intl.dart'; // Para manejo de fechas
import 'package:sqflite/sqflite.dart'; // Asegúrate de importar la biblioteca de sqflite

class CuadriculaDeCards extends StatefulWidget {
  final int idUsuario=1;

  CuadriculaDeCards();

  @override
  _CuadriculaDeCardsState createState() => _CuadriculaDeCardsState();
}

class _CuadriculaDeCardsState extends State<CuadriculaDeCards> {
  Map<String, Map<String, String>> datos = {};
  String filtroFe = 'Todos';
  bool ordenAscendente = true;
  DateTime? fechaInicio;
  DateTime? fechaFin;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    final db = await DatabaseHelper(); // Asegúrate de abrir tu base de datos correctamente
    datos = await db.obtenerReportesPorUsuario(1);
    setState(() {}); // Actualiza el estado para redibujar la interfaz con los nuevos datos
  }

  @override
  Widget build(BuildContext context) {
    List<MapEntry<String, Map<String, String>>> listaDatos = datos.entries.toList();

    // Filtrar por 'Fe'
    if (filtroFe != 'Todos') {
      listaDatos = listaDatos.where((entrada) => entrada.value['Fe'] == filtroFe).toList();
    }

    // Filtrar por rango de fechas
    if (fechaInicio != null && fechaFin != null) {
      listaDatos = listaDatos.where((entrada) {
        DateTime fecha = DateTime.parse(entrada.value['Fecha']!);
        return fecha.isAfter(fechaInicio!) && fecha.isBefore(fechaFin!);
      }).toList();
    }

    // Ordenar por fecha
    listaDatos.sort((a, b) {
      DateTime fechaA = DateTime.parse(a.value['Fecha']!);
      DateTime fechaB = DateTime.parse(b.value['Fecha']!);
      return ordenAscendente ? fechaA.compareTo(fechaB) : fechaB.compareTo(fechaA);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('REPORTES'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                filtroFe = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'Todos', child: Text('Todos')),
              PopupMenuItem(value: 'A', child: Text('Fe A')),
              PopupMenuItem(value: 'B', child: Text('Fe B')),
              PopupMenuItem(value: 'C', child: Text('Fe C')),
            ],
          ),
          IconButton(
            icon: Icon(ordenAscendente ? Icons.arrow_upward : Icons.arrow_downward),
            onPressed: () {
              setState(() {
                ordenAscendente = !ordenAscendente;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () async {
              DateTimeRange? rango = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (rango != null) {
                setState(() {
                  fechaInicio = rango.start;
                  fechaFin = rango.end;
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 3 / 4,
          ),
          itemCount: listaDatos.length,
          itemBuilder: (context, index) {
            final entrada = listaDatos[index];
            final actividad = entrada.value['Actividad'];
            final fecha = entrada.value['Fecha'];
            final reporte = entrada.value['Reporte'];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VistaPDF(rutaPDF: reporte!),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.file_present, size: 48, color: AppColors.color3),
                    SizedBox(height: 16),
                    Text(
                      actividad!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      fecha!,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class VistaPDF extends StatelessWidget {
  final String rutaPDF;

  VistaPDF({required this.rutaPDF});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vista PDF')),
      body: PDFView(
        filePath: rutaPDF,
      ),
    );
  }
}
