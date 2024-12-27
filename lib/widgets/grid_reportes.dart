import 'package:fepi_local/constansts/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart'; // Librería para ver PDF
import 'package:intl/intl.dart'; // Para manejo de fechas

class CuadriculaDeCards extends StatefulWidget {
  @override
  _CuadriculaDeCardsState createState() => _CuadriculaDeCardsState();
}

class _CuadriculaDeCardsState extends State<CuadriculaDeCards> {
  final Map<String, Map<String, String>> datos = {
    '1': {'Reporte': 'reporte1.pdf', 'Actividad': 'Actividad 1', 'Fe': 'A', 'Fecha': '2024-12-20'},
    '2': {'Reporte': 'reporte2.pdf', 'Actividad': 'Actividad 2', 'Fe': 'B', 'Fecha': '2024-12-15'},
    '3': {'Reporte': 'reporte3.pdf', 'Actividad': 'Actividad 3', 'Fe': 'A', 'Fecha': '2025-01-05'},
    '4': {'Reporte': 'reporte4.pdf', 'Actividad': 'Actividad 4', 'Fe': 'C', 'Fecha': '2025-02-04'},
    '5': {'Reporte': 'reporte5.pdf', 'Actividad': 'Actividad 5', 'Fe': 'B', 'Fecha': '2024-11-10'},
    '6': {'Reporte': 'reporte6.pdf', 'Actividad': 'Actividad 6', 'Fe': 'A', 'Fecha': '2025-03-01'},
  };

  String filtroFe = 'Todos';
  bool ordenAscendente = true;
  DateTime? fechaInicio;
  DateTime? fechaFin;

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

void main() {
  runApp(MaterialApp(
    home: CuadriculaDeCards(),
  ));
}
