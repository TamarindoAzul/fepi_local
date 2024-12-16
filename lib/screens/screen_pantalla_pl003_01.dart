import 'package:fepi_local/prueba/ECAdb.dart';
import 'package:flutter/material.dart';
import 'package:fepi_local/constansts/app_colors.dart';
import 'package:fepi_local/constansts/app_text_styles.dart';
import 'package:fepi_local/widgets/card_info.dart';
import 'package:fepi_local/widgets/search_filter_widget.dart';
// Importar la clase de la base de datos

class ScreenPantallaPl003_01 extends StatefulWidget {
  static const String routeName = '/screen_pantalla_pl003_01';

  const ScreenPantallaPl003_01({super.key});

  @override
  _ScreenPantallaPl003_01State createState() => _ScreenPantallaPl003_01State();
}

class _ScreenPantallaPl003_01State extends State<ScreenPantallaPl003_01> {
  String microrregion="Tepito";
  List<Map<String, String>> _data = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = PersonalECDB();
    db.inyectarDatosDePrueba();
    final personal = await db.getPersonal();
    setState(() {
      // Convertir cada mapa a Map<String, String>
      _data = personal.map((item) {
        return item.map((key, value) => MapEntry(key, value.toString()));
      }).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Microrregión'),
        titleTextStyle: AppTextStyles.primaryRegular(color: AppColors.color1),
        backgroundColor: AppColors.color3,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SizedBox(child: CardInfo(text: '${microrregion}')),
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SearchFilterWidget(
                    data: _data, 
                  ),
          ),
        ],
      ),
    );
  }
}
