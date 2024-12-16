
import 'package:fepi_local/routes/go_rute.dart';
import 'package:flutter/material.dart';


void main() async {
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
