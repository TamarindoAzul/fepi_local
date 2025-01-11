import 'package:fepi_local/database/database_gestor.dart';
import 'package:fepi_local/routes/getSavedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:fepi_local/constansts/app_colors.dart';
import 'package:fepi_local/constansts/app_text_styles.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sqflite/sqflite.dart';
import 'package:go_router/go_router.dart';

class ScreenPantallaBe002 extends StatefulWidget {
  static const String routeName = '/screen_pantalla_be002';
  const ScreenPantallaBe002({super.key});

  @override
  _ScreenPantallaBe002State createState() => _ScreenPantallaBe002State();
}

class _ScreenPantallaBe002State extends State<ScreenPantallaBe002> {
  Map<String, List<Map<String, dynamic>>> paymentData = {};

  @override
  void initState() {
    super.initState();
    _loadPaymentData();
  }

  // Función para cargar los pagos desde la base de datos
  Future<void> _loadPaymentData() async {
    // Aquí debes obtener tu instancia de la base de datos
    final db = DatabaseHelper(); // Ajusta la ruta de la base de datos

    // Obtén los pagos por usuario (puedes reemplazar '1' con el id de usuario que necesites)
    final prefs = await getSavedPreferences();
    Map<String, List<Map<String, dynamic>>> pagos = await db.obtenerPagosPorUsuario(prefs['id_Usuario'] ?? 0);

    setState(() {
      paymentData = pagos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_rounded, color: AppColors.color1,),onPressed:(){context.pop();}),
        title: Text('Calendario de Pagos'),
        titleTextStyle: AppTextStyles.primaryRegular(color: AppColors.color1),
        backgroundColor: AppColors.color3,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Calendario
          TableCalendar(
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: DateTime.now(),
            eventLoader: (day) {
              final dayString = '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
              return paymentData[dayString] ?? [];
            },
            onDaySelected: (selectedDay, focusedDay) {
              final selectedDayString = '${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}';
              final selectedPayments = paymentData[selectedDayString];
              if (selectedPayments != null && selectedPayments.isNotEmpty) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    titleTextStyle: AppTextStyles.secondBold(),
                    contentTextStyle: AppTextStyles.secondRegular(color: AppColors.color2,fontSize: 20),
                    title: Center(child: Text('Pago del $selectedDayString')),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: selectedPayments.map((payment) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tipo de pago:\n${payment['tipopago']}'),
                            Text('Monto:\n\$${payment['monto']}'),
                            SizedBox(height: 8),
                          ],
                        );
                      }).toList(),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cerrar'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          // Historial de pagos
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: paymentData.entries
                    .where((entry) {
                      final entryDate = DateTime.parse(entry.key);
                      return entryDate.isBefore(DateTime.now());
                    })
                    .map((entry) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        'Pago del ${entry.key}',
                        style: AppTextStyles.secondBold(color: AppColors.color3),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: entry.value.map((payment) {
                          return Text(
                            'Tipo: ${payment['tipopago']} - Monto: \$${payment['monto']}', style: AppTextStyles.secondMedium(color:AppColors.color2),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Función para obtener pagos por usuario y organizar los datos por fecha
Future<Map<String, List<Map<String, dynamic>>>> obtenerPagosPorUsuario(int idUsuario, Database db) async {
  final List<Map<String, dynamic>> results = await db.query(
    'PagosFechas',
    where: 'id_Usuario = ?',
    whereArgs: [idUsuario],
  );

  Map<String, List<Map<String, dynamic>>> pagosPorFecha = {};

  for (var row in results) {
    String fecha = row['fecha']; // La fecha es un String en formato 'yyyy-MM-dd'
    String tipoPago = row['tipoPago'];
    double monto = row['monto'];

    if (!pagosPorFecha.containsKey(fecha)) {
      pagosPorFecha[fecha] = [];
    }

    pagosPorFecha[fecha]?.add({
      'tipopago': tipoPago,
      'monto': monto,
    });
  }

  return pagosPorFecha;
}
