import 'package:fepi_local/constansts/app_colors.dart';
import 'package:fepi_local/constansts/app_text_styles.dart';
import 'package:fepi_local/widgets/angenda_widget.dart';
import 'package:fepi_local/widgets/reportes_widget_01.dart';
import 'package:flutter/material.dart';

class SreenPantallaSe003_01 extends StatefulWidget {
  static const String routeName = '/screen_pantalla_se003_0122';
  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<SreenPantallaSe003_01>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
   // Fecha seleccionada por el usuario

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 2, vsync: this); // Número de pestañas
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SEGUIMIENTO DE DATOS'),
        titleTextStyle: AppTextStyles.primaryRegular(color: AppColors.color1),
        backgroundColor: AppColors.color3,
        centerTitle: true,
        bottom: TabBar(
          indicatorColor: AppColors.color1,
          labelStyle: AppTextStyles.secondRegular(color:AppColors.color4),
          
          controller: _tabController,
          tabs: const [
            Tab(text: 'Agenda'),
            Tab(text: 'Reportes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AgendaWidget(),
          ActividadesPage(),
        ],
      ),
    );
  }
}