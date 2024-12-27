import 'package:fepi_local/constansts/app_colors.dart';
import 'package:fepi_local/constansts/app_text_styles.dart';
import 'package:fepi_local/widgets/card_info.dart';
import 'package:fepi_local/widgets/search_filter_widget2.dart';
import 'package:flutter/material.dart';

class ScreenPantallaPl004_01 extends StatelessWidget {
  static const String routeName = '/screen_pantalla_pl004_01';
  const ScreenPantallaPl004_01({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: const [
            
            Text('ECAR'),
          ],
        ),
        titleTextStyle: AppTextStyles.primaryRegular(color: AppColors.color1),
        backgroundColor: AppColors.color3,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SizedBox(
              child: CardInfo(
            text: 'Ubi asignada',
          )),
          Padding(
            padding: EdgeInsets.only(top: 80),
            child: SearchFilterWidget2(
              data: [
                {
                  'NombreCompleto': 'Juan',
                  'Rol': 'EC',
                  'Ubicacion': 'Microrregión A, Región 1, Comunidad X',
                  'Situacion': 'En práctica educativa',
                  'TipoServicio': 'Primaria',
                  'Contexto': 'Mestizo',
                  'Estatus': 'Activo'
                },
                {
                  'NombreCompleto': 'María López',
                  'Rol': 'ECA',
                  'Ubicacion': 'Microrregión B, Región 2, Comunidad Y',
                  'Situacion': 'Formación dual',
                  'TipoServicio': 'Secundaria',
                  'Contexto': 'Indígena',
                  'Estatus': 'Activo'
                },
                {
                  'NombreCompleto': 'Carlos Gómez',
                  'Rol': 'ECAR',
                  'Ubicacion': 'Aún no asignado',
                  'Situacion': 'Aspirante en formación',
                  'TipoServicio': 'Prescolar',
                  'Contexto': 'Migrante',
                  'Estatus': 'Inactivo'
                },
                // Agregar más elementos según sea necesario
              ],
            ),
          ),
        ],
      ),
    );
  }
}
