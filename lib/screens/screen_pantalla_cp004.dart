import 'package:fepi_local/database/database_gestor.dart';
import 'package:fepi_local/widgets/calendario.dart';
import 'package:fepi_local/widgets/reportes.dart';
import 'package:fepi_local/widgets/tabla_matriz_act.dart';
import 'package:flutter/material.dart';
import 'package:fepi_local/constansts/app_colors.dart';
import 'package:fepi_local/constansts/app_text_styles.dart';

class ScreenPantallaCp004 extends StatelessWidget {
  static const String routeName = '/screen_pantalla_cp004';
  const ScreenPantallaCp004({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Número de pestañas
      child: Scaffold(
        appBar: AppBar(
          title: Text('GESTION COLEGIADOS ECA'),
          titleTextStyle: AppTextStyles.primaryRegular(color: AppColors.color1),
          backgroundColor: AppColors.color3,
          centerTitle: true,
          bottom: TabBar(
            labelColor: AppColors.color1,
            unselectedLabelColor: AppColors.color2,
            labelStyle: AppTextStyles.secondRegular(fontSize: 15),
            tabs: [
              Tab(text: 'Matriz de Actividades'),
              Tab(text: 'Actividades'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Primer contenido de la pestaña
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TablaMatrizAct(), // Tu widget de matriz de actividades
            ),
            // Segundo contenido de la pestaña
            Padding(
              padding: EdgeInsets.all(8.0),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                // Llamas a la función que obtendrá los datos desde la base de datos
                future: DatabaseHelper().obtenerActividadesCAPPorUsuario(1), // Pasa el idUsuario adecuado
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error al cargar datos'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No hay actividades disponibles'));
                  } else {
                    return ActividadCardWidget(
                      actividades: snapshot.data!, // Usas los datos obtenidos
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
