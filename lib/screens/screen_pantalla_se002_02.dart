import 'package:fepi_local/widgets/notificacionfechas_FE.dart';
import 'package:flutter/material.dart';
import 'package:fepi_local/constansts/app_colors.dart';
import 'package:fepi_local/constansts/app_text_styles.dart';


class ScrenPantallaSe00202 extends StatelessWidget {
  static const String routeName = '/screen_pantalla_se002_02';
  const ScrenPantallaSe00202({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actividades asignadas'),
        titleTextStyle: AppTextStyles.primaryRegular(color: AppColors.color1),
        backgroundColor: AppColors.color3,
        centerTitle: true,
      ),
      body: Stack(
        children: [ActividadesTable(),]
        
      )
    );
  }
}