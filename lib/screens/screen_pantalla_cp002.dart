import 'package:fepi_local/widgets/captacion_inicial_page.dart';
import 'package:fepi_local/widgets/captacion_inicial_page_ECAR.dart';
import 'package:flutter/material.dart';
import 'package:fepi_local/constansts/app_colors.dart';
import 'package:fepi_local/constansts/app_text_styles.dart';
import 'package:go_router/go_router.dart';

class ScreenPantallaCp002 extends StatelessWidget {
  static const String routeName = '/screen_pantalla_cp002';
  const ScreenPantallaCp002({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.color3,
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            // Opción 2: Capacitación Inicial
            ListTile(
              leading: const Icon(Icons.arrow_back_rounded),
              title: const Text('Regresar'),
              onTap: () {
                context.go('/screen_Inicio_ECA');
              },
            ),
            // Opción 2: Capacitación Inicial
            ListTile(
              leading: const Icon(Icons.work),
              title: const Text('Capacitación Inicial'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CapacitationInitialPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.work),
              title: const Text('Capacitación Inicial ECA'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CapacitationInitialPageECAR(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          '',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
