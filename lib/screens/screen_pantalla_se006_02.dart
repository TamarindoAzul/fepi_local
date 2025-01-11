import 'dart:convert';
import 'dart:io';
import 'package:fepi_local/database/database_gestor.dart';
import 'package:fepi_local/routes/getSavedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fepi_local/constansts/app_colors.dart';
import 'package:fepi_local/constansts/app_text_styles.dart';

class ScreenPantallaSe006_02 extends StatefulWidget {
  static const String routeName = '/screen_pantalla_se006_02';

  const ScreenPantallaSe006_02({super.key});

  @override
  State<ScreenPantallaSe006_02> createState() => _ReportesPantallaSe006_01();
}

class _ReportesPantallaSe006_01 extends State<ScreenPantallaSe006_02> {
  final List<Map<String, String>> historialEnvios = [];

  /// Convertir un blob codificado en base64 a un archivo PDF y devolver la ruta del archivo
  Future<String> _convertBlobToPdf(String blobData, String fileName) async {
    final decodedBytes = base64Decode(blobData);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName.pdf');
    await file.writeAsBytes(decodedBytes);
    return file.path;
  }

  /// Abrir el visor de PDF
  void _verReporte(String blobData) async {
    final filePath = await _convertBlobToPdf(blobData, 'reporte_temporal');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReporteViewerScreen2(reportePath: filePath),
      ),
    );
  }

  /// Cargar el historial de envíos desde la base de datos
  Future<void> _cargarHistorialEnvios() async {
    final prefs = await getSavedPreferences();
    final db = await DatabaseHelper();
    final reportes = await db
        .obtenerHistorialEnviosPorUsuarioDEP(prefs['id_Usuario'] ?? 0);

    setState(() {
      historialEnvios.clear();
      historialEnvios.addAll(
        reportes
            .where((reporte) =>
                reporte['Periodo'] != null &&
                reporte['Reporte'] != null &&
                reporte['Estado'] != null)
            .map((reporte) => {
                  'Periodo': reporte['Periodo'] as String,
                  'Reporte': reporte['Reporte'] as String,
                  'Estado': reporte['Estado'] as String,
                }),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _cargarHistorialEnvios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Reportes'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: AppColors.color1),
          onPressed: () => Navigator.pop(context),
        ),
        titleTextStyle: AppTextStyles.primaryRegular(color: AppColors.color1),
        backgroundColor: AppColors.color3,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: historialEnvios.length,
        itemBuilder: (context, index) {
          final envio = historialEnvios[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 4.0,
            child: ListTile(
              leading: Icon(Icons.file_copy, color: AppColors.color2),
              title: Text(
                'Periodo: ${envio['Periodo']}',
                style: AppTextStyles.primaryRegular(color: AppColors.color3),
              ),
              subtitle: Text(
                'Estado: ${envio['Estado']}',
                style: AppTextStyles.secondRegular(color: AppColors.color2),
              ),
              onTap: () => _verReporte(envio['Reporte']!),
            ),
          );
        },
      ),
    );
  }
}

class ReporteViewerScreen2 extends StatelessWidget {
  final String reportePath;

  const ReporteViewerScreen2({required this.reportePath, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualizador de Reporte'),
        centerTitle: true,
      ),
      body: PDFView(
        filePath: reportePath,
        autoSpacing: true,
        enableSwipe: true,
        swipeHorizontal: false,
        onError: (error) {
          print('Error en el visor de PDF: $error');
        },
      ),
    );
  }
}
