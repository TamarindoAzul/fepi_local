import 'package:flutter/material.dart';
import 'package:fepi_local/constansts/app_colors.dart';
import 'package:fepi_local/constansts/app_text_styles.dart';
import 'package:fepi_local/widgets/card_info.dart';
import 'package:fepi_local/widgets/search_filter_widget2.dart';
import 'package:fepi_local/database/database_gestor.dart';

class ScreenPantallaPl004_01 extends StatefulWidget {
  static const String routeName = '/screen_pantalla_pl004_01';

  const ScreenPantallaPl004_01({super.key});

  @override
  _ScreenPantallaPl004_01State createState() => _ScreenPantallaPl004_01State();
}

class _ScreenPantallaPl004_01State extends State<ScreenPantallaPl004_01> {
  List<Map<String, String>> _data = [];
  bool _isLoading = true;
  Map<String, String> result = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final dbHelper = DatabaseHelper();

    try {
      await dbHelper.database;
      var resultFromDb = await dbHelper.getUbicacionPorUsuario(1);
      var personal = await dbHelper.getResponsablesPorUsuario(4);

      setState(() {
        result = resultFromDb ?? {};
        _data = personal.map((item) {
          return item.map((key, value) => MapEntry(key, value.toString()));
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      // Manejo de errores al cargar datos
      setState(() {
        _isLoading = false;
      });
      print('Error al cargar datos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extraer un valor específico de result para mostrarlo
    String extractedValue =
        result.isNotEmpty ? result['nombre'] ?? 'Valor no encontrado' : 'Cargando...';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Región para ECAR'),
        titleTextStyle: AppTextStyles.primaryRegular(color: AppColors.color1),
        backgroundColor: AppColors.color3,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SizedBox(
            child: CardInfo(
              text: extractedValue,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SearchFilterWidget2(
                    data: _data,
                  ),
          ),
        ],
      ),
    );
  }
}
