import 'package:fepi_local/database/database_gestor.dart';
import 'package:fepi_local/database/database_helper.dart';
import 'package:fepi_local/database/inyeccion.dart';
import 'package:fepi_local/routes/go_rute.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  // Inicializar la base de datos local
  final dbHelper = DatabaseHelper();
  await dbHelper.database;
  //for(int i=1; i<=4; i++){insertMassiveDataForAllTables();}
  //await dbHelper.printAllTables();
  //await dbHelper.insetrardependenciap();

  // Sincronizar con la base de datos remota
  //final dbService = DatabaseService();
  try {
    //await dbService.syncAllTables(); // Sincroniza todas las tablas
    //await dbHelper.printAllTables();
  } catch (e) {
    print("Error durante la sincronización: $e");
  }
  //await dbHelper.printAllTables();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
